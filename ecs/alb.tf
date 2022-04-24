 resource "aws_lb" "lb" {
  name               = "${var.project}-${var.environment}"
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-3.id]
  security_groups    = [aws_security_group.public-security-group.id]

  depends_on         = [
   aws_subnet.public-subnet-1,
   aws_subnet.public-subnet-2, 
   aws_subnet.public-subnet-3,
  ]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  deregistration_delay = "30"

  health_check {
    enabled             = "true"
    interval            = "30"
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "10"
    unhealthy_threshold = "3"
    healthy_threshold   = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.project}-${var.environment}"
  port                          = var.port
  protocol                      = "HTTP"
  slow_start                    = "120"
  target_type                   = "ip"
  vpc_id                        = aws_vpc.vpc.id

  lifecycle {
    create_before_destroy = true
  }
}




