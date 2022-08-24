## ALB security group
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  vpc_id      = aws_vpc.this.id
  description = "${var.name}-alb"

  tags = {
    Name = "${var.name}-alb-sg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# public subnet security group including nat
resource "aws_security_group" "public" {
  name        = "${var.name}-public"
  vpc_id      = aws_vpc.this.id
  description = "${var.name}-public-SG"
  tags = {
    Name = "${var.name}-public-sg"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## private subnet security group
resource "aws_security_group" "private_web" {
  name        = "${var.name}-private_web"
  vpc_id      = aws_vpc.this.id
  description = "${var.name}-private_web-SG"
  tags = {
    Name = "${var.name}-private_web-sg"
  }

  # from public subnet, from private web, from private data
  ingress {
    description = "arcgis server connection"
    from_port   = 6080
    to_port     = 6080
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 0),
      cidrsubnet(var.vpc_cidr, 3, 1),
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 0), cidrsubnet(var.vpc_cidr, 2, 2)]
  }

  ingress {
    description = "arcgis server connection https"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 0),
      cidrsubnet(var.vpc_cidr, 3, 1),
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 0), cidrsubnet(var.vpc_cidr, 2, 2)]
  }

  ingress {
    description = "arcgis shared directory for backup"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 0), cidrsubnet(var.vpc_cidr, 2, 2)]
  }

  # from public subnet, private web
  ingress {
    description = "arcgis portal connection"
    from_port   = 7080
    to_port     = 7080
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 0),
      cidrsubnet(var.vpc_cidr, 3, 1),
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 3, 1), cidrsubnet(var.vpc_cidr, 3, 2)]
  }

  ingress {
    description = "arcgis portal connection https"
    from_port   = 7443
    to_port     = 7443
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 0),
      cidrsubnet(var.vpc_cidr, 3, 1),
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 3, 1), cidrsubnet(var.vpc_cidr, 3, 2)]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_data" {
  name        = "${var.name}-private_data"
  vpc_id      = aws_vpc.this.id
  description = "${var.name}-private_data-SG"
  tags = {
    Name = "${var.name}-private-sg"
  }

  # form private web subnet
  ingress {
    description = "arcgis data web connect"
    from_port   = 2443
    to_port     = 2443
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 1)]
  }

  ingress {
    description = "arcgis data store postgresql port"
    from_port   = 9876
    to_port     = 9876
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 1)]
  }

  ingress {
    description = "arcgis data store couchdb port"
    from_port   = 29080
    to_port     = 29081
    protocol    = "tcp"
    cidr_blocks = [
      cidrsubnet(var.vpc_cidr, 3, 2),
      cidrsubnet(var.vpc_cidr, 3, 3),
      cidrsubnet(var.vpc_cidr, 3, 4),
      cidrsubnet(var.vpc_cidr, 3, 5)
    ]
    # cidr_blocks = [cidrsubnet(var.vpc_cidr, 2, 1)]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
