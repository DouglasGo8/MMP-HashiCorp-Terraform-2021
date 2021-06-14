output "webapp-out-load_balancer_output" {
  value = aws_lb.webapp-app-lb.dns_name
}
