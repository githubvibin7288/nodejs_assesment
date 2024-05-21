Project Assessment – Vananam
Tasks: -
1.	Containerization:
•	Create a Dockerfile to containerize the above application.
•	Ensure the container runs the web server on port 8080.
•	Provide a docker-compose.yml file if needed for any multi-container setup.
2.	Continuous Integration Setup:
•	Choose a CI tool (e.g., Jenkins, GitHub Actions, GitLab CI).
•	Create a pipeline that:
•	Triggers on every git push to the main branch.
•	Builds the Docker image.
•	Runs any tests (you can include a dummy test for demonstration).
3.	Continuous Delivery Setup:
•	Use the same or a different tool to manage CD (e.g., Jenkins, Spinnaker, ArgoCD).
•	Setup the CD pipeline to:
•	Deploy the Docker container to a simulated staging environment upon successful CI build.
•	Provide rollback capabilities in case deployment fails.

Project Overview: -
Project Name: Simple web application in CI/CD pipeline
Delivery Platform: Jenkins
Project Components and Pipeline
Jenkins Files: This application own Jenkins File defining the steps for building, testing, and deploying the service
Docker: Microservices are containerized using Docker, allowing for consistent environments from development to production.

GitHub Repository Link: - 
Continuous Integration  GitHub –webhook Jenkins  Docker
Continuous Delivery  Docker containerization

PHASE 1: Infrastructure Setup
Launch virtual Machine using AWS EC2:
Here is a detailed list of the basic requirements and setup for the EC2 instance I have used for running Jenkins, including the specific instance type, AMI, and Security groups.
EC2 instance requirement setup:
1.	Instance Type:
-	Type: t2.medium
-	vCPUs: 
-	Memory: 4GB
-	Network Performance: Moderate
2.	Amazon Machine Image (AMI)
-	AMI: ubuntu Server 22.04 LTS (HVM)
3.	Security Groups
Security groups act as a virtual firewall for your instance to control inbound and outbound traffic.
Screenshot of SG:

 ![Screenshot Security Group](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/a92092d0-b0fa-4b38-81ea-927e7ceb5f64)

After Launching your virtual machine, SSH into the server.
Install Jenkins, Docker on VM Server
Execute the commands on the server.
#! /bin/bash
#Install OpenJDK 17 JRE
sudo apt update -y
sudo apt install fontconfig openjdk-17-jre -y
#Download Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
#Add Jenkins repository to package manager resource
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
#Update package manager respositories
sudo apt-get update -y
#Install jenkins
sudo apt-get install jenkins -y
java -version
jenkins --version

Save this script in a file, for example, install_jenkins.sh, and make it executable using:
chmod +x install_jenkins.sh
then you can run the script using:
./install_jenkins.sh
This script will automate the installation process of OpenJDK 17 and Jenkins

Screenshot of Install 

 ![Screenshot Version checking](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/4920f7a6-551d-4034-bc27-69b1d2b5a076)

