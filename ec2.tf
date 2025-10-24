data "aws_ami" "ubuntu_latest" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)
filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
region = "us-east-1"
}


output "ubuntu_ami_id" {
  description = "Latest Ubuntu AMI ID used for EC2 instances"
  value       = data.aws_ami.ubuntu_latest.id
}


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu_latest.id  # Ubuntu 22.04 in us-east-1
  instance_type               = "t2.micro"
  key_name                    = "devops-project"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.bastion_sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "application" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = "t2.micro"
  key_name                    = "devops-project"
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.app_sg.security_group_id]
  associate_public_ip_address = false

  tags = {
    Name = "application-server"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = "t2.micro"
  key_name                    = "devops-project"
  subnet_id                   = module.vpc.private_subnets[1]
  vpc_security_group_ids      = [
module.app_sg.security_group_id,
module.lb_sg.security_group_id
]
  associate_public_ip_address = false

  tags = {
    Name = "jenkins-server"
  }
}
