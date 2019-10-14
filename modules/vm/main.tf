locals {
  
  //credentials = file("cred.json")

  project_id = lower(trimspace(var.project_id))

  //credentials = file("credentials.json")

  # Environment parameters
  app_name        = lower(trimspace(var.app_name))
  environment     = lower(trimspace(var.environment))
  business_unit   = lower(trimspace(var.business_unit))
  #service_account = "${local.application_layer}@${local.project_id}.iam.gserviceaccount.com"
  service_account = lower(trimspace(var.service_account))

  # Application parameters
  application_layer       = lower(trimspace(var.application_layer))
  image_name              = lower(trimspace(var.image_name))
  metadata_startup_script = var.metadata_startup_script

  # Machine parameters
  machine_type        = var.machine_type
  disk_size_gb        = var.disk_size_gb
  disk_type           = var.disk_type
  region              = var.region
  number_of_instances = var.number_of_instances

  # Shared VPC host project and subnetwork
  network_tags = concat(["demo-interconnect", "demo-shared-services"], var.network_tags)
  # host_project = local.shared_vpc_map[var.environment]
  # vpc_prefix   = "vpc-"
  # subnet       = "${local.host_project}-${local.vpc_prefix}internal-${local.region}"
  # shared_vpc_map = {
  #   test   = "vpc-test-1"
  # }
}

/******************************************
  Instance template
 *****************************************/
resource "google_compute_instance_template" "instance_template" {
  project      = local.project_id
  name         = "${local.app_name}-template"
  machine_type = local.machine_type
  region       = local.region

  labels = {
    environment   = local.environment
    business_unit = local.business_unit
    app_name      = local.app_name
  }

  disk {
    source_image = local.image_name
    auto_delete  = true
    boot         = true

    disk_size_gb = local.disk_size_gb
    type         = local.disk_type
  }

  metadata_startup_script = local.metadata_startup_script

  network_interface {
    network = "default"
    #subnetwork         = "default" #local.subnet
    #subnetwork_project = local.host_project
  }

  service_account {
    email  = local.service_account
    scopes = []
  }

  tags = local.network_tags
}

/******************************************
  Instance group
 *****************************************/
resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  provider           = "google-beta"
  project            = local.project_id
  name               = "${local.app_name}-instance-group-manager"
  base_instance_name = "${local.app_name}-instance"
  region             = local.region
  target_size        = local.number_of_instances

  version {
    name              = var.version_name
    instance_template = "${google_compute_instance_template.instance_template.self_link}"
  }

  update_policy {
    type                  = var.update_policy.type
    minimal_action        = var.update_policy.minimal_action
    max_unavailable_fixed = var.update_policy.max_unavailable_fixed
    min_ready_sec         = var.update_policy.min_ready_sec
  }

  dynamic "named_port" {
    for_each = [for n in var.named_ports : {
      name = n.name
      port = n.port
    }]

    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }
}