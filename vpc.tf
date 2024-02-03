resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true  

  tags = merge(var.comman_tags,{
    "Name" = "Peter_VPC"
  })

}

resource "aws_subnet" "publicsubnets" {

  count = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr,count.index)
  availability_zone = data.aws_availability_zones.availabilityzone.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.comman_tags,{
    "Name" = "Public-Subnet-${count.index +1 }"
  })
  
}


resource "aws_subnet" "privatesubnets" {

  count = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr,count.index)
  availability_zone = data.aws_availability_zones.availabilityzone.names[count.index]
  

  tags = merge(var.comman_tags,{
    "Name" = "Private-Subnet-${count.index + 1}"
  })
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.comman_tags,{
    "Name" = "Public-IGW"
  })
  
}

resource "aws_route_table" "publicrt" {
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
    tags = merge(var.comman_tags,{
    "Name" = "Public-RT"
  })
  
}
resource "aws_route_table_association" "publicrtassociation" {
    count = length(var.public_subnet_cidr)
    subnet_id = element(aws_subnet.publicsubnets[*].id,count.index)
    route_table_id = aws_route_table.publicrt.id
  
}

resource "aws_eip" "elasticip" {
  count = length(var.public_subnet_cidr)
  
  domain = "vpc"

  tags = merge(var.comman_tags,{
    "Name" = "Elastic-IP-${count.index + 1}"
  })

  
}

resource "aws_nat_gateway" "natgatway" {
  count = length(var.public_subnet_cidr)
  allocation_id = element(aws_eip.elasticip[*].id,count.index)
  subnet_id = element(aws_subnet.publicsubnets[*].id,count.index)

   tags = merge(var.comman_tags,{
    "Name" = "Nat-Gateway-${count.index + 1}"
  })

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "privatert" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.natgatway[*].id,count.index)
    }
    tags = merge(var.comman_tags,{
    "Name" = "Private-RT"
  })
  
}

resource "aws_route_table_association" "privatertassociation" {
    count = length(var.private_subnet_cidr)
    subnet_id = element(aws_subnet.privatesubnets[*].id,count.index)
    route_table_id = element(aws_route_table.privatert[*].id,count.index)
  
}
