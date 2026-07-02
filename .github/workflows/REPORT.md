## Task 2: CI/CD Pipeline Implementation

The CI/CD pipeline was implemented using GitHub Actions.

The pipeline is triggered automatically whenever code is pushed to the `main` branch.

### Pipeline Steps

1. Checkout repository source code
2. Set up Node.js runtime
3. Install application dependencies
4. Run a basic application test
5. Authenticate to GitHub Container Registry
6. Build the Docker image from the application Dockerfile
7. Push the Docker image to GitHub Container Registry
8. Connect to the EC2 instance using SSH
9. Pull the latest Docker image on the EC2 instance
10. Stop and remove the previous running container
11. Start the new container on port 80
12. Run a health check against the deployed application

### Deployment Flow

The application is packaged as a Docker image and published to GitHub Container Registry. The EC2 instance provisioned through Terraform acts as the deployment target. During deployment, the pipeline connects to the EC2 instance, pulls the latest image, and runs it as a container.

### Pipeline Trigger

```yaml
on:
  push:
    branches:
      - main