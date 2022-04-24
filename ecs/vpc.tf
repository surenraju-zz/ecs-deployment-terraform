
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project}-${var.environment}-public-subnet-1"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.project}-${var.environment}-public-subnet-2"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "public-subnet-3" {
  cidr_block        = var.public_subnet_3_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project}-${var.environment}-public-subnet-3"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project}-${var.environment}-private-subnet-1"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.project}-${var.environment}-private-subnet-2"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_subnet" "private-subnet-3" {
  cidr_block        = var.private_subnet_3_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project}-${var.environment}-private-subnet-3"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-${var.environment}-public-route-table"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route_table" "private-route-table-1" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-${var.environment}-private-route-table-1"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route_table" "private-route-table-2" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-${var.environment}-private-route-table-2"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route_table" "private-route-table-3" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-${var.environment}-private-route-table-3"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "public-route-3-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}

resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table-1.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table-2.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_route_table_association" "private-route-3-association" {
  route_table_id = aws_route_table.private-route-table-3.id
  subnet_id      = aws_subnet.private-subnet-3.id
}

resource "aws_eip" "elastic-ip-for-nat-gw-1" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name        = "${var.project}-${var.environment}-eip-ngw-1"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_internet_gateway.internet-gw]
}

resource "aws_eip" "elastic-ip-for-nat-gw-2" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.6"

  tags = {
    Name        = "${var.project}-${var.environment}-eip-ngw-2"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_internet_gateway.internet-gw]
}

resource "aws_eip" "elastic-ip-for-nat-gw-3" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.7"

  tags = {
    Name        = "${var.project}-${var.environment}-eip-ngw-3"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_internet_gateway.internet-gw]
}

resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name        = "${var.project}-${var.environment}-ngw-1"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw-1, aws_internet_gateway.internet-gw]
}

resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  tags = {
    Name        = "${var.project}-${var.environment}-ngw-2"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw-2, aws_internet_gateway.internet-gw]
}

resource "aws_nat_gateway" "nat-gw-3" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw-3.id
  subnet_id     = aws_subnet.public-subnet-3.id

  tags = {
    Name        = "${var.project}-${var.environment}-ngw-3"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }

  depends_on = [aws_eip.elastic-ip-for-nat-gw-3, aws_internet_gateway.internet-gw]
  
}

resource "aws_route" "nat-gw-route-1" {
  route_table_id         = aws_route_table.private-route-table-1.id
  nat_gateway_id         = aws_nat_gateway.nat-gw-1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat-gw-route-2" {
  route_table_id         = aws_route_table.private-route-table-2.id
  nat_gateway_id         = aws_nat_gateway.nat-gw-2.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat-gw-route-3" {
  route_table_id         = aws_route_table.private-route-table-3.id
  nat_gateway_id         = aws_nat_gateway.nat-gw-3.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.internet-gw.id
  destination_cidr_block = "0.0.0.0/0"
}
