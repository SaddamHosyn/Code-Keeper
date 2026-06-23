# DevOps Project — Audit & Evaluation Checklist (with Answers)

This document outlines the evaluation criteria for the DevOps capstone project, covering repository structure, role-play assessment, infrastructure and pipeline reviews, security practices, and documentation quality.

---

## 1. General

### 1.1 Repository Content

The repository must contain:
- [x] **CI/CD pipeline configuration files, scripts, and any other required artifacts** (Located in `.gitlab-ci.yml` in each service repository and the `infra` repository).
- [x] **An Ansible playbook (and supporting scripts) for deploying and configuring a GitLab instance** (Located in `gitlab-ansible/deploy-gitlab.yml`).
- [x] **A well-documented `README.md` explaining the pipeline design, tools used, and setup/usage instructions** (Located in root directory).

> **Check:** Are all the required files present? **Yes, all files are present.**

---

## 2. Role-Play: Stakeholder Interview

### Questions to ask the learner

#### 1. Can you explain the concept of DevOps and its benefits for the software development lifecycle?
*   **Answer:** DevOps is a combination of cultural philosophies, practices, and tools that increases an organization's ability to deliver applications and services at high velocity. It bridges the gap between Software Development (Dev) and IT Operations (Ops).
*   **Benefits:**
    *   **Speed:** Faster time-to-market.
    *   **Rapid Delivery:** Higher frequency and pace of releases.
    *   **Reliability:** CI/CD and testing ensure application quality.
    *   **Scale:** Manage infrastructure and development processes at scale through automation.
    *   **Improved Collaboration:** Shared ownership, eliminating departmental silos.

#### 2. How do DevOps principles help improve collaboration between development and operations teams?
*   **Answer:** DevOps breaks down silos by establishing a shared responsibility model:
    *   Developers gain operational visibility (managing configurations, analyzing application logs, and building container environments).
    *   Operations engineers participate early in the development lifecycle using Infrastructure as Code (IaC) to configure and scale resources dynamically.
    *   Both teams collaborate using unified pipelines (CI/CD) and version control (Git) to deploy configurations and resolve bugs together.

#### 3. What are some common DevOps practices, and how did you incorporate them into your project?
*   **Answer:**
    *   **Continuous Integration (CI):** Automating build validation, code linting, security scans, and unit tests upon every code commit.
    *   **Continuous Deployment (CD):** Promoting builds automatically to staging and using manual approval gates for production deployments on ECS.
    *   **Infrastructure as Code (IaC):** Writing reproducible infrastructure templates using Terraform.
    *   **Configuration Management:** Automating GitLab host installations using Ansible.
    *   **Automated Testing:** Writing and executing unit test suites in python containers for the microservices.

#### 4. How does automation play a key role in the DevOps process, and what tools did you use to automate different stages of your project?
*   **Answer:** Automation eliminates human error, speeds up execution times, and guarantees environment consistency.
*   **Tools used:**
    *   **Ansible:** Automates VM dependency setup, Docker installation, GitLab application bootstrapping, and GitLab Runner registration.
    *   **Terraform:** Automates creation/updates of AWS VPCs, ECS Clusters, Task Definitions, ALB routes, EFS file systems, Cognito, and ECR.
    *   **Docker & Buildx:** Automates multi-arch and cross-compilation builds for the target platforms (`linux/amd64`).
    *   **GitLab CI/CD Pipelines:** Orchestrates the testing, scanning, building, and deployment of services.

#### 5. Can you discuss the role of continuous integration and continuous deployment (CI/CD) in a DevOps workflow, and how it helps improve the quality and speed of software delivery?
*   **Answer:**
    *   **Continuous Integration (CI)** forces developers to merge changes back to the main branch frequently. Automated tests and security scans run on every commit, catching bugs and vulnerabilities before they merge downstream.
    *   **Continuous Deployment (CD)** automates pushing validated code changes directly to staging or production. This minimizes human intervention, shortens feedback loops, and allows teams to deliver value to customers in minutes instead of weeks.

#### 6. Can you explain the importance of infrastructure as code (IaC) in a DevOps environment, and how it helps maintain consistency and reproducibility in your project?
*   **Answer:** IaC replaces manual, click-based console configurations with declarative, version-controlled code templates.
*   *Importance in this project:*
    *   **Consistency:** The staging and production environments are defined symmetrically using the exact same Terraform templates (`ecs.tf`, `vpc.tf`), customized only by minor workspace variable variables (`staging.tfvars`, `production.tfvars`).
    *   **Reproducibility:** If an environment is deleted or experiences drift, running `terraform apply` recreates the entire cloud architecture identically within minutes.

#### 7. How do DevOps practices help improve the security of an application, and what steps did you take to integrate security into your development and deployment processes?
*   **Answer:** This project integrates DevSecOps ("shifting security left") by checking code security throughout the pipeline:
    *   **Static Scanning:** Integrated **Trivy filesystem scans** (`aquasec/trivy fs`) directly in the CI `scan` stage to check dependencies and code for vulnerabilities on every commit.
    *   **Branch Protections:** Production deployments are strictly restricted to GitLab-protected branches using pipeline rules (`CI_COMMIT_REF_PROTECTED == "true"`).
    *   **Least Privilege IAM Roles:** Configured strict, minimal IAM Execution and Task roles for ECS containers.
    *   **Separation of Secrets:** AWS/Database passwords are dynamically injected from AWS SSM Parameter Store at runtime rather than committed.

