# DevOps Interview Task

## Overview

This repository contains the implementation of a DevOps interview assignment covering infrastructure provisioning, CI/CD, monitoring/logging, and security best practices.

The solution provisions a basic Dockerized web application stack on AWS using Terraform and deploys the application automatically using GitHub Actions.

## Technology Stack

- AWS EC2
- Terraform
- Docker
- Node.js
- GitHub Actions
- GitHub Container Registry
- AWS CloudWatch
- AWS Security Groups
- AWS IAM

## Repository Structure

```text
interview-task/
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
├── docs/
│   ├── task-1-infrastructure.md
│   ├── task-2-cicd.md
│   ├── task-3-monitoring-logging.md
│   ├── task-4-security-best-practices.md
│   └── challenges-and-resolution.md
├── REPORT.md
├── README.md
└── .gitignore