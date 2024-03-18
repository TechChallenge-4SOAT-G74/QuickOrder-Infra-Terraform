// Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

// Backend
terraform {
  backend "s3" {
    bucket = "quickordertemp"
    key    = "quickorder/terraform.tfstate"
    region = "us-east-1"
  }
}

// ECR
# resource "aws_ecr_repository" "repository" {
#   name = "quickorder"
# }

// VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC-ECS"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
}

// Security group
resource "aws_security_group" "alb" {
  name   = "alb_ECS"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "entrada_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "saida_alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "privado" {
  name   = "privado_ECS"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "entrada_ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.privado.id
}

resource "aws_security_group_rule" "saida_ecs" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.privado.id
}

// IAM
resource "aws_iam_role" "role" {
  name = "quickorder_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_ecr" {
  name = "ecs_ecr"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CreateRepository",
          "ecr:ListRepositories",
          "ecr:DescribeRepositories",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_instance" "app_server" {
  ami                  = "ami-080e1f13689e07408"
  instance_type        = "t2.micro"
  key_name             = "quickorder"
  iam_instance_profile = aws_iam_instance_profile.profile.name
}

resource "aws_iam_instance_profile" "profile" {
  name = "quickorder_profile"
  role = aws_iam_role.role.name
}

// Load balancer
resource "aws_lb" "alb" {
  name            = "quickorder"
  security_groups = [aws_security_group.alb.id]
  subnets         = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "quickorder"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

// Output
output "IP" {
  value = aws_lb.alb.dns_name
}

// ECS Application
module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  cluster_name = "my-ecs"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }
  cluster_settings = {
    "name" : "containerInsights",
    "value" : "enabled"
  }
}

// Cloud watch log
resource "aws_cloudwatch_log_group" "quickorder" {
  name = "quickorder"
}

resource "aws_cloudwatch_log_stream" "quickorder" {
  name           = "quickorder"
  log_group_name = aws_cloudwatch_log_group.quickorder.name
}

// Task
resource "aws_ecs_task_definition" "quickorder-api" {
  family                   = "quickorder-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.role.arn

  container_definitions = jsonencode([
    {
      name      = "quickorder"
      image     = "590183827841.dkr.ecr.us-east-1.amazonaws.com/quickorder:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.quickorder.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "quickorder"
        }
      }
      environment = [
        {
          name  = "DB_SECRET_ARN",
          value = aws_secretsmanager_secret.my_db_secret.arn
        },
        {
          name  = "DB_CONNECTION_STRING_MONGODB",
          value = "mongodb+srv://mongo:mongo@quickorderdb.8onahmc.mongodb.net/?retryWrites=true&w=majority&appName=quickorderdb",
        },

        {
          name  = "AWS_SECRET_ACCESS_KEY",
          value = "I6I5oU7jOuqOsJZBYl3/a/bBf46z/+W0ThGdZQgO"
        },
        {
          name  = "AWS_ACCESS_KEY_ID",
          value = "AKIAYS2NSRGAXPMUD5TM"
        },
        
        
      ]
    }
  ])
}

// Service
resource "aws_ecs_service" "quickorder-api" {
  name            = "quickorder-api"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.quickorder-api.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "quickorder"
    container_port   = 80
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.alb.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

// PostgreSQL
resource "aws_db_instance" "quickorderdb" {
  engine               = "postgres"
  identifier           = "quickorderdb"
  allocated_storage    = 20
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "postgres"
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  publicly_accessible  = true
  multi_az             = false
}

resource "aws_secretsmanager_secret" "my_db_secret" {
  name = "postgres-db-secret"
}

resource "aws_secretsmanager_secret_version" "my_db_secret_version" {
  secret_id = aws_secretsmanager_secret.my_db_secret.id
  secret_string = jsonencode({
    username = "postgres",
    password = "postgres",
    engine   = "postgres",
    host     = aws_db_instance.quickorderdb.address,
    port     = aws_db_instance.quickorderdb.port,
    dbname   = "quickorderdb"
  })
}