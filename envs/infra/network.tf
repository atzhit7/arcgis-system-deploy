## vpc creation
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

### automaticall creation multi subnets
## 10.10.0.0/18 10.10.64.0/18 10.10.128.0/18 10.10.192.0/18
## 10.10.0.0/19 10.10.32.0/19
## 10.10.64.0/19 10.10.96.0/19
## 10.10.128.0/19 10.10.160.0/19
## 10.10.192.0/19 10.10.224.0/19
## /18 we can use in security group
## public subnet
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index % 2]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-manage-subnet-${count.index}"
  }
}

# private subnet
### TO SEPARATE subnets for roles
resource "aws_subnet" "private_web" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index + length(aws_subnet.public))
  availability_zone       = data.aws_availability_zones.az.names[count.index % 2]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-arcgis-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_data" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index + length(aws_subnet.public) + length(aws_subnet.private_web))
  availability_zone       = data.aws_availability_zones.az.names[count.index % 2]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-arcgis-subnet-${count.index}"
  }
}

# create automatically
# resource "aws_subnet" "private" {
#   count                   = 4
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index + length(aws_subnet.public))
#   availability_zone       = data.aws_availability_zones.az.names[count.index % 2]
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "${var.name}-arcgis-subnet-${count.index}"
#   }
# }

## routing creation
## internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-internetgateway"
  }
}

## NAT gateway for each public subnets
resource "aws_eip" "this" {
  count = 2
  vpc   = true
}

resource "aws_nat_gateway" "this" {
  count         = 2
  allocation_id = element(aws_eip.this[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  depends_on = [
    aws_subnet.public
  ]

  tags = {
    Name = "${var.name}-ngw-${count.index}"
  }
}

## route table for public and internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-public-routetable"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}


## route table for private_web and nat gateway
resource "aws_route_table" "private_web" {
  count  = 2
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.this[*].id, count.index)
  }

  tags = {
    Name = "${var.name}-arcgis-routetable-${count.index}"
  }
}

resource "aws_route_table_association" "private_web" {
  count          = 2
  subnet_id      = element(aws_subnet.private_web[*].id, count.index)
  route_table_id = element(aws_route_table.private_web[*].id, count.index)
}

## route table for private_data and nat gateway
resource "aws_route_table" "private_data" {
  count  = 2
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.this[*].id, count.index)
  }

  tags = {
    Name = "${var.name}-private_data-routetable-${count.index}"
  }
}

resource "aws_route_table_association" "private_data" {
  count          = 2
  subnet_id      = element(aws_subnet.private_data[*].id, count.index)
  route_table_id = element(aws_route_table.private_data[*].id, count.index)
}

# network acl
# resource "aws_network_acl" "private_web" {
#   vpc_id     = aws_vpc.this.id
#   subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private_web[*].id)

#   ingress = [
#     {
#       protocol        = "tcp"
#       rule_no         = 100
#       action          = "allow"
#       cidr_block      = "0.0.0.0/0"
#       from_port       = 80
#       to_port         = 80
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     }
#   ]

#   egress = [
#     {
#       protocol        = "tcp"
#       rule_no         = 200
#       action          = "allow"
#       cidr_block      = "0.0.0.0/0"
#       from_port       = 443
#       to_port         = 443
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     },
#     ## for session manager
#     {
#       rule_no         = 300
#       action          = "allow"
#       from_port       = 0
#       to_port         = 0
#       protocol        = "-1"
#       cidr_block      = "0.0.0.0/0"
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     }
#   ]
# }

# resource "aws_network_acl" "private_data" {
#   vpc_id     = aws_vpc.this.id
#   subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private_data[*].id)

#   ingress = [
#     {
#       protocol        = "tcp"
#       rule_no         = 100
#       action          = "allow"
#       cidr_block      = "0.0.0.0/0"
#       from_port       = 80
#       to_port         = 80
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     }
#   ]

#   egress = [
#     {
#       protocol        = "tcp"
#       rule_no         = 200
#       action          = "allow"
#       cidr_block      = "0.0.0.0/0"
#       from_port       = 443
#       to_port         = 443
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     },
#     ## for session manager
#     {
#       rule_no         = 300
#       action          = "allow"
#       from_port       = 0
#       to_port         = 0
#       protocol        = "-1"
#       cidr_block      = "0.0.0.0/0"
#       icmp_code       = 0
#       icmp_type       = 0
#       ipv6_cidr_block = ""
#     }
#   ]
# }