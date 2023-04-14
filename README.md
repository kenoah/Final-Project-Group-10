## ACS730 NAA 
# Final Project: Two-Tier Web Application Automation with Terraform 
## Group 10

### Overview

- The objective of this project is to demonstrate a two-tier web application automation using Terraform.
- We build an infrastructure architecture on AWS inorder to host our website in all the instances across multiple environments with varied configurations.
- We further work with launch template, auto-scaling groups and policies, load balancer and AWS identity and access management. 
- This project implementation also demonstrates the usage of modules and github actions. 

### Learnings
- This project sheds an insight onto effective practices to deploy infrastructure using Infrastucture as code tool "Terraform" using various infrastructure constructs like auto-scaling groups, load balancer, bastion usage, auto-scaling policies, usage of cloud watch metrics.
- Further, usage of terraform constructs like modules and following best practices to deploy infrastructure provided an insight into the industry practices.

### The‌ ‌Roadmap‌ ‌is‌ ‌divided‌ ‌into‌ ‌2‌ ‌Sections‌ ‌

### I | Navigating through the code base and setting up the Prerequisites
#### 1 | Clone the repository and Explore the branches

  ``` 
  git clone git@github.com:kenoah/Final-Project-Group-10.git
  ```
  
  ***Note:*** The clone command is SSH based, so ensure that SSH key is added in your environment.
  
  - Once the local repository is setup, navigate to the branch you want to work on (dev is preferred) using 
                ``` git checkout <branch-name> ```
  
  - The repository has 3 main branches dev, staging and prod. prod is the main branch of the repo.
  The development changes need to be done in the dev branch and the working code shall be pulled onto staging and prod branches.

#### 2 | Understanding the Code Base Structure
    
    The code base has the following structure,
      1. environments
        - dev
          -- networking
          -- webserver
        - prod
          -- networking
          -- webserver
        - staging
          -- networking
          -- webserver
      2. images
      3. modules
        - aws_network
        - aws_webserver
        
  - The environments folder is the root folder that contains the configuration for each of the prod, dev and staging environments. It has networking and webserver subfolders that is dependent on the aws_network and aws_webserver modules present in the modules folder.
  - The networking part specifies the configuration with respect to the network of the architecture which includes the VPC, subnets and the network gateways.
  - The webserver folder has the configuration related to the load balancer, server template, auto scaling group, user data and the security groups.
  - Finally, the images folder has the images that need to be uploaded to the S3 bucket which will be accessed by the webservers to render the webpage.

#### 3 | Generating SSH Keys
  In all the webserver folders of the environments root folder, SSH keys need to be generated which shall be used for deploying infrastructure.
  The naming convention to be followed is "Group13"-<environment-name>, for example "Group13-Dev".
  
  To generate SSH key use the command below,
  ```
  ssh-keygen -t rsa -f Group10-Dev
  ```

#### 3 | Deploying S3 bucket
  On the AWS management console create S3 buckets for each environment. These buckets will store the tfstate for its corresponding environments and also the images to be displayed on the webpage.
  The naming of the s3 buckets should be as follows:
    - dev-s3-acsgroup13
    - staging-s3-acsgroup13
    - prod-s3-acsgroup13
  
  Each of the buckets should have the images folder in the git uploaded to it.
  
  ***Note:*** If there is a bucket already existing with the names given above choose and other name and do the necessary changes in config.tf files and in main.tf for webserver where the terraform remote state file is accessed.

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
  
  The dns name of the load balancer is not output after the deployment as it violates tfsec. 
  If you would still like to output the dns name use the code block below in the aws_webserver module's output.tf and access the same from the output.tf in the webserver folder of the individual environments.
  
  ```
    output "load_balancer_dns_name" {
      value = aws_lb.loadBalancer.dns_name
    }
  ```
  
  ***Access the private webserver via Bastion***
  
  The admins can access the private web servers via SSH only through the Bastion Server. To do the same, connect to Bastion server via SSH using it's public ip and ssh-key associated with it through the command below.
  ``` ssh -i <private-ssh-key> ec2-user@<bastion-public-IP> ```
  
  Further, inside the Bastion server, get the SSH Key associated with the private webserver and use the below command to access the machine.
  ``` ssh -i <private-ssh-key> ec2-user@<webserver-private-IP> ```
  
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

**PROFESSOR : PROF. LEO LU**


