# Create a VPC with CIDR block and appropriate tags
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My VPC"
  }
  enable_dns_hostnames = true
  enable_dns_support = true

}

# Create a public subnet with CIDR block, availability zone, and tags
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Replace with your desired AZ
  tags = {
    Name = "Public Subnet"
  }
}

# Create an internet gateway and add appropriate tags
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway"
  }
}

# Create a route table with a route to the internet gateway and tags
resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_subnet_route_table_assoc" {
  subnet_id         = aws_subnet.public.id
  route_table_id    = aws_route_table.prt.id
}

# Create a security group with SSH access rules and tags
resource "aws_security_group" "ssh" {
  name = "SSH"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this for production environments
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSH Security Group"
  }
}

# Create an EC2 instance with desired AMI, instance type, security group IDs, subnet ID, and tags
resource "aws_instance" "webserver" {
  ami                    = "ami-0b0ea68c435eb488d" # Replace with your desired AMI
  instance_type          = "t2.micro" # Replace with your desired instance type
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true #assign public ip
  key_name = "terraform-key"

  tags = {
    Name = "Web Server"
  }
  # Consider adding user data script for initial configuration
  # user_data = file("user_data.sh")
  # Consider adding volume configurations for persistent storage
  # # ...
}

# Output the public IP address of the instance
output "public_ip" {
  value = aws_instance.webserver.public_ip
}





resource "aws_security_group" "db" {
  name   = "db"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB SG"
  }
}



resource "aws_subnet" "database_subnet_0" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Database0"
  }
}

resource "aws_subnet" "database_subnet_11" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Database0b"
  }
}


resource "aws_route_table_association" "first" {
  subnet_id      = aws_subnet.database_subnet_0.id
  route_table_id = aws_route_table.prt.id
}
resource "aws_route_table_association" "second" {
  subnet_id      = aws_subnet.database_subnet_11.id
  route_table_id = aws_route_table.prt.id
}



resource "aws_db_instance" "RDS" {
  identifier = "mydb"
  allocated_storage    = 20
  storage_type = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  multi_az             = false
  username             = "admin12"
  password             = "password12"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_group.name
  port = 3306
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.db.id]
  tags = {
    Name = "RDS db"
  }
}


resource "aws_db_subnet_group" "rds_group" {
  name       = "subnet group"
  subnet_ids = [aws_subnet.database_subnet_0.id,aws_subnet.database_subnet_11.id]
  tags = {
    Name = "RDS subnet group"
  }
}





