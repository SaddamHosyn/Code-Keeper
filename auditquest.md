# DevOps Project — Audit & Evaluation Checklist

This document outlines the evaluation criteria for the DevOps capstone project, covering repository structure, role-play assessment, infrastructure and pipeline reviews, security practices, and documentation quality.

---

## 1. General

### 1.1 Repository Content

The repository must contain:

- CI/CD pipeline configuration files, scripts, and any other required artifacts.
- An Ansible playbook (and supporting scripts) for deploying and configuring a GitLab instance.
- A well-documented `README.md` explaining the pipeline design, tools used, and setup/usage instructions.

> **Check:** Are all the required files present?

---

## 2. Role-Play: Stakeholder Interview

As part of the evaluation, simulate a real-world scenario where the learner assumes the role of a DevOps engineer and explains their solution to a team or stakeholder. This assesses their conceptual understanding, communication skills, and critical thinking.

### Questions to ask the learner

1. Can you explain the concept of DevOps and its benefits for the software development lifecycle?
2. How do DevOps principles help improve collaboration between development and operations teams?
3. What are some common DevOps practices, and how did you incorporate them into your project?
4. How does automation play a key role in the DevOps process, and what tools did you use to automate different stages of your project?
5. Can you discuss the role of continuous integration and continuous deployment (CI/CD) in a DevOps workflow, and how it helps improve the quality and speed of software delivery?
6. Can you explain the importance of infrastructure as code (IaC) in a DevOps environment, and how it helps maintain consistency and reproducibility in your project?
7. How do DevOps practices help improve the security of an application, and what steps did you take to integrate security into your development and deployment processes?
8. What challenges did you face when implementing DevOps practices in your project, and how did you overcome them?
9. How can DevOps practices help optimize resource usage and reduce costs in a cloud-based environment?
10. Can you explain the purpose and benefits of using GitLab and GitLab Runners in your project, and how they improve the development and deployment processes?
11. What are the advantages of using Ansible for automation in your project, and how did it help you streamline the deployment of GitLab and GitLab Runners?
12. Can you explain the concept of Infrastructure as Code (IaC) and how you implemented it using Terraform in your project?
13. What is the purpose of using continuous integration and continuous deployment (CI/CD) pipelines, and how did it help you automate the building, testing, and deployment of your application?
14. How did you ensure the security of the application throughout the pipeline stages?
15. Can you explain the continuous integration (CI) pipeline you've implemented for each repository?
16. Can you explain the continuous deployment (CD) pipeline you've implemented for each repository?

### Evaluation checks

- [ ] Do all learners have a good understanding of the concepts and technologies used in the project?
- [ ] Do all learners have the ability to communicate effectively and explain their decisions?
- [ ] Are all learners capable of thinking critically about their solution and considering alternative approaches?

---

## 3. GitLab & Runners Deployment Review

Ask the auditee to demonstrate the following commands (or other suitable equivalents) to support their answers:

- `ansible-playbook --list-tasks`
- `systemctl status`
- Any other relevant command with appropriate options

### Checks

- [ ] Was the GitLab instance deployed and configured successfully using Ansible?
- [ ] Are the GitLab Runners integrated with the existing pipeline and executing tasks as expected for all repositories?

---

## 4. Infrastructure Pipeline Review

### Checks

- [ ] Did the learner deploy the infrastructure of the `cloud-design` project and the source code of the `crud-master` project for **two environments** (staging, prod) on a cloud platform (e.g., AWS, Azure, or Google Cloud) using **Terraform**?
- [ ] Are the two environments similar in design, resources, and services used?
- [ ] Does the learner's infrastructure configuration exist in an independent repository with a configured pipeline?
- [ ] Are the following stages implemented correctly in the infrastructure pipeline?
  - Init
  - Validate
  - Plan
  - Apply to Staging
  - Approval
  - Apply to Production

---

## 5. CI Pipeline Review

The CI pipeline should include:

| Stage                | Description                                                                                                                    |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Build**            | Compile and package the application.                                                                                           |
| **Test**             | Run unit and integration tests to ensure code quality and functionality.                                                       |
| **Scan**             | Analyze source code and dependencies for security vulnerabilities and coding issues (e.g., SonarQube, Snyk, WhiteSource).      |
| **Containerization** | Package the application into Docker images via a Dockerfile and push to a container registry (e.g., Docker Hub, GCR, AWS ECR). |

### Checks

- [ ] Are the Build, Test, Scan, and Containerization stages implemented correctly in the CI pipeline for each repository?

---

## 6. CD Pipeline Review

The CD pipeline should include:

| Stage                    | Description                                                                                                            |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| **Deploy to Staging**    | Deploy the application to a staging environment for further testing and validation.                                    |
| **Approval**             | Require manual approval before proceeding to production. Should involve stakeholders and confirm production readiness. |
| **Deploy to Production** | Deploy the application to production, ensuring zero downtime and a smooth rollout.                                     |

### Checks

- [ ] Are the "Deploy to Staging," "Approval," and "Deploy to Production" stages implemented correctly in the CD pipeline for each repository?

---

## 7. Pipeline Functionality Review

Ask the auditee to demonstrate that the pipelines are functional by running one or more tests of their choosing.

### Checks

- [ ] Are the pipelines working properly and updating the application and infrastructure after each modification, in each repository?

---

## 8. Cybersecurity Guidelines

| Guideline                                   | Description                                                                                                                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Restrict triggers to protected branches** | Pipelines should only trigger on protected branches, preventing unauthorized deployment or tampering. Access control measures should minimize risk.          |
| **Separate credentials from code**          | No credentials should be stored in application code or infrastructure files. Secure methods (secret management tools, environment variables) should be used. |
| **Apply the least privilege principle**     | User and service access should be limited to the minimum required level to reduce potential damage from breaches or compromised credentials.                 |
| **Update dependencies and tools regularly** | A process should exist for keeping dependencies and pipeline tools updated, with monitoring for security advisories and patches.                             |

### Checks

- [ ] Are triggers restricted to protected branches, ensuring unauthorized users cannot deploy or tamper with the application?
- [ ] Have the learners separated credentials from code, using secure methods like secret management tools or environment variables?
- [ ] Did the learners apply the least privilege principle to limit user and service access to the minimum required level?
- [ ] Do the learners have a process for updating dependencies and tools regularly, automating updates, and monitoring for security advisories and patches?

---

## 9. Documentation Review

### Checks

- [ ] Does the `README.md` file contain all necessary information about the solution (prerequisites, setup, configuration, usage, etc.)?
- [ ] Is the documentation clear and complete, including well-structured diagrams and thorough descriptions?

---

## Bonus

- [ ] Did the learner implement any feature or anything that you would consider a bonus?
- [ ] Did the learner use their own `crud-master` source code for this project?
- [ ] Is this project an outstanding project?
