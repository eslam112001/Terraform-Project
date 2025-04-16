# instance target group 
resource "aws_lb_target_group" "my_target_group" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb" "my_load_balancer" {
  name               = "terraform-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = [
    aws_subnet.my_public_subnet_a.id,
    aws_subnet.my_public_subnet_b.id
  ]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.my_log_bucket.id
    enabled = true
  }

  tags = {
    project = "terraform load balancer"
  }
}

resource "aws_lb_listener" "my_load_balancer_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}
