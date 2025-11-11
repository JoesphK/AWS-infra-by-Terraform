resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true          # Enables DNS resolution within the VPC
  enable_dns_hostnames = true          # Enables public DNS hostnames for instances. Needed to connect using DNS

  tags = {
    Name = "JoeSKTask-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "JoeSKTask-IGW" }
}

# -----------------------
# Public Subnets
# -----------------------
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = {
    Name = "JoeSKTask-Public-Subnet-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "JoeSKTask-Public-RT" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# -----------------------
# NAT Gateway
# -----------------------

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "JoeSKTask-NAT-EIP" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id # Put NAT in the first public subnet
  depends_on    = [aws_internet_gateway.igw]
  tags          = { Name = "JoeSKTask-NAT-Gateway" }
}

# -----------------------
# Private Subnets
# -----------------------
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

  tags = {
    Name = "JoeSKTask-Private-Subnet-${each.key}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "JoeSKTask-Private-RT" }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
