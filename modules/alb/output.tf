output "LB_url"{
    description = "Load balancer url"
 
    value = aws_lb.my_lb.dns_name
}

output "LB_TG_id"{
 
    description = "returns  Taget group id"
    value = aws_lb_target_group.my_tg.id
}

