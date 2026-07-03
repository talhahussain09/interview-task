# DevOps Interview Assignment Report

## Candidate

Talha Bin Hussain

## Repository

```text
https://github.com/talhahussain09/interview-task
```

---

## Overview

This report documents the implementation of the DevOps interview assignment.

The assignment required four major tasks:

1. Infrastructure provisioning
2. CI/CD pipeline implementation
3. Monitoring and logging
4. Security and DevOps best practices

The solution was implemented as an end-to-end DevOps workflow using AWS, Terraform, Docker, GitHub Actions, GitHub Container Registry, and AWS CloudWatch.

---

## Architecture Summary

```text
GitHub Repository
      |
      | Push to main
      v
GitHub Actions
      |
      | Build, test, and package Docker image
      v
GitHub Container Registry
      |
      | Pull latest image
      v
AWS EC2 Instance
      |
      | Run Docker container
      v
Node.js Web Application
```

Monitoring:

```text
AWS CloudWatch Metrics, Logs, and Dashboard
```

Security:

```text
AWS Security Groups, IAM Role, GitHub Actions Secrets
```

---

# Task 1: Infrastructure Provisioning

## Requirement

Use Infrastructure as Code to provision a basic web application stack in a cloud provider.

The stack should include:

* One Linux-based virtual machine or container hosting a sample web application
* Networking configuration to allow HTTP/HTTPS access
* Storage and security groups/firewall rules as needed
* IaC scripts
* README instructions

## Implementation

Terraform was used to provision the AWS infrastructure.

The infrastructure includes:

* AWS EC2 Ubuntu instance
* Security group
* IAM role and instance profile
* Root EBS volume
* Docker runtime installation through EC2 user data
* CloudWatch dashboard configuration

## Terraform Files

The Terraform configuration is stored in:

```text
terraform/
```

Key files:

```text
terraform/main.tf
terraform/variables.tf
terraform/security-group.tf
terraform/iam.tf
terraform/outputs.tf
terraform/user-data.sh
terraform/cloudwatch-dashboard.tf
terraform/cloudwatch-dashboard.json
```

## EC2 Instance

The EC2 instance is used as the application host.

Docker is installed automatically using the `user-data.sh` script.

The instance runs the Dockerized Node.js application deployed by GitHub Actions.

## Security Group Configuration

Inbound rules:

| Port | Purpose                       | Source                                               |
| ---- | ----------------------------- | ---------------------------------------------------- |
| 22   | SSH administration/deployment | Restricted or temporarily adjusted for CI/CD testing |
| 80   | HTTP application access       | Public                                               |
| 443  | HTTPS readiness               | Public                                               |

Outbound traffic is allowed so the instance can install packages, pull Docker images, and communicate with AWS services.

## Code Snippet

Example from Terraform EC2 configuration:

```hcl
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name        = "interview-task-web-server"
    Environment = "test"
    ManagedBy   = "terraform"
  }
}
```

## Result

The AWS infrastructure was successfully provisioned using Terraform. The EC2 instance was created, Docker was installed, and the instance was prepared as the deployment target for the CI/CD pipeline.

---

# Task 2: CI/CD Pipeline Implementation

## Requirement

Set up a simple CI/CD pipeline to automatically build and deploy the application when code is pushed to a repository.

The pipeline should include:

* Code checkout
* Basic build/test step
* Deployment to the provisioned infrastructure
* CI/CD pipeline YAML file
* Short documentation on pipeline steps

## Implementation

GitHub Actions was used to implement the CI/CD pipeline.

Workflow file:

```text
.github/workflows/deploy.yml
```

The pipeline runs automatically when code is pushed to the `main` branch. It also supports manual execution using `workflow_dispatch`.

## Pipeline Steps

The pipeline performs the following steps:

1. Checkout repository code
2. Set up Node.js
3. Install dependencies
4. Run a basic application test
5. Log in to GitHub Container Registry
6. Build Docker image
7. Push Docker image to GitHub Container Registry
8. Configure SSH access
9. Deploy the container to EC2
10. Run application health check

## Application Code

The application is located in:

```text
app/
```

Application files:

```text
app/server.js
app/package.json
app/test.js
app/Dockerfile
```

## Docker Build

The Docker image is built from:

```text
app/Dockerfile
```

