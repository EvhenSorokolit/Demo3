
# variables to start  infrastucture
locals {

  app_name = "MyTestApp"
  sg_ports= ["80"]
  app_port= "80"
  working_dir = ".//app"
  aws_region = "eu-central-1"
  image_tag = "3.7"
  count_avzones_instances = 2
  
}



provider "aws" { 
    region = local.aws_region
}

#firs step  create  repository for Docker images

module "ecr" {
    source = "./modules//ecr"
    repository_name = lower(local.app_name)
}
# second step send registry id to build init to build and pull image 
module "InitBuild" {
    source = "./modules//init-build"
    tag = local.image_tag
    reg_id = module.ecr.ecr_repository_url
    working_dir =local.working_dir

    depends_on = [module.ecr]
    
}
#create network infrostucture

module "vpc" {
    source = "./modules//vpc"
    region = local.aws_region
    Sub_count = local.count_avzones_instances
    name = local.app_name
}

#create security group
module "SG" {
    source = "./modules//SG"
    vpc_id = module.vpc.vpc_id
    allow_ports = local.sg_ports
    name = local.app_name
    depends_on = [module.vpc]
      
    
}

#create Load Balancer . Depends  on network and Security group
module "ALB" {
    source = "./modules//alb"
    vpc_id = module.vpc.vpc_id
    subnetes = module.vpc.public_ips
    lb_sg_id= module.SG.sg_id
    name = local.app_name
    port = local.app_port
    depends_on = [module.vpc,module.SG]
}

#create Claster using FARGATE.  Depends  on load balancer and  Init build modules
module "ECS" {
    source = "./modules//ecs"
    region = local.aws_region
    subnets = module.vpc.private_ips
    ecs_sg_id= module.SG.sg_id
    ecs_tg = module.ALB.LB_TG_id
    name = local.app_name 
    image = module.InitBuild.url 
    inst_number = local.count_avzones_instances
    port = local.app_port
    
    depends_on = [module.ALB,module.InitBuild]  
}


