variable "project_id" {
  description = "The project ID to deploy the VMs"
  default = "mlb-local"
}

variable "app_name" {
  description = "The name of the application that will be deployed into the VMs. Used to identify the created resources."
  default = "demovm2"
}

variable "environment" {
  description = "Environment will determine the network that the VMs will be placed."
  default = "test"
}

variable "service_account" {
  description = "service account used."
  default = "767754503635-compute@developer.gserviceaccount.com"
}

variable "business_unit" {
  description = "Business unit that the VMs belongs to"
  default = "bu2"
}

variable "machine_type" {
  description = "The machine type to create. To create a machine with a custom type (such as extended memory), format the value like custom-VCPUS-MEM_IN_MB like custom-6-20480 for 6 vCPU and 20GB of RAM."
  default     = "n1-standard-1"
}

variable "disk_size_gb" {
  description = "The VMs disk size in gigabytes."
  default     = 200
}

variable "disk_type" {
  description = "The GCE disk type. Can be either 'pd-ssd', 'local-ssd', or 'pd-standard'"
  default     = "PERSISTENT"
}

variable "image_name" {
  description = "The image from which to initialize the VMs. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}"
  default     = "centos-7-v20190729"
}

variable "region" {
  description = "Region that the VMs will be placed."
  default     = "us-central1"
}

variable "application_layer" {
  description = "Define if the application will be 'public' or 'private'. This will determine which service account to use for the VM and consequently the firewall rules that will be enforced."
  default     = "private"
}

variable "number_of_instances" {
  description = "The number of instances that will be created."
  default     = 1
}

variable "network_tags" {
  description = "Network tags to be added to created VMs"
  default     = []
}

variable "version_name" {
  description = "Name of the version to be used when update the image."
  default     = "1.0"
}

variable "metadata_startup_script" {
  description = "A Startup Script to execute when the server first boots."
  default     = ""
}

variable "update_policy" {
  description = "The update policy for the managed instance group."
  type        = map
  default = {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_unavailable_fixed = 5
    min_ready_sec         = 30
  }
}

variable "named_ports" {
  description = "The named port configuration"
  default     = []
}
