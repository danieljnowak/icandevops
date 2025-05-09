+++
title = "Projects"
description = "Dan Nowak's DevOps Projects"
date = "2023-07-01"
author = "Dan Nowak"
+++

# DevOps Projects

Here are some of the key projects I've worked on that demonstrate my DevOps and cloud infrastructure skills.

## Portfolio Website Infrastructure

The website you're currently viewing is built using the following technologies:

- **Infrastructure as Code**: Terraform with Terragrunt for multi-environment configuration
- **Cloud Provider**: AWS (S3, CloudFront, Route 53, Lambda, API Gateway, DynamoDB)
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Frontend**: Hugo static site generator
- **Monitoring**: CloudWatch for logs and metrics

The infrastructure is deployed across multiple environments (development and production) in different AWS regions, demonstrating a real-world multi-region architecture.

[View on GitHub](https://github.com/yourusername/dannowak-portfolio)

## Quote Service API

A serverless API built with:

- **Backend**: Python Lambda functions
- **API Management**: API Gateway with custom domain
- **Database**: DynamoDB for storing quotes
- **Authentication**: Lambda Authorizer for secured endpoints
- **Infrastructure**: Defined using Terraform modules

The service provides random inspirational and technical quotes to the portfolio website, demonstrating how to build and deploy serverless APIs.

## Visitor Analytics

A lightweight analytics solution that:

- **Backend**: Go Lambda functions for high performance
- **Database**: DynamoDB for visitor data storage
- **Privacy**: Designed with GDPR compliance in mind, no personal data collection
- **Visualization**: Custom dashboard built with React

This project shows how to implement basic analytics without relying on third-party services, maintaining user privacy while still gathering useful insights.

## Wordle Game Clone

An interactive word game implementation:

- **Frontend**: Built with Svelte for a reactive UI
- **Backend**: Serverless API for word validation and scoring
- **Database**: DynamoDB for word lists and high scores
- **Deployment**: Automated CI/CD pipeline with GitHub Actions

The game demonstrates frontend and backend integration in a serverless architecture, with both sharing infrastructure defined in Terraform. 