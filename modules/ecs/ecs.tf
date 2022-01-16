
resource "aws_ecs_cluster" "main" {
  name = var.name
}

resource "aws_ecs_service" "test"{
    name = var.name
    cluster = aws_ecs_cluster.main.arn
    launch_type = "FARGATE"

    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 0
    desired_count = var.inst_number
    
    task_definition = aws_ecs_task_definition.main.arn

    network_configuration {
        assign_public_ip = true
        security_groups = [var.ecs_sg_id]
        subnets =var.subnets

      
    }
    load_balancer {
      target_group_arn = var.ecs_tg
      container_name ="first"
      container_port ="80"
    }

}

resource "aws_ecs_task_definition" "main" {
 
 
 
     family = var.name
     network_mode             = "awsvpc"
     requires_compatibilities = ["FARGATE"]
     execution_role_arn = aws_iam_role.role_for_ecs_tasks.arn
   #  task_role_arn   = aws_iam_role.role_for_ecs_tasks.arn
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
          containerPort = 80
          hostPort      = 80
        }
      ]
      }])


  depends_on=[aws_iam_policy_attachment.attach_for_ecs ] 
 }