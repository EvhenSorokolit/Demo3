
#~~~~~~~~~output~~~~~~~~~~~~~~~

output "vpc_id"{
 
    value = aws_vpc.main.id
}
output "public_ips"{
 
    value = aws_subnet.public.*.id
}
output "private_ips"{
 
    value = aws_subnet.private.*.id
}
