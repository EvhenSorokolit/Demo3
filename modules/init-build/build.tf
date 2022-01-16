resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "./build.sh  >last_build.log"
    working_dir = var.working_dir
  
    environment = {
        tag = var.tag
        reg_id = var.reg_id
        region = var.region
        app_name = var.name
        #APP_NAME = var.app_name
        #ENV_NAME = var.environment
    }
    
  }
}