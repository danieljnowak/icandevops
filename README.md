# DevOps Portfolio - Dan Nowak

## Overview

This repository contains the infrastructure code, applications, and deployment pipelines for my personal DevOps portfolio website. The project demonstrates infrastructure-as-code practices, AWS cloud architecture, and CI/CD implementation using modern DevOps tools and methodologies.

The portfolio showcases multiple environments (development and production) deployed across different AWS regions, highlighting how infrastructure can be consistently deployed while maintaining environment-specific configurations.

**Live Site:** [dannowak.com](https://dannowak.com)  
**Development Site:** [dev.dannowak.com](https://dev.dannowak.com)

## Project Goals

- Demonstrate infrastructure-as-code skills using Terraform and Terragrunt
- Showcase multi-environment deployments (dev/prod) across different AWS regions
- Implement serverless architectures using AWS Lambda and API Gateway
- Create a fully automated CI/CD pipeline using GitHub Actions
- Stay within AWS free tier limits (with minimal additional costs)
- Present a clean, professional web presence with interactive elements

## Architecture

### AWS Services

| Service | Usage | Environment |
|---------|-------|-------------|
| S3 | Static website hosting for Hugo site | Dev & Prod |
| CloudFront | Content delivery and HTTPS | Dev & Prod |
| Route 53 | DNS management | Global |
| ACM | SSL certificates | Dev & Prod |
| Lambda | Serverless API functions | Dev & Prod |
| API Gateway | RESTful API endpoints | Dev & Prod |
| DynamoDB | NoSQL database for applications | Dev & Prod |
| IAM | Access management and security | Dev & Prod |
| CloudWatch | Monitoring and logging | Dev & Prod |
| Systems Manager | Parameter storage | Dev & Prod |

### Regional Distribution

- **Production Environment:** US East (N. Virginia) - `us-east-1`
- **Development Environment:** US West (Oregon) - `us-west-2`
- **Global Resources:** Managed in `us-east-1`

## Repository Structure

```
dannowak-portfolio/
├── apps/
│   ├── hugo-site/        # Static website built with Hugo
│   ├── quote-service/    # Python Lambda function for quotes API
│   ├── analytics/        # Go Lambda function for visitor tracking
│   └── wordle-game/      # Svelte implementation of Wordle game
├── infrastructure/
│   ├── modules/          # Reusable Terraform modules
│   │   ├── static-site/
│   │   ├── api-gateway/
│   │   ├── database/
│   │   └── monitoring/
│   ├── environments/
│   │   ├── terragrunt.hcl          # Root config
│   │   ├── us-east-1/              # Production region
│   │   │   ├── region.hcl
│   │   │   └── prod/
│   │   └── us-west-2/              # Development region
│   │       ├── region.hcl
│   │       └── dev/
│   └── global/                     # Global resources
├── .github/
│   └── workflows/                  # CI/CD pipelines
└── README.md                       # This file
```

## Core Components

### Hugo Static Site

A fast, modern static site generator used to build the main portfolio website. The site includes:
- Professional portfolio information
- Project showcases
- Blog/technical articles
- Interactive elements powered by the serverless backend

### Quote Service

A serverless application written in Python that:
- Retrieves random inspirational/technical quotes from DynamoDB
- Provides RESTful API endpoints via API Gateway
- Updates the website dynamically with new quotes
- Demonstrates Python's capabilities for serverless backends

### Wordle Game Clone

An interactive word game built with:
- Svelte frontend framework
- Serverless backend to validate guesses and track statistics
- DynamoDB for word list and user score tracking

### Visitor Analytics

Simple analytics implementation written in Go that:
- Tracks unique visitors and pageviews
- Stores data in DynamoDB
- Displays visitor statistics on the website
- Showcases Go's performance benefits for serverless applications

## Terragrunt Implementation

This project uses Terragrunt to maintain DRY (Don't Repeat Yourself) infrastructure code while deploying across multiple environments and regions. Key Terragrunt features utilized:

- **Hierarchical configuration** - Common configurations defined once
- **Input variables** - Environment-specific values passed to modules
- **Remote state management** - State files stored in S3 with DynamoDB locking
- **Dependencies** - Explicit module dependencies to ensure proper deployment order

The configuration demonstrates how changing just a few variables allows deployment across entirely different regions while maintaining consistency in infrastructure.

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration and deployment:

- Automated testing and validation of infrastructure code
- Environment-specific deployment pipelines
- Conditional deployments based on branch/PR status
- Infrastructure validation before application deployment

## Getting Started

### Prerequisites

- AWS account with appropriate permissions
- Terraform (v1.0+)
- Terragrunt (v0.36+)
- Hugo (v0.80+)
- Node.js (v14+) - For Svelte development only
- Python (v3.8+) - For Python Lambda development
- Go (v1.18+) - For Go Lambda development
- GitHub account

### Local Development

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/dannowak-portfolio.git
   cd dannowak-portfolio
   ```

2. Install dependencies for applications:
   ```
   cd apps/hugo-site && npm install
   cd ../wordle-game && npm install
   ```

3. Run Hugo site locally:
   ```
   cd apps/hugo-site
   hugo server -D
   ```

4. Deploy infrastructure to dev environment:
   ```
   cd infrastructure/environments/us-west-2/dev
   terragrunt run-all apply
   ```

### Deployment

The project is set up for automated deployment:

- Commits to `main` branch trigger deployment to production
- Commits to `develop` branch trigger deployment to development
- Pull requests trigger infrastructure plan for validation

## License

MIT

## Author

Dan Nowak