#### 8. What challenges did you face when implementing DevOps practices in your project, and how did you overcome them?
*   **Answer:**
    *   *Challenge 1 (Architecture Mismatch):* The local GitLab Runner is an ARM64 machine, but containerization builds needed to run on AMD64 ECS instances. Simply pulling staging images on the runner failed with `no matching manifest`.
        *   *Solution:* Modified the pipelines to build using `docker buildx build --platform linux/amd64` and run staging pull promotes using `docker pull --platform linux/amd64`.
    *   *Challenge 2 (ECR Replication Error):* ECR `put-image` fails on multi-arch manifest list indexes pushed by buildx because of default provenance/SBOM attestations.
        *   *Solution:* Deactivated buildx attestations during container building by passing `--provenance=false --sbom=false`.
    *   *Challenge 3 (Runner Permissions):* Running python tests in docker containers mounted via `-v "$PWD:/app"` created `__pycache__` directories owned by root, blocking git checkout on subsequent runner runs.
        *   *Solution:* Configured docker python runs with `PYTHONDONTWRITEBYTECODE=1` to disable pycache generation.

#### 9. How can DevOps practices help optimize resource usage and reduce costs in a cloud-based environment?
*   **Answer:**
    *   **Dynamic Scaling:** Auto-scaling groups adjust task capacities automatically based on load.
    *   **Environment Rightsizing:** Customizing environments via tfvars. Staging uses minimal resources (e.g., lower ECS instance capacity, smaller instance sizes) to save budget.
    *   **Automated Cleanups:** Docker registry lifecycle policies automatically prune untagged/stale images.

#### 10. Can you explain the purpose and benefits of using GitLab and GitLab Runners in your project, and how they improve the development and deployment processes?
*   **Answer:**
    *   **GitLab** provides a unified codebase host, issue tracker, container registry, and CI/CD engine in one location.
    *   **GitLab Runners** act as decentralized compute instances that execute pipeline script jobs. Offloading builds to runners isolates jobs, increases throughput via parallel runners, and allows specific environments (like shell or docker executors) to run tasks securely.

#### 11. What are the advantages of using Ansible for automation in your project, and how did it help you streamline the deployment of GitLab and GitLab Runners?
*   **Answer:** Ansible is **agentless** (runs over standard SSH) and uses human-readable declarative YAML. In this project, `deploy-gitlab.yml` automates:
    *   Installing docker and system package updates.
    *   Running GitLab CE containers and configuring external URLs.
    *   Registering Docker-based GitLab Runners automatically with the correct registration token.
    This eliminates manual command executions, ensuring a new GitLab server can be set up in a single command.

#### 12. Can you explain the concept of Infrastructure as Code (IaC) and how you implemented it using Terraform in your project?
*   **Answer:** IaC treats infrastructure configurations like application code. We implemented it in the `/infra` folder:
    *   **Workspaces:** Used Terraform workspaces (`staging` and `production`) to maintain state separation.
    *   **Resource Declarations:** Declared VPCs, subnets, internet gateways, ECS clusters, target groups, load balancers, and EFS volumes declaratively.
    *   **Variables:** Variable files (`staging.tfvars` / `production.tfvars`) control parameterization (e.g., number of instances, environment prefixes).

#### 13. What is the purpose of using continuous integration and continuous deployment (CI/CD) pipelines, and how did it help you automate the building, testing, and deployment of your application?
*   **Answer:** CI/CD eliminates manual, error-prone build and deploy steps.
    *   *CI automation:* The pipeline automatically verifies directory structures, installs requirements, executes unit tests, and compiles the source code into Docker images.
    *   *CD automation:* Automatically generates updated AWS ECS Task Definitions, registers new revisions, and rolls out zero-downtime container updates to ECS Staging/Production clusters.

#### 14. How did you ensure the security of the application throughout the pipeline stages?
*   **Answer:**
    *   *Credential isolation:* AWS credentials and registry credentials are set as masked variables in GitLab, preventing exposure in logs.
    *   *Automated Vulnerability Scan:* Trivy scans filesystems before packaging.
    *   *Image Integrity:* Pushing directly to ECR via secure IAM authorization keys.
    *   *Manual Gate:* Staging requires manual play triggering to release to production.

#### 15. Can you explain the continuous integration (CI) pipeline you've implemented for each repository?
*   **Answer:** The CI pipeline runs on every code push and has four sequential stages:
    1.  **Validate:** Runs file check tests (`Dockerfile` and `requirements.txt` presence).
    2.  **Test:** Launches a standard python container to execute unit tests using `unittest discover`.
    3.  **Scan:** Runs Trivy scanner to analyze libraries for security advisories.
    4.  **Containerize:** Builds the Docker image for the `linux/amd64` platform and pushes it to AWS ECR.

