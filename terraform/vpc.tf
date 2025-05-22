#VPC
resource "aws_vpc" "vpc" {
  cidr_block = "25.1.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames = true

  tags = {
    Name = "techno-ibrahim"
  }
}

# PUBLIC AREA
# SUBNET
resource "aws_subnet" "sb-public-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "25.1.0.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 1)
  
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-public-subnet-1a"
  }
}

resource "aws_subnet" "sb-public-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "25.1.2.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 2)
  
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-public-subnet-1b"
  }
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "techno-igw"
  }
}

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "techno-eigw"
  }
}


#RTB PUBLIC
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name = "techno-rtb-public"
  }
}

resource "aws_route_table_association" "public-sb-1a-assc" {
  subnet_id = aws_subnet.sb-public-1a.id
  route_table_id = aws_route_table.rtb-public.id
}

resource "aws_route_table_association" "public-sb-1b-assc" {
  subnet_id = aws_subnet.sb-public-1b.id
  route_table_id = aws_route_table.rtb-public.id
}

# PRIVATE AREA

resource "aws_subnet" "sb-priate-1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "25.1.1.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 3)
  
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-priate-subnet-1a"
  }
}

resource "aws_subnet" "sb-priate-1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "25.1.3.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 4)
  
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "techno-priate-subnet-1b"
  }
}

#EIP NAT
resource "aws_eip" "eip-nat" {
  domain           = "vpc"
  tags = {
    Name = "techno-eip-nat"
  }
}

#NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.sb-public-1a.id

  tags = {
    Name = "techno-nat"
  }
}

#RTB PRIVATE
resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name = "techno-rtb-private"
  }
}

#SUBNET ASSOCIATE

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.sb-priate-1a.id
  route_table_id = aws_route_table.rtb-private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.sb-priate-1b.id
  route_table_id = aws_route_table.rtb-private.id
}