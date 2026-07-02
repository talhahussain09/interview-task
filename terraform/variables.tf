variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
  default     = "interview-task-key"
}

variable "public_key_path" {
  description = "Local path to public SSH key"
  type        = string
  default     = "C:\\Users\\xFlow\\.ssh\\devops-task-key.pub"
}

variable "admin_ip_cidr" {
  description = "Your public IP address in CIDR format, for example 39.x.x.x/32"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 10
}