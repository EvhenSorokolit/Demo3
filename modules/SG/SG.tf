resource "aws_security_group" "My_SG" {
  name        = "${var.name}_Sg"
  vpc_id      = var.vpc_id



  dynamic "ingress"{
    for_each =var.allow_ports
    content{
      
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }
     }
      egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
 
  
}