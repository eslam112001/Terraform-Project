resource "aws_vpc" "my_vpc" {
  cidr_block = "172.20.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "us-east-1a"       
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "my_public_subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = "us-east-1b"     
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "terraform-internet-gateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }

  tags = {
    Name = "terraform-route-table"
  }
}

resource "aws_route_table_association" "my_subnet_assoc_a" {
  subnet_id      = aws_subnet.my_public_subnet_a.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_subnet_assoc_b" {
  subnet_id      = aws_subnet.my_public_subnet_b.id
  route_table_id = aws_route_table.my_route_table.id
}
