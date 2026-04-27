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
    },
    {
      description = ""
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = ""
      from_port   = 6432
      to_port     = 6432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "WireGuard access"
      from_port   = 51820
      to_port     = 51820
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Application port"
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = "staging-server"
  ami                    = "ami-0bc9640685b706689"
  instance_type          = "t2.medium"
  root_volume_size       = 30
  subnet_id              = aws_subnet.stage.id
  vpc_security_group_ids = [module.sg.security_group_id]
  attach_eip             = true
  source_dest_check      = false
}

data "aws_route_table" "public" {
  filter {
    name   = "tag:Name"
    values = ["staging-public-rt"]
  }
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "tom-uploads-5454-stage"
}

resource "aws_route_table_association" "stage" {
  subnet_id      = aws_subnet.stage.id
  route_table_id = data.aws_route_table.public.id
}
