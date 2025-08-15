**Overview of Project ☁️: Build a CI/CD Pipeline for a 2048 Game**

This project focuses on setting up a CI/CD pipeline for deploying a Dockerized version of the 2048 game to AWS. The pipeline automates the process
of building, testing, and deploying the game to a scalable infrastructure using Amazon ECS, Amazon ECR, and AWS CodePipeline.

**Steps to be performed 👨🏾‍💻**

1. Set Up ECS Cluster and ECR Repository
2. Prepare the 2048 Game Code
3. Set Up CodeBuild for Continuous Integration
4. Set Up CodePipeline for Continuous Deployment

**Services Used 🛠**

-**AWS CodePipeline**: Orchestrates the CI/CD pipeline, automating the build, test, and deployment stages. [Automation]

-**Amazon ECS**: Deploys and manages containerized applications using Fargate for serverless container management. [Deployment]

-**Amazon ECR**: Stores and manages Docker images used in the ECS tasks. [Container Registry] 

-**AWS CodeBuild**: Handles the build phase of the pipeline, including Docker image creation.[Build]

-**IAM Roles & Policies**: Ensure secure access between the services involved. [Permissions]



➡️ **Architecture** 

This is the architectural diagram for the project:

<img width="1357" height="540" alt="image" src="https://github.com/user-attachments/assets/e3aa7ee1-7901-4b39-99b0-2e4e4c5bfec6" />



➡️ Final Result

This is what the project looks like, once built:

<img width="867" height="705" alt="2048 by me" src="https://github.com/user-attachments/assets/40ba844f-2fcc-4433-839b-ccb0a748cef8" />


**Prerequisites [Install Docker & AWS CLI Login]**

1. Docker installation
2. Configure AWS CLI

**Setup Instructions** 

**1. Clone the website code**

<img width="1816" height="138" alt="image" src="https://github.com/user-attachments/assets/0b4c8928-1aa1-4c34-b5ea-6170df091d6f" />


**2. Run a Docker container and push to ECR**

Check the Dockerfile to containerize the 2048 game present in the root directory. 

<img width="1030" height="544" alt="image" src="https://github.com/user-attachments/assets/2b642950-a3ee-4118-8619-83c452b9864c" />


💡 This Dockerfile is designed to create a lightweight container for hosting the 2048 game using the Nginx web server. It begins by using the official `nginx:latest` image as the base, which provides a preconfigured Nginx environment.

💡The `COPY` command transfers all the 2048 game files into Nginx’s default web root directory (`/usr/share/nginx/html`), ensuring they are ready to be served. The `EXPOSE 80` directive makes port 80 available, allowing the game to be accessed over HTTP.

