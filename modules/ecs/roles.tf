#create role for ecs-tasks
resource "aws_iam_role" "role_for_ecs_tasks" {
  name               = "${var.name}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}
# create policy to access  ECR and logs
resource "aws_iam_policy" "policy_for_ecs" {
  name = "${var.name}-ecr-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# attaching policy to role
resource "aws_iam_policy_attachment" "attach_for_ecs" {
  name       = "${var.name}-attach"
  roles      = [aws_iam_role.role_for_ecs_tasks.name]
  policy_arn = aws_iam_policy.policy_for_ecs.arn
}