The image is pushed to GitHub Container Registry:

```text
ghcr.io/<github-username>/interview-task:latest
```

## Basic Test Step

The pipeline runs:

```bash
npm test
```

The test validates that the main application file exists.

## Code Snippet

Pipeline trigger:

```yaml
on:
  push:
    branches:
      - main
  workflow_dispatch:
```

Docker build and push:

```yaml
- name: Build Docker image
  run: docker build -t $IMAGE_NAME ./app

- name: Push Docker image
  run: docker push $IMAGE_NAME
```

Deployment command:

```bash
docker pull ghcr.io/<github-username>/interview-task:latest
docker stop interview-task-app || true
docker rm interview-task-app || true
docker run -d \
  --name interview-task-app \
  --restart unless-stopped \
  -p 80:3000 \
  ghcr.io/<github-username>/interview-task:latest
```

## Health Check

After deployment, the pipeline validates the application using:

```bash
curl -f http://<EC2_PUBLIC_IP>/health
```

Expected response:

```json
{
  "status": "ok"
}
```

## Result

The CI/CD pipeline successfully builds, tests, packages, pushes, deploys, and verifies the application automatically after code is pushed to the repository.

---

# Task 3: Monitoring and Logging

## Requirement

Configure basic monitoring for the application and infrastructure.

The setup should ensure:

* Resource usage is collected
* Uptime is monitored
* Basic application logs are collected and accessible
* Screenshots or exported dashboards/logs are included if possible

## Implementation

AWS CloudWatch was used for monitoring, logging, dashboards, and alarms.

## Monitoring Coverage

The monitoring setup includes:

* EC2 CPU utilization
* EBS read/write activity
* EC2 status checks
* Memory usage through CloudWatch Agent
* Disk usage through CloudWatch Agent
* Application health endpoint
* Application logs
* System logs
* CloudWatch dashboard

## CloudWatch Dashboard

A CloudWatch dashboard was created with the name:

```text
interview-task-dashboard
```

The dashboard includes widgets for:

* EC2 CPU utilization
* Memory usage percentage
* Root disk usage percentage
* Application logs
* System logs

## CloudWatch Agent

CloudWatch Agent was configured to collect memory and disk metrics.

Custom metrics collected:

```text
mem_used_percent
disk_used_percent
```

## Logging

Application logs are written to:

```text
/var/log/interview-task/app.log
```

System logs are collected from:

```text
/var/log/syslog
```

CloudWatch log groups:

```text
/interview-task/application/app
/interview-task/system/syslog
```

## Application Health

The application exposes:

```text
/health
```

This endpoint is used by the CI/CD pipeline to confirm that the deployment completed successfully.

## Screenshots

The following screenshots were captured and included in the final submission:

```text
screenshots/github-actions-success.png
screenshots/app-homepage.png
screenshots/cloud-watch-dashboard.png
screenshots/cloud-watch-sys-logs.png
screenshots/cloud-watch-app-logs.png
```

## Result

CloudWatch provides centralized visibility into infrastructure resource usage, system health, application logs, and application availability.

---

# Task 4: Security and Best Practices

## Requirement

Implement DevOps security best practices, such as:

* Securing credentials using a secrets manager
* Restricting network access with security groups/firewall rules
* Enabling HTTPS
* Brief explanation of implemented security steps

## Credential and Secret Management

The sample application does not require runtime secrets such as database credentials or external API tokens.

The CI/CD pipeline requires deployment credentials. These were stored using GitHub Actions Secrets.

| Secret            | Purpose                             |
| ----------------- | ----------------------------------- |
| `EC2_HOST`        | EC2 public IP used for deployment   |
| `EC2_USER`        | EC2 SSH username                    |
| `EC2_PRIVATE_KEY` | SSH private key used for deployment |

No secrets or credentials were committed to the repository.

For a production workload, application runtime secrets such as database credentials, API keys, and tokens should be stored in AWS Secrets Manager and accessed using IAM roles and least-privilege policies.

## Network Security

AWS Security Groups were used to control inbound access.

Inbound rules:

| Port | Purpose                       | Source                                               |
| ---- | ----------------------------- | ---------------------------------------------------- |
| 22   | SSH administration/deployment | Restricted or temporarily adjusted for CI/CD testing |
| 80   | HTTP application access       | Public                                               |
| 443  | HTTPS readiness               | Public                                               |

