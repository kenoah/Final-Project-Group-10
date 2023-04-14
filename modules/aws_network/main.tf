provider "aws" {
  region = var.region
}

# List of all available availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "env" = var.env }
  )
  name_prefix = "${var.acs_group}-${var.env}"
}

# VPC in which our architecture will be deployed
resource "aws_vpc" "mainVPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  
  tags = merge(
    var.default_tags, {
      Name = "${local.name_prefix}-VPC"
    }
  )
}

# Public subnets
resource "aws_subnet" "publicSubnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.mainVPC.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-Public-Subnet-${count.index}"
    }
  )
}

# Private subnets
resource "aws_subnet" "privateSubnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.mainVPC.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-Private-Subnet-${count.index}"
    }
  )
}

# Internet gateway
resource "aws_internet_gateway" "internetGateway" {
  vpc_id = aws_vpc.mainVPC.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-IGW"
    }
  )
}

# Elastic IP
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internetGateway]
  
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-EIP"
    }
  )
}

# Nat Gateway for private subnets
resource "aws_nat_gateway" "natGateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicSubnet[1].id
  depends_on    = [aws_internet_gateway.internetGateway]
  
  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Nat-GW"
    }
  )
}

# Route table for private subnets
resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.mainVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natGateway.id
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Private-Route-Table"
    }
  )
}

# Route table for public subnets
resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.mainVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetGateway.id
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Public-Route-Table"
    }
  )
}

# Assosciating public subnets with the public route table
resource "aws_route_table_association" "publicRouteTableAssociation" {
  count          = length(aws_subnet.publicSubnet[*].id)
  route_table_id = aws_route_table.publicRouteTable.id
  subnet_id      = aws_subnet.publicSubnet.*.id[count.index]
}

# Assosciating private subnets with the private route table
resource "aws_route_table_association" "privateRouteTableAssociation" {
  count          = length(aws_subnet.privateSubnet[*].id)
  route_table_id = aws_route_table.privateRouteTable.id
  subnet_id      = aws_subnet.privateSubnet.*.id[count.index]
}