variable "name" {
    description = " Enter name"
    
}

variable "region" {
    description = " Enter region"
    
}

variable "ecs_sg_id" {
    description = " Enter SG ID"
    
}

variable "subnets" {
    description = " Enter subnets IDs"
    
}



variable "ecs_tg" {
  description = "Enter VPC id"
}

variable "image" {
    description = "Enter path to image"

  
}

variable "inst_number" {
    description = "enter number of tasks"

  
}

variable "port" {
    description = "Enter port of image"

  
}



