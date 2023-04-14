#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo aws s3 cp s3://${lower(env)}-s3-acsgroup10/images/aws.jpeg /var/www/html
sudo aws s3 cp s3://${lower(env)}-s3-acsgroup10/images/seneca.jpeg /var/www/html
sudo aws s3 cp s3://${lower(env)}-s3-acsgroup10/images/toronto.jpeg /var/www/html
sudo aws s3 cp s3://${lower(env)}-s3-acsgroup10/images/thankyou.jpeg /var/www/html
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
sudo systemctl start httpd
sudo systemctl enable httpd
echo "
<html>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
<section class="team text-center py-5">
   <div class="container">
     <div class="header my-5">
       <h1>Hello! This is Group10 </h1>
       <h3>Welcome to our Web Page! The private IP is $myip! The environment is ${env}</h3>
       <p class="text-muted">Group 10</p>
     </div>
     <div class="row">
       <div class="col-md-6 col-lg-3">
         <div class="img-block mb-5">
           <img src="aws.jpeg" class="img-fluid  img-thumbnail rounded-circle" alt="image1">
           <div class="content mt-2">
           </div>
         </div>
       </div>
       <div class="col-md-6 col-lg-3 ">
         <div class="img-block mb-5">
           <div class="content mt-2">
             <h4>Team Members</h4>
             <ul>
              <li>Kennith Noah Edison Bernard</li>
              <li>Namitha Bejoy</li>
              <li>Chanchal Alphonsa Bejoy</li>
             </ul>
           </div>
         </div>
       </div>
       <div class="col-md-6 col-lg-3">
         <div class="img-block mb-5">
           <img src="seneca.jpeg" class="img-fluid  img-thumbnail rounded-circle" alt="image1">
           <div class="content mt-2">
           </div>
         </div>
       </div>
       <div class="col-md-6 col-lg-3">
         <div class="img-block mb-5">
           <img src="thankyou.jpeg" class="img-fluid  img-thumbnail rounded-circle" alt="image1">
           <div class="content mt-2">
             <h4>Thank You</h4>
           </div>
         </div>
       </div>
     </div>
   </div>
 </section>
 </body>
 </html>
 
 "  >  /var/www/html/index.html