data "aws_vpc" "staging" {
  filter {
    name   = "tag:Name"
    values = ["staging"]
  }
}

resource "aws_subnet" "stage" {
  vpc_id                  = data.aws_vpc.staging.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "staging-stage-subnet"
  }
}

module "sg" {
  source = "../../modules/sg"

  name        = "staging-sg"
  description = "Security group for staging server"
  vpc_id      = data.aws_vpc.staging.id

  ingress_rules = [
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["139.135.36.209/32", "0.0.0.0/0"]
    },
    {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = "staging-server"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.stage.id
  vpc_security_group_ids = [module.sg.security_group_id]
  attach_eip             = true
}
