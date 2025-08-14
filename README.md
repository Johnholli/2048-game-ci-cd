**Overview of Project ☁️**

This project focuses on setting up a CI/CD pipeline for deploying a Dockerized version of the 2048 game to AWS. The pipeline automates the process
of building, testing, and deploying the game to a scalable infrastructure using Amazon ECS, Amazon ECR, and AWS CodePipeline.

Key tasks include:

-Building and pushing a Docker image of the 2048 game to Amazon ECR.
-Setting up a CodePipeline to automate the build and deploy process.
-Deploying the Dockerized game to Amazon ECS using a Fargate launch type.

**Steps to be performed 👨🏾‍💻**

1. Set Up ECS Cluster and ECR Repository
2. Prepare the 2048 Game Code
3. Set Up CodeBuild for Continuous Integration
4. Set Up CodePipeline for Continuous Deployment

**Services Used 🛠**

-AWS CodePipeline: Orchestrates the CI/CD pipeline, automating the build, test, and deployment stages. [Automation]
-Amazon ECS Deploys and manages containerized applications using Fargate for serverless container management. [Deployment]
-Amazon ECR: Stores and manages Docker images used in the ECS tasks. [Container Registry] 
-AWS CodeBuild: Handles the build phase of the pipeline, including Docker image creation.[Build]
-IAM Roles & Policies: Ensure secure access between the services involved. [Permissions]

**Estimated Time & Cost ⚙️**

This project was estimated to take about 1-2 hours but took me about 3 hours.. 
Cost: ~$1 or less (with minimal usage of AWS Fargate, ECR, and CodeBuild. Delete resources when done!)

➡️ Diagram

This is the architectural diagram for the project:

<img width="1357" height="540" alt="image" src="https://github.com/user-attachments/assets/e3aa7ee1-7901-4b39-99b0-2e4e4c5bfec6" />


➡️ Final Result

This is what the project looks like, once built:

<img width="867" height="705" alt="2048 by me" src="https://github.com/user-attachments/assets/40ba844f-2fcc-4433-839b-ccb0a748cef8" />
