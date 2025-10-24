module "bastion_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access"
      cidr_blocks = "0.0.0.0/0"  # Replace with your IP
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "app_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "app-sg"
  description = "Allow internal traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Internal access"
      cidr_blocks = "10.0.0.0/16"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
 }

module "lb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "lb-to-app"
  description = "Allow traffic from Load Balancer to App"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "HTTP from LB"
      source_security_group_id = module.lb_sg.security_group_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "HTTPS from LB"
      source_security_group_id = module.lb_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound"
      cidr_blocks = "0.0
