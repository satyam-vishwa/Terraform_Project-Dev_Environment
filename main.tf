resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "dev_vpc"
  }
}

resource "aws_subnet" "public_dev_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    name = "dev_public"
  }
}

resource "aws_internet_gateway" "dev_IGW" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_IGW"
  }
}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_IGW.id

}

resource "aws_route_table_association" "dev_public_assoc" {
  subnet_id      = aws_subnet.public_dev_subnet.id
  route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_security_group" "dev_SG" {
  name        = "dev_SG"
  description = "Dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "dev_auth" {
  key_name = "devkey"
  public_key = file("~/.ssh/devkey.pub")
}

resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
  ami = data.aws_ami.server_ami.id
  key_name = aws_key_pair.dev_auth.key_name
  vpc_security_group_ids = [aws_security_group.dev_SG.id]
  subnet_id = aws_subnet.public_dev_subnet.id
  user_data = file("userdata.tpl")

  tags = {
    Name = "dev node"
  }
  root_block_device {
    volume_size = 10
  }
  provisioner "local-exec" {
  command = templatefile("windows-ssh-config.tpl", {
    hostname = self.map_public_ip_on_launch
    user = "ec2-user"
    identityfile = "~/.ssh/devkey"
  })
  }

}