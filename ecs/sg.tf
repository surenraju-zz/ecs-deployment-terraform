
resource "aws_security_group" "public-security-group" {
  name        = "${var.project}-${var.environment}-public-sg"
  description = "Internet reaching access for EC2 instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH on port 22 from Internet. This is required to setup linux bastien host"
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]   
  }

  ingress {
    description = "Allow RDP on port 3389 from Internet. This is required to setup windows bastien host"
    from_port   = 3389
    protocol    = "TCP"
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"]   
  }

  ingress {
    description = "Allow HTTP traffic on port 80 from Internet."
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic on port 443 from Internet."
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access on any port within the public security group."
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    self        = true
  }

  egress {
    description = "Allow access to Internet on any port"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-sg"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_security_group" "private-security-group" {
  name        = "${var.project}-${var.environment}-private-sg"
  description = "Only allow public EC2 instances to access these instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP traffic on port 80 from public subnet"
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    security_groups = [aws_security_group.public-security-group.id]
  }

  ingress {
    description = "Allow HTTP traffic on port 80 from public subnet"
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    security_groups = [aws_security_group.public-security-group.id]
  }

  ingress {
    description = "Allow HTTPS traffic on port 443 from public subnet"
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    security_groups = [aws_security_group.public-security-group.id]
  }

  ingress {
    description = "Allow access on any port within the security group. All instances in private subnet allowed to talk to each other on any port."
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    self        = true
  }

  egress {
    description = "Allow access to Internet on any port"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-private-sg"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}


resource "aws_security_group" "efs-security-group" {

  name        = "${var.project}-${var.environment}-efs-sg"
  description = "Allow access to EFS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow NFS access"
    from_port   = 2049
    protocol    = "TCP"
    to_port     = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-efs-sg"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}
