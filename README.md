# DevOps Interview Task

## Overview

This repository contains the implementation of a DevOps interview assignment covering:

* Infrastructure provisioning
* CI/CD pipeline implementation
* Monitoring and logging
* Security and DevOps best practices

The solution uses AWS, Terraform, Docker, GitHub Actions, GitHub Container Registry, and AWS CloudWatch.

---

## Architecture

```text
Developer pushes code to GitHub
        |
        v
GitHub Actions Pipeline
        |
        |-- Checkout code
        |-- Install dependencies
        |-- Run basic test
        |-- Build Docker image
        |-- Push image to GitHub Container Registry
        |
        v
AWS EC2 Instance
        |
        |-- Pull latest Docker image
        |-- Stop old container
        |-- Run latest container
        |
        v
Node.js application exposed on port 80
```

---

## Technology Stack

* AWS EC2
* Terraform
* Docker
* Node.js
* GitHub Actions
* GitHub Container Registry
* AWS CloudWatch
* AWS IAM
* AWS Security Groups

---

## Repository Structure

```text
interview-task/
├── README.md
├── REPORT.md
├── app/
│   ├── Dockerfile
│   ├── package.json
│   ├── server.js
│   └── test.js
├── terraform/
│   ├── cloudwatch-dashboard.json
│   ├── cloudwatch-dashboard.tf
│   ├── iam.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── security-group.tf
│   ├── user-data.sh
│   └── variables.tf
├── .github/
│   └── workflows/
│       └── deploy.yml
└── screenshots/
```

---

## Application

The application is a simple Node.js web application.

Application endpoint:

```text
http://<EC2_PUBLIC_IP>
```

Health check endpoint:

```text
http://<EC2_PUBLIC_IP>/health
```

Expected health response:

```json
{
  "status": "ok"
}
```

---

## Prerequisites

Before running this project, the following are required:

* AWS account
* AWS CLI configured
* Terraform installed
* Git installed
* GitHub repository
* SSH key pair

---

## Infrastructure Deployment

Go to the Terraform directory:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Format and validate Terraform files:

```bash
terraform fmt
terraform validate
```

Plan the infrastructure:

```bash
terraform plan \
  -var="ami_id=<UBUNTU_AMI_ID>" \
  -var="admin_ip_cidr=<YOUR_PUBLIC_IP>/32"
```

Apply the infrastructure:

```bash
terraform apply \
  -var="ami_id=<UBUNTU_AMI_ID>" \
  -var="admin_ip_cidr=<YOUR_PUBLIC_IP>/32"
```

Terraform provisions the following resources:

* EC2 Ubuntu instance
* Security group
* IAM role and instance profile
* Docker installation through user data
* CloudWatch dashboard configuration

---

## CI/CD Pipeline

The CI/CD pipeline is implemented using GitHub Actions.

Workflow file:

```text
.github/workflows/deploy.yml
```

The pipeline runs automatically when code is pushed to the `main` branch.

Pipeline steps:

1. Checkout source code
2. Set up Node.js
3. Install dependencies
4. Run basic test
5. Build Docker image
6. Push Docker image to GitHub Container Registry
7. SSH into EC2
8. Pull and run the latest Docker image
9. Perform application health check

Required GitHub Actions secrets:

* `EC2_HOST`
* `EC2_USER`
* `EC2_PRIVATE_KEY`

---

## Monitoring and Logging

Monitoring and logging are configured using AWS CloudWatch.

The setup includes:

* EC2 CPU metrics
* EBS read/write metrics
* EC2 status checks
* Memory usage using CloudWatch Agent
* Disk usage using CloudWatch Agent
* Application logs
* System logs
* CloudWatch dashboard

CloudWatch dashboard name:

```text
interview-task-dashboard
```

CloudWatch log groups:

```text
/interview-task/application/app
/interview-task/system/syslog
```

---

## Security

Security controls include:

* GitHub Actions Secrets for deployment credentials
* AWS Security Groups for network access control
* SSH key-based authentication
* IAM role attached to EC2 for CloudWatch permissions
* No hardcoded credentials in the repository
* Port `443` enabled for HTTPS readiness

For production, public SSH access should be replaced with one of the following:

* AWS Systems Manager Session Manager or Run Command
* Self-hosted GitHub Actions runner inside AWS
* Runner with static public IP and restricted SSH access

---

## Cleanup

To avoid unnecessary AWS charges, destroy the infrastructure after evaluation:

```bash
cd terraform

terraform destroy \
  -var="ami_id=<UBUNTU_AMI_ID>" \
  -var="admin_ip_cidr=<YOUR_PUBLIC_IP>/32"
```
