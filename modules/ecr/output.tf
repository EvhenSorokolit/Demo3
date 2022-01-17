output "ecr_repository_url" {
  description = "Returns  url of created repository"
  value = aws_ecr_repository.ecr_repository.repository_url
}