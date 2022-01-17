resource "null_resource" "build" {
#creatin triger  start null resouce
  triggers = {
    values = var.tag
  }
#  simple bash script to  push image to ECR 
  provisioner "local-exec" {
    command = "./build.sh  >last_build.log"
    working_dir = var.working_dir
  
    environment = {
        tag = var.tag
        reg_id = var.reg_id            
    
     }
}
}