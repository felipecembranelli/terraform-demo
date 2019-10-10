output "instance_template" {
  description = "The ID of the instance template provisioned."
  value       = google_compute_instance_template.instance_template.name
}

# output "instance_group_manager" {
#   value = google_compute_region_instance_group_manager.instance_group_manager
# }

# output "instance_template_attributes" {
#   value = google_compute_instance_template.instance_template
# }