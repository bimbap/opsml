# [SG LB]

resource "aws_security_group" "lb-sg" {
  name        = "techno-sg-lb"
  description = "allow http & https for load balancer"
  vpc_id      = aws_vpc.vpc.id


#   ingress {
#     description = "HTTP IPV4"
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

#   ingress {
#     description = "HTTPS IPV4"
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = [aws_vpc.vpc.cidr_block]
#   }

  ingress {
    description = "HTTP IPV4 ALL ACCESS"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS IPV6 ALL ACCESS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

 # EGRESS / OUTBOUND

  egress {
    description = "ALL TRAFFIC IPV4"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL TRAFFIC"
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "techno-sg-lb"
  }
}

resource "aws_security_group" "apps-sg" {
  name        = "techno-sg-apps"
  description = "allow custom port 2000 for apps"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "APPS IPV4 ALL ACCESS"
    from_port = 2000
    to_port = 2000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "APPS IPV6 ALL ACCESS"
    from_port = 2000
    to_port = 2000
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

 # EGRESS / OUTBOUND

  egress {
    description = "ALL TRAFFIC IPV4"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL TRAFFIC"
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "techno-sg-apps"
  }
}