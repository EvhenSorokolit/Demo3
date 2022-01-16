output "LB_url"{
 
    value = aws_lb.my_lb.dns_name
}

output "LB_TG_id"{
 
    value = aws_lb_target_group.my_tg.id
}

