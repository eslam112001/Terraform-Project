resource "aws_cloudwatch_metric_alarm" "my_cloudwatch" {
  alarm_name                = "terraform-alarm-to-auto-scaling"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    aws_autoscaling_group = aws_autoscaling_group.my_auto_scal.name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_asg" {
  alarm_name          = "high-cpu-asg"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when average CPU in ASG is above 70%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_auto_scal.name
  }
  alarm_actions = [aws_sns_topic.my_sns.arn]
}