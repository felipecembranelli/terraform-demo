locals {
  // Shared network to be used as private VPC
#   private_network = "projects/${local.shared_vpc_map[var.environment]}/global/networks/${local.shared_vpc_map[var.environment]}-vpc"
#   shared_vpc_map = {
#     sbx    = "mlb-xpn-sbx-c21a"
#     shared = "mlb-xpn-shared-9d4c"
#     npd    = "mlb-xpn-npd-15d1"
#     prod   = "mlb-xpn-prod-5a6e"
#     test   = "mlb-xpn-test-1"
#   }
    private_network = "projects/mlb-local/global/networks/default"

  // All MySQL users can connect only via the Cloud SQL Proxy.
  user_host = "${var.database_version == "MYSQL_5_7" ? "cloudsqlproxy~%" : ""}"

  primary_zone       = "${var.zone}"
  read_replica_zones = "${compact(split(",", var.read_replica_zones))}"

  zone_mapping = {
    enabled  = "${local.read_replica_zones}"
    disabled = "${list(local.primary_zone)}"
  }

  zones_enabled = "${length(local.read_replica_zones) > 0}"
  mod_by        = "${local.zones_enabled ? length(local.read_replica_zones) : 1}"

  zones = "${local.zone_mapping["${local.zones_enabled ? "enabled" : "disabled"}"]}"
}

resource "google_project_service" "sqladmin-api" {
  project = "${var.project_id}"
  service   = "sqladmin.googleapis.com"
  disable_on_destroy = "false"
}

resource "google_sql_database_instance" "default" {
  project          = "${var.project_id}"
  name             = "${var.name}"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  settings {
    tier              = "${var.tier}"
    activation_policy = "${var.activation_policy}"

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.private_network
    }
    

    disk_autoresize = "${var.disk_autoresize}"

    disk_size    = "${var.disk_size}"
    disk_type    = "${var.disk_type}"
    pricing_plan = "${var.pricing_plan}"
    user_labels  = "${var.user_labels}"

    location_preference {
      zone = "${var.zone}"
    }

    maintenance_window {
      day          = "${var.maintenance_window_day}"
      hour         = "${var.maintenance_window_hour}"
      update_track = "${var.maintenance_window_update_track}"
    }

    backup_configuration {
      enabled            = "${var.enable_backup}"
      binary_log_enabled = "${var.enable_binary_log}"
    }
  }

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}

resource "google_sql_database" "databases" {
  count      = "${length(var.databases)}"
  project    = "${var.project_id}"
  name       = "${lookup(var.databases[count.index], "db_name")}"
  charset    = "${lookup(var.databases[count.index], "db_charset", "")}"
  collation  = "${lookup(var.databases[count.index], "db_collation", "")}"
  instance   = "${google_sql_database_instance.default.name}"
  depends_on = ["google_sql_database_instance.default"]
}

resource "random_id" "user-password" {
  keepers = {
    name = "${google_sql_database_instance.default.name}"
  }

  byte_length = 8
  depends_on  = ["google_sql_database_instance.default"]
}

resource "google_sql_user" "users" {
  count      = "${length(var.users)}"
  project    = "${var.project_id}"
  name       = "${lookup(var.users[count.index], "name")}"
  password   = "${lookup(var.users[count.index], "password", random_id.user-password.hex)}"
  host       = "${local.user_host}"
  instance   = "${google_sql_database_instance.default.name}"
  depends_on = ["google_sql_database_instance.default"]
}


// Read replica
resource "google_sql_database_instance" "replicas" {
  count                = "${var.read_replica_size}"
  project              = "${var.project_id}"
  name                 = "${var.name}-replica${var.read_replica_name_suffix}${count.index}"
  database_version     = "${var.database_version}"
  region               = "${var.region}"
  master_instance_name = "${google_sql_database_instance.default.name}"

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = "${var.read_replica_tier}"
    activation_policy = "${var.read_replica_activation_policy}"

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.private_network
    }

    crash_safe_replication = "${var.read_replica_crash_safe_replication}"
    disk_autoresize        = "${var.read_replica_disk_autoresize}"
    disk_size              = "${var.read_replica_disk_size}"
    disk_type              = "${var.read_replica_disk_type}"
    pricing_plan           = "${var.read_replica_pricing_plan}"
    replication_type       = "${var.read_replica_replication_type}"
    user_labels            = "${var.read_replica_user_labels}"

    location_preference {
      zone = "${length(local.zones) == 0 ? "" : "${local.zones[count.index % local.mod_by]}"}"
    }

    maintenance_window {
      day          = "${var.read_replica_maintenance_window_day}"
      hour         = "${var.read_replica_maintenance_window_hour}"
      update_track = "${var.read_replica_maintenance_window_update_track}"
    }
  }

  depends_on = ["google_sql_database_instance.default"]

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}

// Failover replica
resource "google_sql_database_instance" "failover-replica" {
  count                = "${var.failover_replica ? 1 : 0}"
  project              = "${var.project_id}"
  name                 = "${var.name}-failover${var.failover_replica_name_suffix}"
  database_version     = "${var.database_version}"
  region               = "${var.region}"
  master_instance_name = "${google_sql_database_instance.default.name}"

  replica_configuration {
    failover_target = true
  }

  settings {
    tier              = "${var.failover_replica_tier}"
    activation_policy = "${var.failover_replica_activation_policy}"

    ip_configuration {
      ipv4_enabled    = false
      private_network = local.private_network
    }

    crash_safe_replication = "${var.failover_replica_crash_safe_replication}"
    disk_autoresize        = "${var.failover_replica_disk_autoresize}"
    disk_size              = "${var.failover_replica_disk_size}"
    disk_type              = "${var.failover_replica_disk_type}"
    pricing_plan           = "${var.failover_replica_pricing_plan}"
    replication_type       = "${var.failover_replica_replication_type}"
    user_labels            = "${var.failover_replica_user_labels}"

    location_preference {
      zone = "${var.failover_replica_zone}"
    }

    maintenance_window {
      day          = "${var.failover_replica_maintenance_window_day}"
      hour         = "${var.failover_replica_maintenance_window_hour}"
      update_track = "${var.failover_replica_maintenance_window_update_track}"
    }
  }

  depends_on = ["google_sql_database_instance.default"]

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}