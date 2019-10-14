variable "project_id" {
  description = "The project ID to manage the Cloud SQL resources"
}

variable "name" {
  description = "The name of the Cloud SQL resources"
}

variable "environment" {
  description = "The environment to create Cloud SQL resources"
  default     = "sbx"
}


variable "database_version" {
  description = "The database version to use"
  default     = "POSTGRES_9_6"
}

variable "region" {
  description = "The region of the Cloud SQL resources"
  default     = "us-east4"
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `us-east4-a`, `us-east4-c`."
  default     = "us-east4-a"
}

// Master
variable "tier" {
  description = "The tier for the master instance."
  default     = "db-f1-micro"
}

variable "activation_policy" {
  description = "The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size"
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance"
  default     = 300
}

variable "disk_type" {
  description = "The disk type for the master instance."
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the master instance."
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`."
  default     = "stable"
}

variable "user_labels" {
  default     = {}
  description = "The key/value labels for the master instances."
}

variable "enable_backup" {
  description = "Enable backup."
  default     = true
}

variable "enable_binary_log" {
  description = "Enable binary log (only for MySQL instances)."
  default     = false
}

variable "databases" {
  description = "A list of databases to be created in your cluster"
  default = [
    {
      db_name      = "default"
      db_charset   = ""
      db_collation = ""
    }
  ]
}

variable "users" {
  description = "A list of users to be created in your cluster"
  default = [
    {
      name     = "default"
      password = "default"
    }
  ]
}

variable create_timeout {
  description = "The optional timout that is applied to limit long database creates."
  default     = "15m"
}

variable update_timeout {
  description = "The optional timout that is applied to limit long database updates."
  default     = "15m"
}

variable delete_timeout {
  description = "The optional timout that is applied to limit long database deletes."
  default     = "15m"
}


// Read Replica
variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  default     = ""
}

variable "read_replica_size" {
  description = "The size of read replicas"
  default     = 0
}

variable "read_replica_tier" {
  description = "The tier for the read replica instances."
  default     = ""
}

variable "read_replica_zones" {
  description = "The zones for the read replica instancess, it should be something like: `us-east4-a,us-east4-b,us-east4-c`. Given zones are used rotationally for creating read replicas."
  default     = "us-east4-a,us-east4-b,us-east4-c"
}

variable "read_replica_activation_policy" {
  description = "The activation policy for the read replica instances. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "read_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  default     = true
}

variable "read_replica_disk_autoresize" {
  description = "Configuration to increase storage size."
  default     = true
}

variable "read_replica_disk_size" {
  description = "The disk size for the read replica instances."
  default     = 10
}

variable "read_replica_disk_type" {
  description = "The disk type for the read replica instances."
  default     = "PD_SSD"
}

variable "read_replica_pricing_plan" {
  description = "The pricing plan for the read replica instances."
  default     = "PER_USE"
}

variable "read_replica_replication_type" {
  description = "The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  default     = "SYNCHRONOUS"
}

variable "read_replica_maintenance_window_day" {
  description = "The day of week (1-7) for the read replica instances maintenance."
  default     = 1
}

variable "read_replica_maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the read replica instances maintenance."
  default     = 23
}

variable "read_replica_maintenance_window_update_track" {
  description = "The update track of maintenance window for the read replica instances maintenance. Can be either `canary` or `stable`."
  default     = "canary"
}

variable "read_replica_user_labels" {
  default     = {}
  description = "The key/value labels for the read replica instances."
}

// Failover replica
variable "failover_replica" {
  description = "Specify true if the failover instance is required"
  default     = false
}

variable "failover_replica_name_suffix" {
  description = "The optional suffix to add to the failover instance name"
  default     = ""
}

variable "failover_replica_tier" {
  description = "The tier for the failover replica instance."
  default     = ""
}

variable "failover_replica_zone" {
  description = "The zone for the failover replica instance, it should be something like: `us-east4-a`, `us-east4-c`."
  default     = ""
}

variable "failover_replica_activation_policy" {
  description = "The activation policy for the failover replica instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "failover_replica_crash_safe_replication" {
  description = "The crash safe replication is to indicates when crash-safe replication flags are enabled."
  default     = true
}

variable "failover_replica_disk_autoresize" {
  description = "Configuration to increase storage size."
  default     = true
}

variable "failover_replica_disk_size" {
  description = "The disk size for the failover replica instance."
  default     = 10
}

variable "failover_replica_disk_type" {
  description = "The disk type for the failover replica instance."
  default     = "PD_SSD"
}

variable "failover_replica_pricing_plan" {
  description = "The pricing plan for the failover replica instance."
  default     = "PER_USE"
}

variable "failover_replica_replication_type" {
  description = "The replication type for the failover replica instance. Can be one of ASYNCHRONOUS or SYNCHRONOUS."
  default     = "SYNCHRONOUS"
}

variable "failover_replica_maintenance_window_day" {
  description = "The day of week (1-7) for the failover replica instance maintenance."
  default     = 1
}

variable "failover_replica_maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the failover replica instance maintenance."
  default     = 23
}

variable "failover_replica_maintenance_window_update_track" {
  description = "The update track of maintenance window for the failover replica instance maintenance. Can be either `canary` or `stable`."
  default     = "canary"
}

variable "failover_replica_user_labels" {
  default     = {}
  description = "The key/value labels for the failover replica instance."
}