💡The `CMD` command ensures that Nginx runs in the foreground (`daemon off ') when the container starts, serving the 2048 game seamlessly.


**Build the Docker Image**

Run the following commands in the terminal to build the image (Ensure the Docker Desktop is running in the background):

<img width="1808" height="94" alt="image" src="https://github.com/user-attachments/assets/aa3fbf9b-ce85-4834-8fe3-a0570de3438c" />


Tag the Docker Image for ECR:

-Navigate to AWS Console > ECR and Create an ECR Repository

-Use the ECR URI to tag the image (e.g., 097670902547.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo)

<img width="2749" height="547" alt="image" src="https://github.com/user-attachments/assets/23d4aeae-41ac-4ed8-b10c-620312c44fe5" />


<img width="1814" height="100" alt="image" src="https://github.com/user-attachments/assets/3559bee0-1282-4ea4-846f-606690426886" />


**Push the Image to ECR**

Authenticate with ECR:

<img width="1808" height="92" alt="image" src="https://github.com/user-attachments/assets/376c59e1-d585-49d2-8eb3-20dce023fb42" />


Push the image:

<img width="1812" height="94" alt="image" src="https://github.com/user-attachments/assets/c8a56895-971b-47da-917e-d0bc50546b19" />


Verify the Image in ECR

Navigate to the ECR console and confirm the image appears in the repository.

<img width="2642" height="630" alt="image" src="https://github.com/user-attachments/assets/b748ba91-2e7a-428c-ab00-106e2c7a640b" />


**3. Access the Website through ECS URL**

Now that you have pushed your container image to Amazon ECR, you need to run it on ECS before you can access it. Follow these sub‑steps: 

**Create the ECS Service‑Linked Role**

1. In the AWS Console, go to IAM → Roles → Create role.
2. Under Select trusted entity, choose AWS service.
3. In Use case, select Elastic Container Service.
4. Click Next → Name: AWSServiceRoleForECS→ Create role.

**Create an ECS Cluster**

-In the AWS Console, go to ECS → Clusters → Create cluster.
-Give your cluster a name, e.g. `2048-game-cluster`, then Create.

<img width="1896" height="415" alt="image" src="https://github.com/user-attachments/assets/d5bdb908-c78f-4367-ab1d-ef7cf6b3533f" />

-Choose Infrastructure as AWS Fargate. Leave other settings as default.

-Click Create.

**Register a Task Definition**

In ECS → Task Definitions → Create new Task Definition.

Task Definition name: `2048-game-task`
Select FARGATE → Next step.

<img width="1306" height="712" alt="image" src="https://github.com/user-attachments/assets/f741b649-8525-49a4-8c12-1f99ea75e7af" />


Under Container definitions, click Add container:
- Container name: `2048-container`
- Image: `<your‑ecr‑uri>:latest`

<img width="1542" height="318" alt="image" src="https://github.com/user-attachments/assets/1764c9c8-b357-4469-9630-8f7cf5634f82" />


Port mappings: Host port 80 → Container port 80

Add, then Create.

**Create a Service**

In ECS → Clusters, select `2048-game-cluster`.
Services tab → Create.

Launch type: FARGATE
Task Definition: `2048-game-task`
Service name: `2048-service`
Number of tasks: `1 '

<img width="1475" height="600" alt="image" src="https://github.com/user-attachments/assets/979fca10-c777-4ad4-adf3-69a5eb713002" />


Under Network, choose default VPC and subnets, Public IP = ENABLED

For Security group, select (or create) one allowing HTTP (port 80)

Next step → Create service → View service.

**Find the Public IP of the ECS Task**

- In Clusters → `2048-game-cluster` → Tasks, click the running task.
- Under Network, note the Public IP.

**Access the Website Using the Public IP**

Open your browser and enter the public IP address of the ECS task. 

**Verify Functionality**

Ensure the website is fully functional, including loading the game and interacting with the frontend as intended

<img width="1916" height="1027" alt="image" src="https://github.com/user-attachments/assets/73f59a70-830b-4452-a421-e5c94d409fbc" />

**Modify buildspec.yml**

Update the `buildspec.yml` by changing the placeholders:

The `buildspec.yml` file is crucial for AWS CodeBuild as it defines the build commands. You’ll need to modify it to reflect your project’s ECR URI and ECS service details.

<img width="1638" height="801" alt="image" src="https://github.com/user-attachments/assets/c02c6835-c095-4aa4-abd2-5b961921ca2b" />

​
**Placeholder Details:**

<your-region>: Replace this with your AWS region (e.g.`us-east-1`).

<your-ecr-repository-uri>: Replace this with your Amazon ECR repository URI (e.g., `123456789012.dkr.ecr.ap-south-1.amazonaws.com/2048-game-repo`).

<image-name>: Replace this with the name of the Docker image you're building (e.g., `2048-game`).

<container-name>: Replace this with the ECS container name (e.g., `2048-container`).

**Explanation:**

- *install phase*: Specifies the Docker version to use.

- *build phase*: Builds the Docker image, logs into ECR, tags the image, and prepares it for pushing.

- *post_build phase*: Pushes the Docker image to ECR and generates the imagedefinitions.json file, which ECS uses for deployments.

- *artifacts*: The imagedefinitions.json file is saved as an artifact so it can be used in later stages like ECS deployment.

**Push Your Local Code to GitHub**

Open a terminal or command prompt in the folder where your code and `buildspec.yml` are located.
Run the following commands to push your code to the newly created GitHub repository:

<img width="1810" height="358" alt="image" src="https://github.com/user-attachments/assets/ae0b9efc-c599-41d0-b72c-8337c323ce96" />


Explanation:

`git init`: Initializes a Git repository in your project folder.

`git add .`: Stages all files in the directory for commit.

`git commit -m "Initial commit"`: Commits the files to the local repository.

`git remote add origin <your-repository-url>`: Links your local repository to the GitHub remote repository.

`git push -u origin main`: Pushes the code to the `main` branch on GitHub.

**Verify on GitHub**

Visit the GitHub repository page, and you should see all your files, including the Dockerfile, buildspec.yml, and the 2048 game source code.

NEXT STEPS TO BE PERFORMED: 

1. Create an IAM Role for CodeBuild.
2. Create a S3 Bucket for Build Artifacts.
3. Create a CodeBuild Project.
4. Test the CodeBuild Project.
5. Create an AWS CodePipeline

**1. Create an IAM Role for CodeBuild**

AWS services like CodeBuild need permissions to interact with ECR (Elastic Container Registry), ECS, S3, and CodeBuild itself. To give CodeBuild all the necessary permissions— 
Create a New IAM Role

Navigate to the IAM section of the AWS console.
Choose Create Role and select CodeBuild as the trusted entity type.

<img width="1540" height="718" alt="image" src="https://github.com/user-attachments/assets/f5e2c418-4cb5-4af9-994a-41997cb82cf3" />

**Attach the following Managed Policies:**

-AmazonEC2ContainerRegistryFullAccess: Allows CodeBuild to interact with ECR (Elastic Container Registry).

-AWSCodeBuildDeveloperAccess: Grants permissions for CodeBuild to access build-related resources.

-AmazonS3FullAccess: Grants access to read/write to S3 buckets (for storing build artifacts).

Attach Inline Policy for ECS:
Navigate to the codeBuildServiceRole you created and click on Add Permissions > Attach Inline Policies.

<img width="1478" height="747" alt="image" src="https://github.com/user-attachments/assets/b79b0870-1f96-464a-b2d9-06508a7e61df" />


-Click on JSON

-Attach the following Inline Policy to allow CodeBuild to update ECS services:

<img width="1808" height="620" alt="image" src="https://github.com/user-attachments/assets/67b0d1f3-b300-4e4a-981b-9b0b144d44f4" />

-Click on Next. Give the policy a name (e.g. ECSAccessPolicy) and click on Create Policy. 

<img width="1575" height="747" alt="image" src="https://github.com/user-attachments/assets/21b33d1b-3ef0-423f-983b-ad6e4a1457b2" />

**2. Create an S3 Bucket for Build Artifacts**

CodeBuild generates output files, such as Docker images and logs. We store them in Amazon S3 so they can be accessed later. 

-Go to the S3 Console and create a new bucket (e.g., 2048-ci-cd-pipeline-artifacts1).

-Keep the rest of the settings as default and click on Create Bucket. 

**3. Create a CodeBuild Project**

The CodeBuild project is where AWS pulls your GitHub repository, builds the project (e.g., compiles code, builds Docker images), and pushes the results to S3. Create a CodeBuild project by following the steps below— 
Go to the CodeBuild Console

-Navigate to the CodeBuild Console and choose Create Build Project.

*Configure the Project*

-Project Name: Enter a project name (e.g., 2048-game-build).

-Source Provider: Choose GitHub (or other source if required) and connect to your GitHub repository. Connect to GitHub by clicking on Manage default source credential. 

-Choose the option OAuth App for Credential type and CodeBuild for service. 

<img width="921" height="499" alt="image" src="https://github.com/user-attachments/assets/e861a4ca-83f5-4404-880b-5d4bea4c91ab" />


-After you are successfully connected to GitHub, you can choose your respective GitHub repository that you created in the last step. 

Environment:
Keep the environment configurations as default.
Under the Service role, choose Existing role and select the codeBuildServiceRole IAM role that was created earlier.

<img width="897" height="250" alt="image" src="https://github.com/user-attachments/assets/aa45e03a-d6f4-4b54-a054-891c257345e0" />


Buildspec Configuration

Click on Use a buildspec file option. 

<img width="911" height="355" alt="image" src="https://github.com/user-attachments/assets/395b122e-dbd9-4a8a-a88a-3bf8e753ae67" />


Artifacts Configuration

Type: Select Amazon S3 for artifacts.
Bucket: Choose the S3 bucket `2048-ci-cd-pipeline-artifacts1`.
Leave the rest as default.

<img width="892" height="382" alt="image" src="https://github.com/user-attachments/assets/0d49afbe-69c6-425b-b227-f676ca8b325f" />


Create the Build Project

-Review all the settings and click Create Build Project.

**4. Test the CodeBuild Project**

Start a Build

Trigger the build manually from the CodeBuild console and monitor its progress.

Verify Build Success:

Check the Build Logs to ensure the Docker image is built and pushed to ECR successfully.

<img width="1031" height="586" alt="image" src="https://github.com/user-attachments/assets/03fc0aef-bea1-422a-9478-bb3c6b8ef262" />


Verify the imagedefinitions.json file is created in the specified S3 artifact bucket.

<img width="2641" height="689" alt="image" src="https://github.com/user-attachments/assets/c9c6d53e-fde4-4fe8-8908-aadc8cb5fb17" />


**5. Create an AWS CodePipeline**

AWS CodePipeline is the service that connects all the different stages of your CI/CD pipeline. First, we need to create a new pipeline to define how changes in your code will trigger builds and deployments

**Create a New Pipeline**

A pipeline is a sequence of automated steps that CodePipeline follows whenever there’s a code update. We need to define the pipeline structure before adding specific build and deploy steps.

1. Create Pipeline: Click on the Create pipeline button to begin creating a new pipeline.

2. Click on Build Custom pipeline and click Next. 

3. Pipeline Name:
Give your pipeline a name (e.g., `2048-game-pipeline`).

4. Service Role:
Create a new service role. Add a role name (`e.g. codePipelineServiceRole`). click next. 

**Add Source Stage (GitHub)**

The source stage tells CodePipeline where to pull the latest code from. In this case, we’re using GitHub as our repository.

1. Source Provider:
Choose GitHub(via OAuth App) as the source provider.

<img width="938" height="778" alt="image" src="https://github.com/user-attachments/assets/832fc0db-8b11-4ada-95f7-0bae85ba9c4b" />


3. Connect to GitHub:
Click on Connect to GitHub.
*(If you haven't already connected your GitHub account to AWS before, you’ll be prompted to authorize AWS to access your GitHub repositories.)*

4. Repository:
Select the GitHub repository where your project code is stored. Ensure that this repository is the one you intend to build and deploy. Click the main branch.

5. Keep the rest as default and click Next. 

**Add Build Stage (CodeBuild)**

After pulling code from GitHub, AWS needs to build and test the application before deploying it. We use AWS CodeBuild for this step.

1. Build Provider:
Select AWS CodeBuild as the build provider.

2. Project Name:
Choose the CodeBuild project that you created earlier (e.g., `2048-game-build`).

3. Keep the rest as default and click Next.
4. Skip the Test stage.

**Add Deploy Stage (ECS Deployment)**

Once the application is built successfully, it needs to be deployed to Amazon ECS so the latest version is live. This step ensures seamless automatic updates. Deploy Provider:

Choose Amazon ECS as the deploy provider.

<img width="842" height="507" alt="image" src="https://github.com/user-attachments/assets/91164999-72f9-475b-b2fb-58801f9f6908" />


1. Cluster: Choose your ECS cluster (e.g., 2048-game-cluster).
2. Service: Choose your ECS service (e.g., 2048-service).
3. Keep the rest as default and click Next.

<img width="920" height="642" alt="image" src="https://github.com/user-attachments/assets/09aaecf4-abf0-472b-868e-b78a7ae90d68" />


**Review and Create Pipeline**

1. Review:
Review all the stages to ensure that the source, build, and deploy steps are configured correctly.

2. Create Pipeline:
Once everything looks good, click Create pipeline to finalize the process.

3. The CodePipeline will run the test process and verify that every step succeeds.

<img width="1422" height="692" alt="image" src="https://github.com/user-attachments/assets/66833ec7-e277-4607-bc25-a0ba3d091030" />

**Verify the Deployment.**

-Visit Your Website:
After the pipeline runs successfully, visit the URL where your website is hosted.
You can get the IP address of the website by navigating to ECS> Cluster> 2048-game-cluster, click on the Tasks tab and click on the latest task.

Under the Networking tab, you will find the Public IP address. Open a new chrome tab and type in the URL as: 

<img width="1808" height="94" alt="image" src="https://github.com/user-attachments/assets/67e2d988-83f8-4770-8ccd-abea03a03e65" />

This project focused on building a complete CI/CD pipeline on AWS to automate the deployment of a containerized application, enhancing efficiency, reliability, and scalability.


**Conclusion: What did I learn?:**

By completing this project, I gained hands-on experience in cloud DevOps automation using AWS services.
-Set up a CI/CD pipeline using AWS CodePipeline and CodeBuild.
-Containerized the application and deployed it using Amazon ECS.
-Automated build, test, and deployment workflows to reduce manual effort.
-Improved consistency and speed of application delivery.


**⚠️ Clean-up!**

1. Delete AWS CodePipeline:
Go to the CodePipeline Console and delete the pipeline you created for this project.

2. Delete CodeBuild Project:
Navigate to the CodeBuild Console, find your build project, and delete it.

3. Remove IAM Roles and Policies:
Delete the IAM roles created for CodePipeline, CodeBuild, and any inline policies associated with them.

4. Delete S3 Bucket:
If no longer needed, go to the S3 Console and delete the bucket you created for storing artifacts.

5. Delete ECR Repository:
Go to the ECR Console, and delete the repository used for storing Docker images.

6. Delete ECS Services and Cluster:
In the ECS Console, delete any services or clusters related to the project (e.g., the `2048-game-cluster` and `2048-service`).



