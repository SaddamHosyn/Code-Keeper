# Code-Keeper: Microservices CI/CD Pipeline with Cloud Infrastructure

## Overview

Code-Keeper is a complete **CI/CD pipeline for a microservices system** that demonstrates enterprise-grade deployment practices. The project includes a **movie inventory and billing system** built with three Python microservices (API Gateway, Inventory App, Billing App), orchestrated through a **self-managed GitLab instance**, automated with **Ansible and Terraform**, containerized with **Docker**, and deployed to **AWS cloud infrastructure** with both staging and production environments. The system implements asynchronous processing via **RabbitMQ**, secure authentication via **AWS Cognito**, and automated infrastructure provisioning via **Infrastructure-as-Code (IaC)**.

---

## Objectives

- **Build a complete CI/CD pipeline** for multiple microservices with automated testing, scanning, and deployment stages
- **Provision cloud infrastructure** using Terraform with staging and production environments
- **Automate infrastructure deployment** using Ansible playbooks for GitLab and GitLab Runner setup
- **Implement container security scanning** and dependency vulnerability detection
- **Secure sensitive data** using AWS Secrets Manager and environment-based secret injection
- **Implement approval gates** for production deployments to ensure code quality and compliance
- **Enable infrastructure automation** with Infrastructure-as-Code (IaCfor reproducible deployments
- **Establish GitLab as the central platform** for version control, CI/CD orchestration, and repository management
- **Design high-availability architecture** with auto-scaling, load balancing, and multi-zone deployment

---

## Architecture

### High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Developer Workstation                       │
│                   (Windows Laptop with VS Code)                 │
└─────────────────────────────────────────────────────────────────┘
                              ↓ git push
┌─────────────────────────────────────────────────────────────────┐
│                  School iMac (Host Machine                    │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Ubuntu 20.04 Virtual Machine (Vagrant                 │   │
│  │                                                          │   │
│  │  ┌─────────────┐                ┌──────────────┐         │   │
│  │  │   GitLab    │                │ GitLab       │         │   │
│  │  │   CE        │───────────────→│ Runner       │         │   │
│  │  │             │                │ (Docker    │         │   │
│  │  └─────────────┘                └──────────────┘         │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                     (CI/CD Pipelines Triggered)
┌─────────────────────────────────────────────────────────────────┐
│                      AWS Cloud (eu-north-1)                     │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │           STAGING ENVIRONMENT                           │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │  VPC: 10.0.0.0/16                               │    │    │
│  │  │  ├─ ALB (Load Balancer)                         │    │    │
│  │  │  ├─ ECS Cluster (Container Orchestration      │    │    │
│  │  │  │  ├─ API Gateway Service                      │    │    │
│  │  │  │  ├─ Inventory Service                        │    │    │
│  │  │  │  ├─ Billing Service                          │    │    │
│  │  │  │  └─ RabbitMQ Service                         │    │    │
│  │  │  ├─ PostgreSQL Databases (Inventory & Billing │    │    │
│  │  │  ├─ EFS (Persistent Storage)                    │    │    │
│  │  │  ├─ Cognito (User Authentication)               │    │    │
│  │  │  └─ CloudWatch (Monitoring Dashboard          │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │         PRODUCTION ENVIRONMENT (Identical)              │    │
│  │  ├─ VPC, ALB, ECS, Databases, EFS, etc.                 │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  ECR (Docker Image Registry                           │    │
│  │  ├─ staging-inventory-app                               │    │
│  │  ├─ staging-api-gateway                                 │    │
│  │  ├─ staging-billing-app                                 │    │
│  │  ├─ production-inventory-app                            │    │
│  │  ├─ production-api-gateway                              │    │
│  │  └─ production-billing-app                              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  S3 (Terraform State Storage)                                   │
│  └─ cloud-design-tf-state-yourname-2026/                        │
└─────────────────────────────────────────────────────────────────┘
```

### Deployment Flow

```
Developer commits code to GitLab
                ↓
GitLab Webhook triggers GitLab Runner
                ↓
            ┌───────────────────┐
            │  CI PIPELINE      │
            ├───────────────────┤
            │ • Build Docker    │
            │ • Run Tests       │
            │ • Security Scan   │
            │ • Push to ECR     │
            └───────────────────┘
                ↓
        Manual Approval Required
                ↓
    ┌───────────────────────────────┐
    │  CD PIPELINE - STAGING        │
    ├───────────────────────────────┤
    │ • Deploy to ECS (Staging)     │
    │ • Run Smoke Tests             │
    │ • Validate Infrastructure     │
    └───────────────────────────────┘
                ↓
    Manual Approval for Production
                ↓
    ┌───────────────────────────────┐
    │  CD PIPELINE - PRODUCTION     │
    ├───────────────────────────────┤
    │ • Deploy to ECS (Production)  │
    │ • Health Checks               │
    │ • Monitoring Alert            │
    └───────────────────────────────┘
```

---

## Repositories

The project requires **5 separate GitLab repositories**, each with specific purposes:

| Repository             | Purpose                                                            | Branch Protection | Owner            |
| ---------------------- | ------------------------------------------------------------------ | ----------------- | ---------------- |
| **inventory-app**      | Movie inventory CRUD API with PostgreSQL backend                   | `main` protected  | Development Team |
| **billing-app**        | Asynchronous order processing via RabbitMQ consumer                | `main` protected  | Development Team |
| **api-gateway**        | HTTP reverse proxy, request routing, Cognito JWT validation        | `main` protected  | Development Team |
| **cloud-design-infra** | Terraform IaC for AWS infrastructure (VPC, ECS, ALB, RDS, etc.)    | `main` protected  | DevOps Team      |
| **gitlab-platform**    | Ansible playbooks for GitLab CE setup and GitLab Runner deployment | `main` protected  | DevOps Team      |

### Repository Naming Convention

- **Application Repos**: `{service-name}-app` (e.g., `inventory-app`, `billing-app`)
- **Infrastructure Repo**: `cloud-design-infra`
- **Platform Repo**: `gitlab-platform`

---

## Technology Stack

### Core Infrastructure & Orchestration

- **GitLab CE** — Self-managed Git repository and CI/CD platform
- **GitLab Runner** — Docker-based CI/CD executor
- **Docker** — Container runtime and image format
- **Docker Compose** — Local multi-container development
- **AWS EC2, ECS** — Container orchestration
- **AWS VPC** — Network isolation and security
- **AWS ALB** — Application load balancing

### Infrastructure as Code (IaC)

- **Terraform** — Infrastructure provisioning and management (v5.0+)
- **Ansible** — Infrastructure automation and configuration management

### Databases & Message Queue

- **PostgreSQL** — Relational database for Inventory and Billing services
- **RabbitMQ** — Message broker for asynchronous billing orders

### Security & Authentication

- **AWS Cognito** — User pool and JWT token management
- **AWS Secrets Manager / SSM Parameter Store** — Secure secret storage
- **SSL/TLS Certificates** — HTTPS encryption via AWS ACM

### Cloud Services

- **AWS ECS** — Container orchestration
- **AWS ECR** — Docker image registry
- **AWS EFS** — Persistent file storage
- **AWS CloudWatch** — Monitoring and logging
- **AWS IAM** — Identity and access management
- **AWS S3** — Terraform state storage

### Backend Services

- **Python 3.9+** — Application runtime
- **Flask** — Web framework for microservices
- **SQLAlchemy** — ORM for database operations

### Testing & Code Quality

- **pytest** — Python unit testing
- **Trivy** — Container image vulnerability scanning
- **SonarQube** (optional) — Code quality analysis
- **Snyk** (optional— Dependency vulnerability scanning

---

## Prerequisites

Before setting up the project, ensure you have:

### Local Development Machine

- **Docker** (v20.10+) and Docker Compose (v2.0+)
- **Git** (v2.30+)
- **Python** (v3.9+for local testing
- **Terraform** (v1.5+) for infrastructure management
- **Ansible** (v2.12+) for automation
- **VS Code** or preferred IDE
- **SSH client** for remote access
- **Postman** or `curl` for API testing

### Server/Host Machine (iMac)

- **Ubuntu 20.04 LTS** or later
- **Vagrant** (v2.3+) for VM management
- **VirtualBox** (v7.0+) for virtualization
- **8 GB RAM minimum, 20 GB storage** for GitLab VM
- **Stable network connection** (for remote access)

### AWS Account & Credentials

- **AWS Account** with admin or equivalent permissions
- **AWS CLI** (v2.0+configured with credentials
- **AWS Region**: eu-north-1 (customizable in `variables.tf`)
- **S3 Bucket** for Terraform state (create manually or via script)
- **AWS IAM User** with programmatic access (Access Key + Secret Key)

### GitLab Setup

- **GitLab CE** (Community Editioninstance running
- **GitLab Runner** registered and connected
- **GitLab Personal Access Token** (for CI/CD access)
- **GitLab Group or Project** to hold repositories

### Network & Access

- **SSH access** to GitLab runner machine
- **HTTPS access** to GitLab instance
- **Outbound internet access** for ECR, Docker Hub, AWS APIs
- **Firewall rules** allowing ports 22, 80, 443, 5672 (RabbitMQ)

---

## Infrastructure Setup

### Overview

Terraform is used to provision and manage all AWS infrastructure. The setup supports **separate staging and production environments** with identical infrastructure patterns but isolated resources.

### Terraform State Management

**State Storage**: AWS S3 backend (remote state)

```hcl
# infra/environments/main.tf
backend "s3" {
  bucket  = "cloud-design-tf-state-yourname-2026"  # Globally unique
  key     = "infrastructure/terraform.tfstate"
  region  = "us-east-1"
  encrypt = true  # Enable encryption at rest
}
```

**Why Remote State?**

- Enables team collaboration (lock mechanism)
- Keeps state in version-controlled environment
- Provides disaster recovery and backup
- Tracks infrastructure changes over time

### Environment Differences

Both staging and production use **identical infrastructure patterns** but with:

```
Staging:
├─ Desired Capacity: 2 EC2 instances
├─ Instance Size: t3.medium
├─ Cost: Lower
└─ Purpose: Testing and validation

Production:
├─ Desired Capacity: 3+ EC2 instances
├─ Instance Size: t3.large or better
├─ Cost: Higher
└─ Purpose: Live traffic, HA
```

### Terraform Workflow

#### 1. Initialize Backend

```bash
cd infra/environments/

# Initialize Terraform with backend configuration
terraform init \
  -backend-config="bucket=cloud-design-tf-state-yourname-2026" \
  -backend-config="key=infrastructure/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true"
```

#### 2. Validate Configuration

```bash
# Syntax and logic validation
terraform validate

# Format check
terraform fmt -check
```

#### 3. Plan Infrastructure

```bash
# For staging
terraform plan \
  -var-file="staging.tfvars" \
  -out="staging.tfplan"

# For production
terraform plan \
  -var-file="production.tfvars" \
  -out="production.tfplan"
```

#### 4. Apply Infrastructure

```bash
# Deploy staging
terraform apply "staging.tfplan"

# Deploy production
terraform apply "production.tfplan"
```

#### 5. Destroy (Cleanup)

```bash
# Remove all resources (use with caution!)
terraform destroy -var-file="staging.tfvars"
```

### Configuration Files

#### `staging.tfvars` — Staging Environment

```hcl
aws_region             = "eu-north-1"
vpc_cidr               = "10.0.0.0/16"
environment            = "staging"
instance_size          = "t3.medium"
ecs_desired_capacity   = 2
```

#### `production.tfvars` — Production Environment

```hcl
aws_region             = "eu-north-1"
vpc_cidr               = "10.0.0.0/16"
environment            = "production"
instance_size          = "t3.large"
ecs_desired_capacity   = 3
```

---

## GitLab and Runner Setup

### GitLab Deployment with Ansible

GitLab CE is deployed on an Ubuntu VM running on the school iMac using Ansible playbooks.

#### Deployment Steps

1. **Create Ubuntu VM via Vagrant**

```bash
cd gitlab-vm/

# Provision VM
vagrant up

# SSH into VM
vagrant ssh

# Verify hostname
hostname  # Should be: gitlab-school
```

2. **Deploy GitLab with Ansible**

```bash
cd ../gitlab-ansible/

# Update inventory
vim inventory.ini
# Ensure IP address matches your VM

# Run Ansible playbook
ansible-playbook -i inventory.ini deploy-gitlab.yml \
  --extra-vars "gitlab_hostname=gitlab-school.local"
```

**Playbook Tasks**:

- Install Docker
- Pull GitLab CE image
- Configure GitLab environment
- Initialize database
- Set root password
- Enable HTTPS (self-signed cert)

3. **Access GitLab**

```
URL: http://<VM-IP>:80
Username: root
Password: Check /etc/gitlab/initial_root_password (in container)
```

### GitLab Runner Setup

#### Register Runner with GitLab

```bash
# SSH into GitLab runner machine
ssh ubuntu@<runner-ip>

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install gitlab-runner

# Register runner
sudo gitlab-runner register \
  --url https://gitlab-school.local/ \
  --registration-token <REGISTRATION-TOKEN> \
  --executor docker \
  --docker-image ubuntu:20.04 \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --description "Docker Runner - School" \
  --tag-list "docker,school"
```

#### Runner Configuration

Edit `/etc/gitlab-runner/config.toml`:

```toml
[[runners]]
  name = "Docker Runner - School"
  url = "https://gitlab-school.local/"
  token = "<RUNNER-TOKEN>"
  executor = "docker"
  [runners.docker]
    image = "ubuntu:20.04"
    volumes = ["/var/run/docker.sock:/var/run/docker.sock"]
    privileged = true  # Needed for Docker-in-Docker builds
```

#### Verify Runner Status

```bash
# List registered runners
gitlab-runner list

# Verify runner can execute jobs
gitlab-runner verify
```

---

## CI Pipeline

### Pipeline Stages for Application Repositories

Each application repository (inventory-app, billing-app, api-gatewayimplements the following CI stages:

#### Stage 1: Build

**Purpose**: Compile application and resolve dependencies

```yaml
build:
  stage: build
  script:
    - pip install -r requirements.txt
    - python -m pytest --collect-only # Verify tests exist
  artifacts:
    paths:
      - app/
    expire_in: 1 hour
```

**Output**: Application code with installed dependencies

#### Stage 2: Test

**Purpose**: Run unit and integration tests

```yaml
test:
  stage: test
  script:
    - pip install -r requirements.txt
    - pytest --cov=app --cov-report=xml
    - echo "Tests passed: $(pytest --co -q | wc -l) test cases"
  coverage: '/TOTAL.*? ([\d\.]+)%/' # Extract coverage %
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
```

**Output**: Test reports, code coverage metrics

#### Stage 3: Scan

**Purpose**: Security vulnerability scanning

```yaml
scan:
  stage: scan
  image: aquasec/trivy:latest
  script:
    - trivy --version
    - trivy image --severity HIGH,CRITICAL dockerfile
  allow_failure: true
```

**Output**: Security scan report (fails on CRITICAL, warnings on HIGH)

#### Stage 4: Build & Push Docker Image

**Purpose**: Build Docker image and push to ECR

```yaml
containerize:
  stage: containerize
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - echo $AWS_SECRET_ACCESS_KEY | docker login -u AWS --password-stdin $ECR_REGISTRY
  script:
    - docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$CI_COMMIT_SHA .
    - docker push $ECR_REGISTRY/$ECR_REPOSITORY:$CI_COMMIT_SHA
    - docker tag $ECR_REGISTRY/$ECR_REPOSITORY:$CI_COMMIT_SHA $ECR_REGISTRY/$ECR_REPOSITORY:latest
    - docker push $ECR_REGISTRY/$ECR_REPOSITORY:latest
```

**Output**: Docker image pushed to AWS ECR

### Example `.gitlab-ci.yml` (inventory-app)

```yaml
stages:
  - build
  - test
  - scan
  - containerize

variables:
  REGISTRY: $CI_REGISTRY
  DOCKER_DRIVER: overlay2

build:
  stage: build
  image: python:3.9
  script:
    - pip install -r requirements.txt

test:
  stage: test
  image: python:3.9
  script:
    - pip install -r requirements.txt
    - pytest

scan:
  stage: scan
  image: aquasec/trivy:latest
  script:
    - trivy image --severity HIGH,CRITICAL $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

containerize:
  stage: containerize
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

---

## CD Pipeline

### Deployment Stages for Application Repositories

#### Stage 1: Deploy to Staging

```yaml
deploy_staging:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl set image deployment/inventory-app inventory-app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n staging
    - kubectl rollout status deployment/inventory-app -n staging
  environment:
    name: staging
    url: https://staging-api.cloud-design.local
  only:
    - main
```

#### Stage 2: Manual Approval for Production

```yaml
approve_production:
  stage: approval
  script:
    - echo "Waiting for manual approval to proceed to production"
  when: manual
  only:
    - main
```

#### Stage 3: Deploy to Production

```yaml
deploy_production:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl set image deployment/inventory-app inventory-app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n production
    - kubectl rollout status deployment/inventory-app -n production
  environment:
    name: production
    url: https://api.cloud-design.local
  when: on_success
  needs:
    - approve_production
  only:
    - main
```

### Infrastructure Repository CD Pipeline

The `cloud-design-infra` repository has separate stages for infrastructure:

#### Stage 1: Validate Terraform

```yaml
validate:
  stage: validate
  image: hashicorp/terraform:latest
  script:
    - cd infra/environments
    - terraform validate
    - terraform fmt -check
```

#### Stage 2: Plan Staging Infrastructure

```yaml
plan_staging:
  stage: plan
  image: hashicorp/terraform:latest
  script:
    - cd infra/environments
    - terraform init
    - terraform plan -var-file=staging.tfvars -out=staging.tfplan
  artifacts:
    paths:
      - infra/environments/staging.tfplan
```

#### Stage 3: Approval Gate

```yaml
approve_production_infra:
  stage: approval
  script:
    - echo "Manual approval for production infrastructure"
  when: manual
```

#### Stage 4: Apply Production Infrastructure

```yaml
apply_production:
  stage: apply
  image: hashicorp/terraform:latest
  script:
    - cd infra/environments
    - terraform init
    - terraform apply -var-file=production.tfvars -auto-approve
  environment:
    name: production
  when: on_success
  needs:
    - approve_production_infra
```

---

## Security Measures

### 1. Protected Branches

All repositories have `main` branch protection rules:

- **Require pull request review**: 2 approvals required
- **Require status checks**: All CI/CD pipelines must pass
- **Restrict who can push**: Only maintainers
- **Require up-to-date branch**: Prevent stale merges

### 2. Secret Management

**Secrets Storage Hierarchy**:

1. **GitLab CI/CD Variables** (for CI/CD access)
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `DOCKER_USERNAME`
   - `DOCKER_PASSWORD`
   - `GITLAB_TOKEN`

2. **AWS Secrets Manager** (for application runtime)
   - `/staging/cloud-design/rabbitmq/password`
   - `/staging/cloud-design/billing-db/password`
   - `/staging/cloud-design/inventory-db/password`

3. **Environment Variables** (passed to ECS tasks at runtime)

**Security Rules**:

- Never commit `.env` files to Git
- Rotate secrets every 90 days
- Use different secrets for each environment
- Enable encryption at rest for all secrets

### 3. Least Privilege Access

#### IAM Roles for ECS Tasks

```hcl
# ECS Execution Role: Pull images, fetch secrets
ecs_execution_role_policy:
  - ecr:GetAuthorizationToken
  - ecr:BatchGetImage
  - logs:CreateLogStream
  - logs:PutLogEvents
  - secretsmanager:GetSecretValue

# ECS Instance Role: EC2 permissions
ecs_instance_role_policy:
  - ec2:DescribeInstances
  - ecs:UpdateContainerInstancesState
  - logs:CreateLogGroup
```

#### GitLab Runner Permissions

```bash
# Runner runs with minimal Docker permissions
gitlab-runner install --user gitlab-runner --working-directory /home/gitlab-runner
```

### 4. Container Image Scanning

**Trivy Scanning**:

- Scans for CVEs in base images and dependencies
- Fails on CRITICAL vulnerabilities
- Runs in CI/CD pipeline on every build
- Reports stored in GitLab

**Example Output**:

```
Trivy Scan Results:
- CRITICAL: openssl (CVE-2023-0465)
- HIGH: python-pip (CVE-2023-0047)
- MEDIUM: curl (CVE-2022-32205)
```

### 5. Network Security

#### Security Groups

```hcl
# ALB Security Group (Public)
ALB Inbound:
  - Port 80 (HTTP): From 0.0.0.0/0
  - Port 443 (HTTPS): From 0.0.0.0/0

# ECS Security Group (Private)
ECS Inbound:
  - Ports 0-65535 (TCP): From ALB only
  - Ports 0-65535 (TCP): From other ECS tasks

# EFS Security Group (Private)
EFS Inbound:
  - Port 2049 (NFS): From ECS tasks only
```

#### Private Subnets for Services

- ECS tasks run in **private subnets**
- No direct internet access (only via NAT Gateway)
- Cannot be reached directly from internet
- Only accessible through ALB

### 6. Dependency Updates

**Automated Dependency Scanning**:

- GitLab Dependency Scanning
- Snyk integration (optional)
- Weekly security advisories

**Update Strategy**:

- Monthly patch updates (automated)
- Quarterly major updates (manual review)
- Emergency updates for CRITICAL vulnerabilities (within 24 hours)

### 7. Audit Logging

**CloudWatch Logs**:

- All ECS task logs centralized
- 7-day retention by default
- Searchable and filterable
- CloudTrail for AWS API calls

---

## Deployment Flow

### Application Deployment Flow

```
1. Developer commits code to feature branch
   ↓
2. Developer creates Pull Request to main
   ↓
3. GitLab runs CI pipeline:
   ✓ Build Docker image
   ✓ Run tests
   ✓ Security scan
   ✓ Push to ECR
   ↓
4. Code review: Team reviews PR
   ↓
5. Merge to main (requires 2 approvals)
   ↓
6. GitLab Runner triggers CD pipeline:
   ✓ Deploy to staging ECS cluster
   ✓ Run smoke tests
   ✓ Health checks pass
   ↓
7. Manual approval: DevOps approves production deployment
   ↓
8. GitLab Runner deploys to production:
   ✓ Update ECS service
   ✓ Rolling deployment (no downtime)
   ✓ Health checks verify
   ↓
9. Monitoring alerts on production metrics
```

### Infrastructure Deployment Flow

```
1. DevOps commits infrastructure changes (Terraform)
   ↓
2. Pull Request to cloud-design-infra main
   ↓
3. GitLab Terraform CI pipeline:
   ✓ terraform validate
   ✓ terraform fmt check
   ✓ terraform plan (staging)
   ↓
4. Code review and approval
   ↓
5. Merge to main
   ↓
6. GitLab Runner applies infrastructure:
   ✓ terraform apply (staging)
   ✓ Verify new resources
   ↓
7. Manual approval for production
   ↓
8. GitLab Runner applies to production:
   ✓ terraform apply (production)
   ✓ Update state in S3
   ↓
9. Infrastructure changes live
```

---

## How to Run

### Local Development Setup

#### 1. Clone All Repositories

```bash
# Create project directory
mkdir code-keeper && cd code-keeper

# Clone all repos
git clone https://gitlab.example.com/inventory-app.git
git clone https://gitlab.example.com/billing-app.git
git clone https://gitlab.example.com/api-gateway.git
git clone https://gitlab.example.com/cloud-design-infra.git
git clone https://gitlab.example.com/gitlab-platform.git
```

#### 2. Start Local Environment with Docker Compose

```bash
cd code-keeper

# Pull latest images
docker-compose pull

# Start all services
docker-compose up -d

# Verify services are running
docker-compose ps
```

**Services Available**:

```
- API Gateway:     http://localhost:3000
- Inventory API:   http://localhost:8081
- Billing API:     http://localhost:8082
- RabbitMQ UI:     http://localhost:15672
- Inventory DB:    localhost:5432
- Billing DB:      localhost:5433
```

#### 3. Test API Endpoints

```bash
# Create a test movie
curl -X POST http://localhost:3000/api/movies \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d '{
    "title": "Inception",
    "genre": "Sci-Fi",
    "release_year": 2010,
    "rating": 8.8,
    "available_copies": 5
  }'

# Get all movies
curl http://localhost:3000/api/movies \
  -H "Authorization: Bearer $JWT_TOKEN"

# Create order
curl -X POST http://localhost:3000/api/billing \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d '{
    "user_id": "user123",
    "number_of_items": "5",
    "total_amount": "49.99"
  }'
```

### AWS Cloud Deployment

#### 1. Configure AWS Credentials

```bash
aws configure
# Enter: Access Key ID
# Enter: Secret Access Key
# Enter: Region: eu-north-1
# Enter: Output format: json
```

#### 2. Create S3 Bucket for Terraform State

```bash
aws s3 mb s3://cloud-design-tf-state-yourname-2026 \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket cloud-design-tf-state-yourname-2026 \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket cloud-design-tf-state-yourname-2026 \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
```

#### 3. Deploy Infrastructure to Staging

```bash
cd infra/environments/

# Initialize Terraform
terraform init \
  -backend-config="bucket=cloud-design-tf-state-yourname-2026" \
  -backend-config="region=us-east-1"

# Plan staging deployment
terraform plan -var-file=staging.tfvars -out=staging.tfplan

# Apply staging deployment
terraform apply staging.tfplan
```

#### 4. Deploy Infrastructure to Production

```bash
# Plan production deployment
terraform plan -var-file=production.tfvars -out=production.tfplan

# Review plan carefully
cat production.tfplan

# Apply production deployment
terraform apply production.tfplan
```

#### 5. Deploy Applications to ECS

```bash
# Update ECS service with new Docker image
aws ecs update-service \
  --cluster staging-ecs-cluster \
  --service inventory-service \
  --force-new-deployment

# Check deployment status
aws ecs describe-services \
  --cluster staging-ecs-cluster \
  --services inventory-service \
  --query 'services[0].deployments'
```

### GitLab Setup

#### 1. Deploy GitLab CE

```bash
cd gitlab-vm/

# Create and start VM
vagrant up

# SSH into VM
vagrant ssh

# Verify GitLab is running
sudo docker ps | grep gitlab
```

#### 2. Register GitLab Runner

```bash
# SSH into runner machine
ssh ubuntu@<runner-ip>

# Register runner
sudo gitlab-runner register \
  --url https://gitlab-school.local/ \
  --registration-token <TOKEN> \
  --executor docker \
  --docker-image ubuntu:20.04

# Verify runner
gitlab-runner list
```

#### 3. Configure CI/CD Variables

In GitLab UI:

- Go to **Admin Area** → **Settings** → **CI/CD Variables**
- Add: `AWS_ACCESS_KEY_ID` = your-key
- Add: `AWS_SECRET_ACCESS_KEY` = your-secret
- Add: `ECR_REGISTRY` = your-account-id.dkr.ecr.eu-north-1.amazonaws.com

#### 4. Create GitLab Group and Projects

```bash
# Create group
curl -X POST https://gitlab-school.local/api/v4/groups \
  -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  -d "name=cloud-design&path=cloud-design"

# Create projects
curl -X POST https://gitlab-school.local/api/v4/projects \
  -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  -d "name=inventory-app&group_id=1"
```

---

## Validation and Testing

### 1. Pipeline Verification

#### Test CI Pipeline

```bash
# Push code to feature branch
git checkout -b feature/test-ci
git commit --allow-empty -m "Test CI pipeline"
git push origin feature/test-ci

# Go to GitLab UI and verify:
✓ Build stage passed
✓ Test stage passed
✓ Scan stage completed
✓ Container pushed to ECR
```

#### Test CD Pipeline

```bash
# Create pull request and merge to main
git checkout main
git merge feature/test-ci
git push origin main

# Verify in GitLab UI:
✓ All CI stages passed
✓ Deploy to staging stage started
✓ Production approval gate appeared
```

### 2. Staging Deployment Validation

```bash
# Get ALB endpoint
STAGING_ALB=$(aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[0].DNSName' \
  --output text)

# Test health check
curl -s http://$STAGING_ALB/health | jq .

# Test readiness check
curl -s http://$STAGING_ALB/ready | jq .

# Test API endpoint (get JWT token first)
JWT_TOKEN=$(curl -s https://<cognito-url>/oauth2/token \
  -d "client_id=<client_id>&username=test&password=test&grant_type=password" \
  | jq -r .access_token)

curl http://$STAGING_ALB/api/movies \
  -H "Authorization: Bearer $JWT_TOKEN" | jq .
```

### 3. Approval Gate Testing

```bash
# Verify approval gate is enabled
git log --oneline | head -5  # Check commit history

# Attempt production approval in GitLab UI
# Navigate to: Pipeline → Deploy to Production
# Click "Approve" button
# Verify deployment starts
```

### 4. Production Deployment Validation

```bash
# Get production ALB endpoint
PROD_ALB=$(aws elbv2 describe-load-balancers \
  --region eu-north-1 \
  --query 'LoadBalancers[0].DNSName' \
  --output text)

# Verify production endpoints are responding
for i in {1..5}; do
  curl -s http://$PROD_ALB/health | jq .
  sleep 2
done

# Test full user flow
JWT=$(aws cognito-idp initiate-auth \
  --client-id <client-id> \
  --auth-flow USER_PASSWORD_AUTH \
  --auth-parameters USERNAME=audit-user@example.com,PASSWORD=<password> \
  --query 'AuthenticationResult.AccessToken' \
  --output text)

# Create movie
curl -X POST http://$PROD_ALB/api/movies \
  -H "Authorization: Bearer $JWT" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","genre":"Drama","release_year":2024}'

# Verify movie was created
curl http://$PROD_ALB/api/movies -H "Authorization: Bearer $JWT" | jq '.movies | length'
```

### 5. Automated Unit Testing & Test Environments

We have implemented simplified, database-independent unit test suites for all microservices to guarantee syntax correctness, serialization integrity, and logic sanity:

*   **API Gateway (`api-gateway/tests/test_gateway.py`)**: Assures the Flask entry point imports securely and is fully callable without throwing Cognito initialization errors.
*   **Billing App (`billing-app/tests/test_billing.py`)**: Exercises the `Order` database model class to verify fields instantiation and serialization structures (`to_dict()`) without requiring live database connections.
*   **Inventory App (`inventory-app/tests/test_inventory.py`)**: Exercises the `Movie` model class to verify schema property instantiation and parsing logic.

#### Containerized Execution in CI

To guarantee that the tests run in clean, reproducible environments identical to production, the `test` stage executes the tests dynamically inside an isolated `python:3.9-slim` Docker container.

To prevent permission leaks on the host VM, we run the container with pycache bytecode writing disabled:
```bash
docker run --rm -e PYTHONDONTWRITEBYTECODE=1 -v "$PWD:/app" -w /app python:3.9-slim sh -c "pip install -r requirements.txt && PYTHONPATH=. python -m unittest discover -s tests"
```

---

## Repository Structure

### File Organization

```
code-keeper/
├── inventory-app/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── db.py               (Database connection & initialization)
│   │   ├── models.py           (SQLAlchemy ORM models)
│   │   └── routes.py           (Flask endpoints)
│   ├── tests/
│   │   └── test_inventory.py
│   ├── Dockerfile             (Build Docker image)
│   ├── requirements.txt        (Python dependencies)
│   ├── server.py              (Flask app entry point)
│   └── .gitlab-ci.yml         (CI/CD pipeline definition)
│
├── billing-app/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── consumer.py        (RabbitMQ consumer)
│   │   ├── db.py
│   │   ├── models.py
│   │   └── routes.py
│   ├── tests/
│   │   └── test_billing.py
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── server.py
│   └── .gitlab-ci.yml
│
├── api-gateway/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── routes.py          (Proxy to backend services)
│   │   └── auth.py            (JWT validation)
│   ├── tests/
│   │   └── test_gateway.py
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── server.py
│   └── .gitlab-ci.yml
│
├── cloud-design-infra/
│   ├── infra/
│   │   └── environments/
│   │       ├── main.tf        (Terraform backend config)
│   │       ├── variables.tf   (Input variables)
│   │       ├── vpc.tf         (VPC, subnets, security groups)
│   │       ├── alb.tf         (Load balancer)
│   │       ├── ecs.tf         (Container orchestration)
│   │       ├── ecr.tf         (Docker registry)
│   │       ├── efs.tf         (Persistent storage)
│   │       ├── cognito.tf     (User authentication)
│   │       ├── autoscaling.tf (Auto-scaling policies)
│   │       ├── dashboard.tf   (CloudWatch dashboard)
│   │       ├── staging.tfvars (Staging config)
│   │       ├── production.tfvars (Production config)
│   │       └── provider.tf    (AWS provider config)
│   └── .gitlab-ci.yml
│
├── gitlab-platform/
│   ├── gitlab-ansible/
│   │   ├── deploy-gitlab.yml  (Ansible playbook)
│   │   └── inventory.ini      (Host inventory)
│   ├── gitlab-vm/
│   │   ├── Vagrantfile        (VM configuration)
│   │   └── .vagrant/          (Vagrant state)
│   └── .gitlab-ci.yml
│
├── docker-compose.yaml        (Local development orchestration)
├── openapi.yaml               (API specification)
├── CRUD_Master.postman_collection.json
├── README.md
└── PROJECT_README.md          (This file)
```

### Key Files for Auditors

| File                | Purpose                | Location              |
| ------------------- | ---------------------- | --------------------- |
| `.gitlab-ci.yml`    | CI/CD pipeline stages  | Each app repo root    |
| `Dockerfile`        | Container build config | Each app repo root    |
| `main.tf`           | Infrastructure core    | `infra/environments/` |
| `vpc.tf`            | Network setup          | `infra/environments/` |
| `deploy-gitlab.yml` | GitLab automation      | `gitlab-platform/`    |
| `requirements.txt`  | Python dependencies    | Each app repo root    |
| `server.py`         | App entry point        | Each app repo root    |

---

## Audit Preparation

### Live Demonstration Checklist

#### 1. GitLab Instance Running

```bash
# Verify GitLab is accessible
curl -I http://<gitlab-ip>:80

# Show GitLab UI in browser
# Navigate to: http://<gitlab-ip>
# Login with: root / <password>
```

**What to show**:

- ✓ GitLab CE dashboard
- ✓ All 5 repositories created and populated
- ✓ Project pipelines visible
- ✓ CI/CD variables configured
- ✓ Protected branches on `main`

#### 2. Runner Registration

```bash
# Verify runner is registered
sudo gitlab-runner list

# Show runner status in GitLab UI
# Navigate to: Admin Area → Runners
# Verify "Docker Runner - School" shows as online
```

**What to show**:

- ✓ Runner appears in GitLab UI
- ✓ Runner status is "online"
- ✓ Runner has correct tags (docker, school)

#### 3. Successful Pipeline Execution

```bash
# Make a test commit
git commit --allow-empty -m "Trigger pipeline"
git push origin main

# Show pipeline execution in GitLab UI
# Navigate to: Project → CI/CD → Pipelines
# Click latest pipeline
```

**What to show**:

- ✓ All CI stages passed (Build, Test, Scan, Containerize)
- ✓ Artifact storage confirmed
- ✓ Docker image pushed to ECR
- ✓ Job logs visible

#### 4. Staging Deployment

```bash
# Show deployment to staging in GitLab UI
# Navigate to: Deployments → Staging

# Verify staging services are running
aws ecs describe-services \
  --cluster staging-ecs-cluster \
  --services inventory-service,api-gateway-service,billing-service \
  --query 'services[*].[serviceName,status]'

# Test staging endpoints
curl http://<staging-alb>/health
```

**What to show**:

- ✓ Deployment history with timestamps
- ✓ ECS services running in staging VPC
- ✓ Staging endpoints responding
- ✓ Health checks passing

#### 5. Approval Gate

```bash
# Trigger manual approval in GitLab UI
# Navigate to: Pipeline → Manual Jobs
# Click "Approve Production"

# Show manual gate triggered deployment
```

**What to show**:

- ✓ Approval gate blocks automatic production deployment
- ✓ Only authorized users can approve
- ✓ Manual approval button clicked
- ✓ Deployment starts after approval

#### 6. Production Deployment

```bash
# Verify production deployment completed
aws ecs describe-services \
  --cluster production-ecs-cluster \
  --services inventory-service,api-gateway-service,billing-service \
  --query 'services[*].[serviceName,runningCount,desiredCount]'

# Test production endpoints
JWT=$(get_cognito_token)
curl http://<prod-alb>/api/movies \
  -H "Authorization: Bearer $JWT"
```

**What to show**:

- ✓ Production ECS services running
- ✓ All tasks healthy and running
- ✓ Production endpoints responding correctly
- ✓ Data persisted from staging to production

#### 7. Infrastructure Automation

```bash
# Show Terraform state
terraform show -json | jq '.resources | length'

# Display recent Terraform changes
aws cloudtrail describe-events \
  --query 'Events[0:5].[EventName,EventTime,Username]'
```

**What to show**:

- ✓ Terraform state stored in S3 backend
- ✓ All infrastructure resources created (VPC, ECS, ALB, RDS, etc.)
- ✓ CloudTrail logs show infrastructure changes
- ✓ Separate staging/production resources isolated

---

## Conclusion

**Code-Keeper** demonstrates a production-ready CI/CD pipeline with:

- **Microservices Architecture**: Three independent Python services communicating asynchronously
- **Infrastructure as Code**: Terraform-managed AWS infrastructure with staging and production environments
- **Automated Deployment**: GitLab CI/CD with security scanning and approval gates
- **Security**: JWT authentication, least privilege access, vulnerability scanning, encrypted secrets
- **High Availability**: Load balancing, auto-scaling, multi-zone deployment
- **Monitoring**: CloudWatch dashboards for real-time visibility
- **Compliance**: Audit logging, version control, protected branches, approval gates

This is a complete blueprint for deploying enterprise applications on AWS with full automation and security best practices.

---

## Quick Reference Commands

```bash
# Local Development
docker-compose up -d
docker-compose logs -f api-gateway

# AWS Deployment
cd infra/environments
terraform init
terraform plan -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars

# GitLab Management
gitlab-runner list
gitlab-runner verify
sudo systemctl restart gitlab-runner

# Testing
curl -H "Authorization: Bearer $JWT" http://localhost:3000/api/movies
pytest tests/ --cov=app

# Monitoring
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS \
  --metric-name CPUUtilization \
  --dimensions Name=ClusterName,Value=staging-ecs-cluster
```
 
 