## SSH and CI/CD Access Challenge

SSH access was initially restricted to the administrator’s public IP. This is a good security practice, but it caused a CI/CD deployment challenge because GitHub-hosted runners use changing public IP addresses.

As a temporary resolution for the test environment, SSH access was adjusted to allow the GitHub Actions workflow to deploy the container to the EC2 instance.

## Production Recommendation for Deployment Access

For production, public SSH access should not be left open.

Recommended options:

* Use AWS Systems Manager Session Manager or Run Command
* Use a self-hosted GitHub Actions runner inside AWS
* Use a runner with a controlled static public IP
* Restrict SSH access to only the runner IP or runner security group

A self-hosted runner should be treated as trusted deployment infrastructure. It should be isolated, patched, and granted only the minimum required access.

## IAM Security

The EC2 instance uses an IAM role for CloudWatch integration.

This avoids storing long-lived AWS credentials directly on the server.

## Repository Security

The `.gitignore` file prevents accidental commits of:

* SSH keys
* Terraform state files
* Node.js dependencies
* Local configuration files
* Editor files

## HTTPS

Port `443` was enabled in the security group for HTTPS readiness.

Since this was a temporary test environment without a registered domain, HTTPS termination was not fully configured.

For production, HTTPS should be enabled using one of the following:

* AWS ACM with Application Load Balancer
* Let's Encrypt with Nginx reverse proxy

## Result

The implementation demonstrates secure handling of deployment credentials, network access control, IAM role usage, monitoring, and production-grade security recommendations.

---

# Challenges Faced and Resolutions

## Challenge 1: Free Tier Instance Type

### Issue

The initially selected EC2 instance type was not eligible for the AWS Free Tier in the selected account or region.

### Resolution

Free-tier eligible instance types were checked using AWS CLI:

```bash
aws ec2 describe-instance-types \
  --filters Name=free-tier-eligible,Values=true \
  --query "InstanceTypes[*].InstanceType" \
  --output table \
  --region us-east-1
```

A free-tier eligible instance type was selected.

---

## Challenge 2: CloudWatch Agent Installation

### Issue

The EC2 user data initially attempted to install `amazon-cloudwatch-agent` using `apt`.

The package was not available in the default Ubuntu package repository, causing user data execution to fail.

### Resolution

The user data script was corrected to install packages available from the default Ubuntu repository. CloudWatch Agent was installed separately using the AWS-supported package method.

---

## Challenge 3: GitHub Actions SSH Access

### Issue

SSH access was initially restricted to the administrator’s public IP. GitHub-hosted runners use changing public IP addresses, so the workflow could not reliably connect to the EC2 instance.

### Resolution

SSH access was temporarily adjusted for the test environment to allow the GitHub Actions workflow to complete deployment.

### Production Recommendation

For production, deployment should use one of the following:

* AWS Systems Manager Session Manager
* AWS Systems Manager Run Command
* Self-hosted GitHub Actions runner inside AWS
* Runner with a controlled static public IP

---

## Challenge 4: Docker Application Logs

### Issue

Docker logs are not automatically available as simple host log files for CloudWatch Agent collection.

### Resolution

A host directory was mounted into the container:

```text
/var/log/interview-task
```

The application logs were redirected to:

```text
/var/log/interview-task/app.log
```

CloudWatch Agent was configured to collect this file.

---

## Challenge 5: CloudWatch Dashboard Metric Dimensions

### Issue

CloudWatch Agent custom metrics require correct dimensions such as `InstanceId`, `path`, `device`, and `fstype`.

### Resolution

The exact metric dimensions were checked from CloudWatch Metrics and used in the dashboard configuration.

---

# Final Submission Contents

The final submission includes:

* Source code repository
* Terraform infrastructure code
* GitHub Actions workflow
* Dockerized Node.js application
* CloudWatch monitoring configuration
* Screenshots
* README.md
* REPORT.md

---

# Conclusion

The assignment was completed by implementing an end-to-end DevOps workflow covering infrastructure provisioning, CI/CD automation, monitoring, logging, and security best practices.

The solution demonstrates how a simple application can be provisioned, deployed, monitored, and secured using common DevOps tools and cloud-native services.