Phase 2: Create a Jenkins Pipeline
Step 1: Install Jenkins plugins
To get started, you need to install the required Jenkins plugins. Follow these steps to install the plugins.
Access Jenkins Dashboard:
Open a web browser and navigate to your Jenkins instance (e.g., http://your-instance-public-dns:8080).
Log in with your Jenkins credentials. (cat address provided on Jenkins)
As per project requirement container must run on port 8080, in mean while Jenkins port also 8080, so we have to change the Jenkins port number from access following steps.
1.	Open the /usr/lib/systemd/system/Jenkins.service file.
2.	After open this file under Environment section, you can change the port like this HHTP_PORT=8100
3.	Then you should restart Jenkins with sudo systemctl daemon reload
4.	Then check the status use this command sudo systemctl restart Jenkins.service

Screenshot for change port number of Jenkins 

 ![Screenshot jenkis port change](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/af4cfe1e-8fab-4f83-8725-b7541fe31228)


Install Plugins:
-Go to Manage Jenkins  Manage Plugins
-Click on the Available tab.
Search for and install the following plugins:
•	Docker: Enables Jenkins to use Docker containers.
•	Docker Pipeline: Allows Jenkins to use Docker containers in pipeline jobs.
•	NodeJS: Allows to create as many NodeJS installations.
Screenshot of plugin 

 ![Screenshot 2024-05-21 083645](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/8760135f-7cb0-4593-865b-e8d07710370f)


Step 2: Create Credentials
You need to create credentials for Docker and GitHub access.
Create Docker Credentials:
-Go to Manage Jenkins  Manage Credentials  (global)  Add Credentials.
-Choose Username with password as the kind.
-ID: docker-cred
-Username: Your Docker Hub username.
-Password: Your Docker Hub password.
-Click OK.




Screenshot of Docker Cred 

 ![Screenshot 2024-05-21 083912](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/ee7c2ced-643d-4a10-982c-f0321313fa50)


Create GitHub Credentials:
-Go to Manage JenkinsManage Credentials  (global)  Add Credentials.
-Choose Secret text as the kind.
-ID: git-cred
-Secret: Your GitHub Personal Access Token.
-Click OK.
Screenshot of Git cred 

 ![Screenshot 2024-05-21 084735](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/7a26d975-42fe-40e6-b9cf-b31e382944c6)


Step 3: Install NodeJS and Docker on Jenkins
-Go to Manage Jenkins  Tools.
-Navigate down NodeJS installations  add NodeJS
-Name: nodejs10
-then select Install automatically  then leave the other settings as in Jenkins
-Navigate down Docker Installations  add Docker
-Name: docker
-then select Install automatically  Download from docker.com  then leave the remain settings as Jenkins
-Click apply and save.
Screenshot of Nodejs and Docker tools config 

 ![Screenshot 2024-05-21 084811](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/d053f765-c086-4e9a-9d36-f47826778913)

![Screenshot 2024-05-21 084847](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/f1bd67ce-c54a-4be3-9762-22816278a57e)
 

Step 4: Create a Jenkins pipeline
Stage 1: Git SCM checkout
This is the first step in the CI/CD pipeline where the source code is fetched from a Git repository. This stage ensures that the latest codebase is used for each build.
Stage 2: Install Project Dependencies
Install project specific dependencies using package managers like npm (for Node.JS).
Install Node.js dependencies using npm install.
Stage 3: Build Docker Image and Push into Docker Hub Repo
Package the application into a Docker image for containerized deployment. 
Create Dockerfile specifying image configuration.
Build Docker image using Docker build command.
Push the built Docker image to a Docker Hub repository for centralized storage and distribution.
Steps:
1.	Authenticate with Docker Hub.
2.	Push Docker image to designated repository
Stage 4: Deploy application to Docker container
Deploy the application from creating Docker container and port forwarding into 3000 for see the output.
Verify the successful deployment of the application to the containerization.
Here’s a declarative Jenkins pipeline script for the described stages:
Screenshot of Jenkins code
pipeline {
    agent any
    tools {
        nodejs 'nodejs10'
    }
    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kpselvaips/nodejs_assesment.git'
            }
        }
      stage('Install dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('docker build & push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker build -t newimage .'
                        sh 'docker tag newimage kpselvaperiyasamy/nodejsassesment:${BUILD_NUMBER}'
                        sh 'docker push kpselvaperiyasamy/nodejsassesment:${BUILD_NUMBER}'
                    }
                }
            }
        }
        stage('docker container') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker run -d --name demo-nodejssample -p 8080:3000 kpselvaperiyasamy/nodejsassesment:${BUILD_NUMBER}'
                    }
                }
            }
        }
    }
}

Screenshot of Output  

 ![Screenshot 2024-05-21 103204](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/a4ee08c7-f39d-4b88-926a-c92b1afb6492)



Step 5: Configure Jenkins Pipeline
Save the Jenkinsfile into GitHub 
-Configure Branch Sources:
-Under branch sources, Click Add Source.
-Choose Git.
Project Repository: Enter the repository URL (?)
Credentials: Select the git-cred credentials.
Configure Build Configuration:
Under Build Configuration, ensure by Jenkinsfile is selected.
Script Path: Leave it as the default (Jenkinsfile).
Screenshot of path setting 
 ![Screenshot 2024-05-21 112721](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/6574a793-4d88-4f4d-bbae-8ffde315cc1b)

Step 6: Set up GitHub Webhook
Go to GitHub Repository Settings:
-Navigate to your repository on GitHub.
-Go to Settings Webhooks
Add Webhook:
-Click Add webhook
-Payload URL: enter the webhook URL from Jenkins URL (e.g., http://your-jenkins-instance:8080/webhook)
-Remain settings leave it as Usual.
-Click add webhook.
Screenshot of webhook 

 ![Screenshot 2024-05-21 120921](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/1720247d-23d0-43ab-8f2b-e1f91918526c)

After Completing this you will see your Jenkins pipeline starts build automatically.
Step 6: Edit application file
Go to GitHub and make a change of app.js file and commit the changes.
Once done commit, then trigger automatically push to build pipeline.
Screenshot of make change the file 

![Screenshot 2024-05-21 120452](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/646743cb-a9fc-4322-94b8-16eb1d2eeb88)
 
Final output after commit the changes:
Screenshot of final output; 

 ![Screenshot 2024-05-21 120633](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/cb2ef6f3-38bf-4c02-88aa-500eff6d545a)
 
 ![Screenshot 2024-05-21 120827](https://github.com/kpselvaperiyasamy/nodejs_assesment/assets/170388524/b0cbff92-0116-4835-b7b5-fd2ce6e2eb68)


 

