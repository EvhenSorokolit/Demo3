
variable "region" {
    description = " Enter region"
    
}


variable "Sub_count"{
    description = "count of subnets and av.zones"    
   
}


variable "VPC_Sidr_block"{
    description = "enter cidr block"
    type = string
    default = "10.0.0.0/16"
}
variable "common_tags" {
    description = "common tags to all resoutces"
    type = map
    default = {
         Owner = "Evhen Sorokolit"
         
        
    }
}
variable "name" {
    description = " Enter name"
    
}
