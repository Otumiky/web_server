output "database_url" {
  value = var.environment == "prod" ? "db.prod.example.com" : "db.dev.example.com"
}
