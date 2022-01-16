variable "name" {
    description = " Enter name"
    
}

variable "vpc_id" {
  description = "Enter VPC id"
}

variable "allow_ports"{
    description = "list of open ports"
    type = list
   # default = ["80","22"]
}