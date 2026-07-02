output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.web.public_ip}"
}

output "health_check_url" {
  description = "Application health check URL"
  value       = "http://${aws_instance.web.public_ip}/health"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/devops-task-key ubuntu@${aws_instance.web.public_ip}"
}