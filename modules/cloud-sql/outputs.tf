
output "users" {
  description = "User and passwords created for access the database."
  value       = google_sql_user.users
}

output "databases" {
  description = "All attributes for any created databases within the database instance."
  value       = google_sql_database.databases
}

output "database_instance" {
  description = "All attributes for the database instance"
  value       = google_sql_database_instance.default
}

output "database_instance_replica" {
  description = "All attributes for the database instance replica"
  value       = google_sql_database_instance.replicas
}

output "database_instance_failover_replica" {
  description = "All attributes for the database instance failover replica"
  value       = google_sql_database_instance.failover-replica
}