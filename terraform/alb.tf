# --- Application Load Balancer ---

resource "aws_lb" "stackflow_alb" {
  name               = "stackflow-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name        = "stackflow-alb"
    Environment = var.environment
    Project     = "StackFlow"
  }
}

# --- ACM Certificate for HTTPS ---

resource "aws_acm_certificate" "stackflow_cert" {
  domain_name       = "stackflow.example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = var.environment
    Project     = "StackFlow"
  }
}

# --- Target Group ---

resource "aws_lb_target_group" "stackflow_tg" {
  name        = "stackflow-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = {
    Environment = var.environment
  }
}

# --- HTTPS Listener (Primary) ---

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.stackflow_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.stackflow_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stackflow_tg.arn
  }
}

# --- HTTP Listener (Redirect to HTTPS) ---

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.stackflow_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# --- Security Group ---

resource "aws_security_group" "alb_sg" {
  name   = "stackflow-alb-sg"
  vpc_id = module.vpc.vpc_id

  # HTTP — redirects to HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
