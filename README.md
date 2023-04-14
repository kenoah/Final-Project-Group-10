## ACS730 NAA 
# Final Project: Two-Tier Web Application Automation with Terraform 
## Group 10

Overview

The purpose of this project is to demonstrate the use of Terraform for automating the deployment of a two-tier web application on AWS. The infrastructure architecture is built on AWS, and it is designed to host the website on multiple instances across different environments with varying configurations. This project involves the use of launch templates, auto-scaling groups and policies, load balancers, and AWS Identity and Access Management. The implementation of this project also showcases the usage of Terraform modules and GitHub Actions.

Learnings
This project provides valuable information on how to use the Infrastructure as Code tool called "Terraform" effectively to deploy infrastructure. It covers the use of various infrastructure constructs such as auto-scaling groups, load balancers, bastion usage, auto-scaling policies, and cloud watch metrics. In addition, by using Terraform constructs like modules and following best practices, this project also sheds light on industry practices for infrastructure deployment.

### The‌ ‌Roadmap‌ ‌is‌ ‌divided‌ ‌into‌ ‌2‌ ‌Sections‌ ‌

### I | Navigating through the code base and setting up the Prerequisites
#### 1 | Cloning the repository and Exploring the branches

  ``` 
  git clone git@github.com:kenoah/Final-Project-Group-10.git
  ```
  
  ***Note:*** The clone command is SSH based, so ensure that SSH key is added in your environment.
  
  - Once the local repository is setup, navigate to the branch you want to work on (dev is preferred) using 
                ``` git checkout <branch-name> ```
  
  - The repo has 3 main branches prod, dev and staging. prod is the main/default branch of the repsository.
  The development changes is done within the dev branch and the working code shall be pulled onto staging and prod branches.

#### 2 | Understanding the Code Base Structure
    
    The code base has the following structure,
      1. environments
        - dev
          --> networking
          --> webserver
        - prod
          --> networking
          --> webserver
        - staging
          --> networking
          --> webserver
      2. images
      3. modules
        --> aws_network
        --> aws_webserver
        
  - The environments folder is the root folder that contains the configuration for each of the prod, dev and staging environments. It has networking and webserver subfolders that is dependent on the aws_network and aws_webserver modules present in the modules folder.
  - The networking part specifies the configuration with respect to the network of the architecture which includes the VPC, subnets and the network gateways.
  - The webserver folder has the configuration related to the load balancer, server template, auto scaling group, user data and the security groups.
  - Finally, the images folder has the images that need to be uploaded to the S3 bucket which will be accessed by the webservers to render the webpage.

#### 3 | Generating SSH Keys
  In all the webserver folders of the environments root folder, SSH keys need to be generated which is used for deploying the infrastructure.
  The naming convention to be followed is "Group10"-<environment-name>, for example "Group10-prod".
  
  To generate SSH key use the command below, the format is changes according to the branch it is been executed in:
  ```
  ssh-keygen -t rsa -f Group10-Dev
  ```

#### 3 | Deploying S3 bucket
  On the AWS management console create S3 buckets for each environment. These buckets will store the tfstate for its corresponding environments and also the images to be displayed on the webpage.
  The naming of the s3 buckets should be as follows:
    - dev-s3-acsgroup10,
    - staging-s3-acsgroup10,
    - prod-s3-acsgroup10,
  
  Each of the buckets should have the images folder in the git uploaded to it.
  
  ***Note:*** If there is a bucket already existing with the names given above choose and other name and do the necessary configuration changes in config.tf files and in main.tf for webserver where the terraform remote state file is accessed.

### II | Deploying Infrastructure 

  To Deploy the infrastructure in the environments we shall use the terraform commands.
  Firstly, we set the alias by ``` alias tf=terraform ```.
  
  Then navigate to the environment based on the configuration you would want to deploy.
  For example, Consider deployment of architecture in dev. We navigate to the environments/dev, then we deploy networking first and then the webserver.
  
  Follow the commands below to deploy the infrastructure in dev folder. The commands need to be followed assuming that the working directory is ACS-Final-Project. 
  
  ```
    cd environments/dev/networking
    tf init
    tf fmt
    tf validate
    tf plan
    tf apply --auto-approve
    
    # After the deployment of networking infrastructure
    
    cd ../webserver
    tf init
    tf fmt
    tf validate
    tf plan
    tf apply --auto-approve
  ```
  
  Once the infrastructure is deployed, get the load balancer dns to access the webpage via a browser.
  
 Due to a violation of tfsec, the DNS name of the load balancer is not displayed as output after deployment. However, if you still want to access the DNS name, you can include the provided code block in the output.tf file of the aws_webserver module, and then access it from the output.tf file in the webserver folder of each individual environment.
  
  ```
    output "load_balancer_dns_name" {
      value = aws_lb.loadBalancer.dns_name
    }
  ```

  
  ***Delete the Infrastructure***
  
  Deletion of resources should be done in an order to ensure proper deletion. The webserver components must be deleted before deleting the networking part.
  This is important because if we attempt deletion of networking before webserver, few components will not be deleted and will time out given that the webserver components are still using the network components.
  Follow the steps below to destroy the Infrastructure (The example is for dev environment),
  
  ```
    cd environments/dev/webserver
    tf destroy --auto-approve
    
    # After the deletion of webserver infrastructure
    
    cd ../networking
    tf destroy --auto-approve
  ```


**TEAM : KENNITH NOAH EDISON BERNARD, NAMITHA BEJOY, CHANCHAL ALPHONSA RAJU**

**PROFESSOR :LEO LU**


