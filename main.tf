locals {

  app_name = "MyTestApp"
  app_ports= ["80"]
  working_dir = ".//app"
  aws_account = "353641719040"
  aws_region = "eu-central-1"
  image_tag = "0.0.1"
  count_avzones_instances = 2
 
}


provider "aws" { 
    region = local.aws_region
}
module "ecr" {
    source = "./modules//ecr"
    repository_name = lower(local.app_name)
}
module "InitBuild" {
    source = "./modules//init-build"
    name = lower(local.app_name)
    tag = local.image_tag
    region=local.aws_region
    reg_id = local.aws_account
    working_dir =local.working_dir

    depends_on = [module.ecr]
    
}

module "vpc" {
    source = "./modules//vpc"
    region = local.aws_region
    Sub_count = local.count_avzones_instances
    name = local.app_name
}
module "SG" {
    source = "./modules//SG"
    vpc_id = module.vpc.vpc_id
    allow_ports = local.app_ports
    name = local.app_name
}

module "ALB" {
    source = "./modules//alb"
    vpc_id = module.vpc.vpc_id
    subnetes = module.vpc.public_ips
    lb_sg_id= module.SG.sg_id
    name = local.app_name
    depends_on = [module.vpc]
}
module "ECS" {
    source = "./modules//ecs"
    region = local.aws_region
    subnets = module.vpc.private_ips
    ecs_sg_id= module.SG.sg_id
    ecs_tg = module.ALB.LB_TG_id
    name = local.app_name 
    image = module.InitBuild.url 
    inst_number = local.count_avzones_instances
    
    depends_on = [module.ALB,module.InitBuild]  
}