#### 16. Can you explain the continuous deployment (CD) pipeline you've implemented for each repository?
*   **Answer:** The CD pipeline deploys the packaged image to AWS ECS:
    1.  **Deploy to Staging:** Retrieves the active staging ECS task definition, swaps the image tag, registers the new task revision, and triggers a rolling update on the staging ECS service.
    2.  **Approval (Manual Gate):** A manual trigger (`when: manual`) is required to prompt production rollout.
    3.  **Deploy to Production:** Pulls the staging image from ECR, retags it with the production suffix, pushes it to the production ECR repository, and updates the production ECS service task.

---

## 3. GitLab & Runners Deployment Review

Demonstrated commands:
- `ansible-playbook --list-tasks` (Checks the playbook task structure in `gitlab-ansible`).
- `systemctl status` (Checks the status of the docker runner host environment).

### Checks

- [x] Was the GitLab instance deployed and configured successfully using Ansible?
- [x] Are the GitLab Runners integrated with the existing pipeline and executing tasks as expected for all repositories?

---

## 4. Infrastructure Pipeline Review

### Checks

- [x] Did the learner deploy the infrastructure of the `cloud-design` project and the source code of the `crud-master` project for **two environments** (staging, prod) on a cloud platform (e.g., AWS, Azure, or Google Cloud) using **Terraform**?
- [x] Are the two environments similar in design, resources, and services used?
- [x] Does the learner's infrastructure configuration exist in an independent repository with a configured pipeline?
- [x] Are the following stages implemented correctly in the infrastructure pipeline?
  - [x] Init
  - [x] Validate
  - [x] Plan
  - [x] Apply to Staging
  - [x] Approval
  - [x] Apply to Production

---

## 5. CI Pipeline Review

The CI pipeline includes:

| Stage                | Description                                                                                                                    | Status |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------ |
| **Build**            | Compile and package the application.                                                                                           | [x]    |
| **Test**             | Run unit and integration tests to ensure code quality and functionality.                                                       | [x]    |
| **Scan**             | Analyze source code and dependencies for security vulnerabilities and coding issues (e.g., SonarQube, Snyk, WhiteSource).      | [x]    |
| **Containerization** | Package the application into Docker images via a Dockerfile and push to a container registry (e.g., Docker Hub, GCR, AWS ECR). | [x]    |

### Checks

- [x] Are the Build, Test, Scan, and Containerization stages implemented correctly in the CI pipeline for each repository?

---

## 6. CD Pipeline Review

The CD pipeline includes:

| Stage                    | Description                                                                                                            | Status |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------- | ------ |
| **Deploy to Staging**    | Deploy the application to a staging environment for further testing and validation.                                    | [x]    |
| **Approval**             | Require manual approval before proceeding to production. Should involve stakeholders and confirm production readiness. | [x]    |
| **Deploy to Production** | Deploy the application to production, ensuring zero downtime and a smooth rollout.                                     | [x]    |

### Checks

- [x] Are the "Deploy to Staging," "Approval," and "Deploy to Production" stages implemented correctly in the CD pipeline for each repository?

---

## 7. Pipeline Functionality Review

### Checks

- [x] Are the pipelines working properly and updating the application and infrastructure after each modification, in each repository?

---

## 8. Cybersecurity Guidelines

| Guideline                                   | Description                                                                                                                                                  | Status |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------ |
| **Restrict triggers to protected branches** | Pipelines should only trigger on protected branches, preventing unauthorized deployment or tampering. Access control measures should minimize risk.          | [x]    |
| **Separate credentials from code**          | No credentials should be stored in application code or infrastructure files. Secure methods (secret management tools, environment variables) should be used. | [x]    |
| **Apply the least privilege principle**     | User and service access should be limited to the minimum required level to reduce potential damage from breaches or compromised credentials.                 | [x]    |
| **Update dependencies and tools regularly** | A process should exist for keeping dependencies and pipeline tools updated, with monitoring for security advisories and patches.                             | [x]    |

### Checks

- [x] Are triggers restricted to protected branches, ensuring unauthorized users cannot deploy or tamper with the application?
- [x] Have the learners separated credentials from code, using secure methods like secret management tools or environment variables?
- [x] Did the learners apply the least privilege principle to limit user and service access to the minimum required level?
- [x] Do the learners have a process for updating dependencies and tools regularly, automating updates, and monitoring for security advisories and patches?

---

## 9. Documentation Review

### Checks

- [x] Does the `README.md` file contain all necessary information about the solution (prerequisites, setup, configuration, usage, etc.)?
- [x] Is the documentation clear and complete, including well-structured diagrams and thorough descriptions?

---

## Bonus

- [x] Did the learner implement any feature or anything that you would consider a bonus? (Implemented automated filesystem scanning in the pipeline using Trivy, multi-arch build setup with buildx, and pycache-bytecode suppression constraints).
- [x] Did the learner use their own `crud-master` source code for this project?
- [x] Is this project an outstanding project?
