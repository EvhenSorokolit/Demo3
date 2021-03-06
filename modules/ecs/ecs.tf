
#create claster
resource "aws_ecs_cluster" "main" {
  name = var.name
}

resource "aws_ecs_service" "test"{
    name = var.name
    cluster = aws_ecs_cluster.main.arn
    launch_type = "FARGATE"

# rules to destroy  inactive tasks
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 0
# number of task to start and hold
    desired_count = var.inst_number
    
    task_definition = aws_ecs_task_definition.main.arn

    network_configuration {
        assign_public_ip = true
        security_groups = [var.ecs_sg_id]
        subnets =var.subnets
     
    }
#connectiing tasks to  load balancer target group
    load_balancer {
      target_group_arn = var.ecs_tg
      container_name ="first"
      container_port =var.port
    }

}

#createing task definition
resource "aws_ecs_task_definition" "main" {
 
 
 
     family = var.name
     network_mode             = "awsvpc"
     requires_compatibilities = ["FARGATE"]
#execution role for tasks to get acces to ECR and Cloudwatch       
     execution_role_arn = aws_iam_role.role_for_ecs_tasks.arn
  
     cpu         = 256
     memory      = 512

      container_definitions = jsonencode([{
   name        = "first"
   image       = var.image
   essential   = true
   cpu         = 256
   memory      = 512

   logConfiguration =  {
       logDriver = "awslogs"
       options ={
           awslogs-group = "/ecs/${var.name}"
           awslogs-region = var.region
           awslogs-stream-prefix ="ecs"
       }
   }
   
   
   portMappings = [
        {
          containerPort = "${tonumber(var.port)}",
          hostPort      = "${tonumber(var.port)}"
        }
      ]
      }])

#run after role creation iam role and log group creation
  depends_on=[aws_iam_policy_attachment.attach_for_ecs, aws_cloudwatch_log_group.cb_log_group ] 
 }