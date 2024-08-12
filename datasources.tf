data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["309956199498"]
  
  filter {
    name   = "image-id"
    values = ["ami-022ce6f32988af5fa"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
