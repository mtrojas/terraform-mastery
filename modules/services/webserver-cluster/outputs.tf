output "alb_dns_name" {
  value       = aws_lb.alb-servers.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.asg-servers.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.sg-alb.id
  description = "The ID of the Security Group attached to the Application Load Balancer"
}
