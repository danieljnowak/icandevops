# I Can DevOps

## Overview
This repository is a **monorepo** containing multiple applications and infrastructure code designed to demonstrate **AWS DevOps skills**. The project is structured to showcase:

- **Infrastructure as Code (IaC)** using **Terraform**
- **CI/CD automation** using **GitHub Actions & AWS CodePipeline**
- **Cloud deployment** on **AWS Free Tier**
- **Best practices in DevOps** for security, scalability, and automation

## Goals
The primary goal of this project is to create a fully automated **CI/CD pipeline** that deploys multiple applications to AWS using **Terraform and GitHub Actions**. This monorepo will:

1. **Host a personal website** built with **Hugo**, deployed on AWS S3 & CloudFront.
2. **Deploy a Golang-based URL shortener** using AWS Lambda, API Gateway, and DynamoDB.
3. **Deploy a random quote API** written in Golang, also using AWS Lambda & API Gateway.
4. **Automate infrastructure provisioning** with Terraform.
5. **Implement monitoring & logging** using AWS CloudWatch.
6. **Ensure low-cost deployment** by staying within AWS Free Tier limits.

## Repository Structure

```plaintext
aws-devops-monorepo/
│── .github/workflows/       # GitHub Actions CI/CD workflows
│── terraform/               # Terraform IaC for AWS resources
│   ├── modules/             # Reusable Terraform modules
│   ├── environments/        # Dev, Staging, Prod configurations
│   ├── main.tf              # Root Terraform script
│── apps/                    
│   ├── personal-site/       # Hugo static website
│   ├── url-shortener/       # Golang URL Shortener
│   ├── quote-api/           # Golang Quote API
│── scripts/                 # Deployment and helper scripts
│── README.md                # Documentation
```

## Deployment Pipeline

- **Code is stored on GitHub**
- **GitHub Actions** triggers Terraform for AWS deployments
- **Terraform provisions AWS infrastructure**
- **CI/CD pipeline deploys applications automatically**

## Technologies Used

- **Terraform** – Infrastructure as Code
- **GitHub Actions** – CI/CD automation
- **AWS Lambda** – Serverless functions
- **API Gateway** – API management
- **DynamoDB** – NoSQL database for URL shortener
- **S3 & CloudFront** – Static website hosting
- **CloudWatch** – Monitoring & logging

## Getting Started

To contribute or run this project locally:

1. Clone the repository:
   ```bash
   git clone git@github.com:danieljnowak/icandevops.git
   ```
2. Navigate to the directory:
   ```bash
   cd icandevops
   ```
3. Set up **AWS CLI** and **Terraform** following the installation guide.
4. Deploy infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```
5. Deploy applications using GitHub Actions or manual scripts.

## Future Enhancements

- Add **Terraform state management** with S3 & DynamoDB locking
- Implement **automated testing** in CI/CD pipeline
- Extend monitoring with **AWS CloudWatch Metrics & Alerts**

## Author

**Daniel Nowak** 


