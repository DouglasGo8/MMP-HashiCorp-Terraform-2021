#Output Specific to Custom VPC
output "webapp_out_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.webapp-vpc.id
}

output "webapp_out_private_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.webapp-private-subnet-01.id
}

output "webapp_out_private_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.webapp-private-subnet-02.id
}

output "webapp_out_public_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.webapp-public-subnet-01.id
}

output "webapp_out_public_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.webapp-public-subnet-02.id
}
