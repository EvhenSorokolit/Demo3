output "url" {
    value ="${var.reg_id}.dkr.ecr.${var.region}.amazonaws.com/${var.name}:${var.tag}"
}