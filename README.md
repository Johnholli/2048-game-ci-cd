**Overview of Project ☁️**

This project focuses on setting up a CI/CD pipeline for deploying a Dockerized version of the 2048 game to AWS. The pipeline automates the process
of building, testing, and deploying the game to a scalable infrastructure using Amazon ECS, Amazon ECR, and AWS CodePipeline.

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


**Prerequisites [Install Docker & AWS CLI Login]**

1. Docker installation
2. Configure AWS CLI

You need **Docker** and **AWS CLI** setup to perform this project. 

**Clone the website code**

The website code for 2048 game was already provided to me. To get the code, I opened Visual studio code and used the following command to clone the game code:

git clone https://github.com/techwithlucy/ztc-projects.git
cd ztc-projects/projects/advanced-aws-projects/project-1

**Run a Docker container and push to ECR**

The website code that I cloned already had a Dockerfile that defines the steps to be performed to run a container. Check the Dockerfile to containerize the 2048 game present in the root directory. 

<img width="1030" height="544" alt="image" src="https://github.com/user-attachments/assets/2b642950-a3ee-4118-8619-83c452b9864c" />


This Dockerfile is designed to create a lightweight container for hosting the 2048 game using the Nginx web server. It begins by using the official `nginx:latest` image as the base, which provides a preconfigured Nginx environment.

The `COPY` command transfers all the 2048 game files into Nginx’s default web root directory (`/usr/share/nginx/html`), ensuring they are ready to be served. The `EXPOSE 80` directive makes port 80 available, allowing the game to be accessed over HTTP.

Finally, the `CMD` command ensures that Nginx runs in the foreground (`daemon off ') when the container starts, serving the 2048 game seamlessly.

**Build the Docker Image**

Run the following commands in the terminal to build the image (Ensure the Docker Desktop is running in the background):

*docker build -t 2048-game .*

Tag the Docker Image for ECR:

Navigate to AWS Console > ECR and Create an ECR Repository (e.g., 097670902547.dkr.ecr.ap-south-1.amazonaws.com/2048-game-repo)

Use the ECR URI to tag the image:Replace <ECR_URI> with your ECR repository URI (e.g., 097670902547.dkr.ecr.ap-south-1.amazonaws.com/2048-game-repo) which can be found in the ECR console. 

<img width="1891" height="391" alt="image" src="https://github.com/user-attachments/assets/22308d38-c0c8-4b19-84b8-f6acc28b1995" />

*docker tag 2048-game:latest <ECR_URI>:latest*

**Push the Image to ECR**

Authenticate with ECR:

*aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <ECR_URI>*

Note : Do not forget to replace the ECR URI and change the region if needed

Push the image:

*docker push <ECR_URI>:latest*

Verify the Image in ECR

Navigate to the ECR console and confirm the image appears in the repository.

<img width="1563" height="256" alt="image" src="https://github.com/user-attachments/assets/2615dff2-8be8-420a-8280-dced4176f197" />

**Access the Website through ECS URL**

Now that you have pushed your container image to Amazon ECR, you need to run it on ECS before you can access it. Follow these sub‑steps: 

**Create the ECS Service‑Linked Role**

1. In the AWS Console, go to IAM → Roles → Create role.
2. Under Select trusted entity, choose AWS service.
3. In Use case, select Elastic Container Service.
4. Click Next → Name: AWSServiceRoleForECS→ Create role.

**Create an ECS Cluster**

In the AWS Console, go to ECS → Clusters → Create cluster.
Give your cluster a name, e.g. `2048-game-cluster`, then Create.

Choose Infrastructure as AWS Fargate and leave other settings as default.

Click Create, Wait for the cluster to get created.

**Register a Task Definition**

In ECS → Task Definitions → Create new Task Definition.

Task Definition name: `2048-game-task`
Select FARGATE → Next step.

Under Container definitions, click Add container:
- Container name: `2048-container`
- Image: `<your‑ecr‑uri>:latest`

Port mappings: Host port 80 → Container port 80

Add, then Create.

**Create a Service**

In ECS → Clusters, select `2048-game-cluster`.
Services tab → Create.

Launch type: FARGATE
Task Definition: `2048-game-task`
Service name: `2048-service`
Number of tasks: `1 '

Under Network, choose default VPC and subnets, Public IP = ENABLED

For Security group, select (or create) one allowing HTTP (port 80)

Next step → Create service → View service.

**Find the Public IP of the ECS Task**

- In Clusters → `2048-game-cluster` → Tasks, click the running task.
- Under Network, note the Public IP.

**Access the Website Using the Public IP**

Open your browser and enter the public IP address of the ECS task. For example:

http://<Public-IP>:80

Replace <Public-IP> with the actual IP address from the previous step.

Verify Functionality

Ensure the website is fully functional, including loading the game and interacting with the frontend as intended

**Create Your Own GitHub Repository**

Since you will be performing CI/CD operations, you need to have your own GitHub repository with the website code. To do this— 

**Create a New GitHub Repository**

Navigate to GitHub and create a new repository. Provide a repository name, such as `2048-game-ci-cd`.

Optionally, add a description for the repository (e.g., "CI/CD pipeline setup for 2048 game").

Do not initialize with a README or `.gitignore` (as you'll be pushing an existing codebase).

Click Create repository.

**Modify buildspec.yml**

Update the `buildspec.yml` by changing the placeholders:

The `buildspec.yml` file is crucial for AWS CodeBuild as it defines the build commands. You’ll need to modify it to reflect your project’s ECR URI and ECS service details.

Here’s an example of a typical `buildspec.yml` file for building a Docker image and pushing it to ECR:

<img width="1818" height="1104" alt="image" src="https://github.com/user-attachments/assets/9d3283c7-f26c-47bb-bb79-84760293efcd" />
​
**Placeholder Details:**

<your-region>: Replace this with your AWS region (e.g., `ap-south-1`, `us-east-1`).

<your-ecr-repository-uri>: Replace this with your Amazon ECR repository URI (e.g., `123456789012.dkr.ecr.ap-south-1.amazonaws.com/2048-game-repo`).

<image-name>: Replace this with the name of the Docker image you're building (e.g., `2048-game`).

<container-name>: Replace this with the ECS container name (e.g., `2048-container`).

Explanation:

- *install phase*: Specifies the Docker version to use.

- *build phase*: Builds the Docker image, logs into ECR, tags the image, and prepares it for pushing.

- *post_build phase*: Pushes the Docker image to ECR and generates the imagedefinitions.json file, which ECS uses for deployments.

- *artifacts*: The imagedefinitions.json file is saved as an artifact so it can be used in later stages like ECS deployment.

**Push Your Local Code to GitHub**

Open a terminal or command prompt in the folder where your code and `buildspec.yml` are located.
Run the following commands to push your code to the newly created GitHub repository:

git init
git add .
git commit -m "Initial commit"
git remote remove origin
git remote add origin <your-repository-url>
git branch -M main
git push -u origin main
Explanation:

`git init`: Initializes a Git repository in your project folder.

`git add .`: Stages all files in the directory for commit.

`git commit -m "Initial commit"`: Commits the files to the local repository.

`git remote add origin <your-repository-url>`: Links your local repository to the GitHub remote repository.

`git push -u origin main`: Pushes the code to the `main` branch on GitHub.

**Verify on GitHub**

Visit the GitHub repository page, and you should see all your files, including the Dockerfile, buildspec.yml, and the 2048 game source code.


