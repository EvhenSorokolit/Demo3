resource "aws_cloudwatch_log_group" "cb_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = 30

  tags = {
    Name = "cb-log-group"
  }
}