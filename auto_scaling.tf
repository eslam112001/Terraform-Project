resource "aws_launch_template" "my_template" {
  name_prefix   = "mytemplate"
  image_id      = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Welcome to Terraform Auto Scaling Web Server</h1>" > /usr/share/nginx/html/index.html
              EOF
            )
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
}

resource "aws_autoscaling_group" "my_auto_scal" {
  desired_capacity     = 2
  max_size             = 6
  min_size             = 1

  vpc_zone_identifier  = [aws_subnet.my_public_subnet_a.id,
                          aws_subnet.my_public_subnet_b.id]

  launch_template {
    id      = aws_launch_template.my_template.id
    version = "$Latest"
  }
  tag {
    key                 = "terraform-as"
    value               = "autoscaling-nginx"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  target_group_arns = [ aws_lb_target_group.my_target_group.arn ]
}
