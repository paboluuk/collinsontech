output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP server"
}

output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "Domain name of the load balancer"
}