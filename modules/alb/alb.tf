# Crating  load balancer

resource "aws_lb" "my_lb" {
  name               = "${var.name}-Lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            =  var.subnetes
  
  enable_deletion_protection = false
  
}

# Crating  Target group
resource "aws_lb_target_group" "my_tg" {
  name     = "${var.name}-Tg"
  port     = var.port
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id
    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    port                = var.port
    path                = "/"
    protocol            = "HTTP"
    interval            = 6
    matcher             = "200-399"
  }
}

# Crating Load balancer Listener
resource "aws_lb_listener" "my_lb_listener" {
    load_balancer_arn = aws_lb.my_lb.arn
    port = var.port
    protocol = "HTTP"
    default_action {
      type ="forward"
      target_group_arn = aws_lb_target_group.my_tg.arn
    }
  
}














