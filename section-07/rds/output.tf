output "rds" {
  value = aws_db_instance.db-inst01-mariadb.endpoint
}
