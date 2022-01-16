


#~~~~~~~~~~~~~~~~ get Av.Zones~~~~~~~~~~~~
data "aws_availability_zones" "available"{}
#~~~~~~~~~~~~~~~~ vpc~~~~~~~~~~~
resource "aws_vpc" "main" {
    cidr_block = var.VPC_Sidr_block
    tags = merge(var.common_tags, {Name ="${var.name} Main VPS"})
    
}
#~~~~~~~~~~~~~~~~Public_Subnete~~~~~~~~~~~
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    count = var.Sub_count
    availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block =cidrsubnet(aws_vpc.main.cidr_block, 8, var.Sub_count + count.index)
    map_public_ip_on_launch = true
    tags = merge(var.common_tags, {Name ="Public_Subnet_for_${data.aws_availability_zones.available.names[count.index]}"})
    
}

#~~~~~~~~~~~~~~~~ IGW~~~~~~~~~~~
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    
    tags = merge(var.common_tags, {Name ="Main IGW"})
    
}
#~~~~~~~~~~~~~~~Route Table for public sudbnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {    
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    }
        
    tags = merge(var.common_tags, {Name ="Public RT"})
    
}
#~~~~~~~~~~~~~~~~~~~~~~~association publci subnet and  pubclic RT
resource "aws_route_table_association" "public"{
    count=var.Sub_count
    subnet_id =aws_subnet.public[count.index].id 
    route_table_id = aws_route_table.public.id

}



#~~~~~~~~~~~~~~~~ Private_Subnete~~~~~~~~~~~
resource "aws_subnet" "private" {
    count = var.Sub_count
    vpc_id = aws_vpc.main.id
     availability_zone = data.aws_availability_zones.available.names[count.index]
    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    tags = merge(var.common_tags, {Name ="Private_Subnet_for_${data.aws_availability_zones.available.names[count.index]}"})
    map_public_ip_on_launch = true  
}

#~~~~~~~~~~~~~~~~Main NAT GW for VPC~~~~~~~~~~~~~~~~~
resource "aws_nat_gateway" "nat" {
    count =var.Sub_count
    allocation_id = element(aws_eip.nat_eip.*.id,count.index)
    subnet_id = element(aws_subnet.public.*.id,count.index)
    
        
    tags = merge(var.common_tags, {Name ="Nat GW EIP"})
    
}




#~~~~~~~~~~~~~~~~Elastic ip for NAT GW~~~~~~~~~~~~~~~~~
resource "aws_eip" "nat_eip" {
    count =var.Sub_count
    vpc = true
    depends_on = [
      aws_internet_gateway.igw
    ]
      
    tags = merge(var.common_tags, {Name ="Nat GW EIP"})
    
}

#~~~~~~~~~~~~Route Table for private sudbnet
resource "aws_route_table" "private" {
    count=var.Sub_count
    vpc_id = aws_vpc.main.id
    route {   
    cidr_block ="0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat.*.id,count.index)
    }
        
    tags = merge(var.common_tags, {Name ="Private RT"})
    
}
#~~~~~~~~~~~~~~~~~~~~~~~association private subnet and  pubclic RT
resource "aws_route_table_association" "private"{
     count=var.Sub_count
    subnet_id =element(aws_subnet.private.*.id,count.index)
    route_table_id = element(aws_route_table.private.*.id,count.index)

}

