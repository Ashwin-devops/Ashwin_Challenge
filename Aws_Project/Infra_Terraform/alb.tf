resource "aws_lb" "test" {
  name               = "managed-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = aws_subnet.public_subnets.*.id

  enable_deletion_protection = true

  tags = {
    Name        = "application Server"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "test" {
  name     = "managed-lb-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "test2" {
  name     = "managed-lb-9090"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "test3" {
  name     = "managed-lb-3000"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.test.arn
  port              = "8080"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
resource "aws_lb_listener" "test2" {
  load_balancer_arn = aws_lb.test.arn
  port              = "9090"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test2.arn
  }
}
resource "aws_lb_listener" "test3" {
  load_balancer_arn = aws_lb.test.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test3.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "target_8080" {
  alarm_name          = "target_8080"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  ok_actions          = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  dimensions = {
    TargetGroup  = aws_lb_target_group.test.arn_suffix
    LoadBalancer = aws_lb.test.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "target_9090" {
  alarm_name          = "target_9090"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  ok_actions          = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  dimensions = {
    TargetGroup  = aws_lb_target_group.test2.arn_suffix
    LoadBalancer = aws_lb.test.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "target_3000" {
  alarm_name          = "target_3000"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Number of healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  ok_actions          = ["arn:aws:sns:us-west-2:502691225708:Default_CloudWatch_Alarms_Topic"]
  dimensions = {
    TargetGroup  = aws_lb_target_group.test3.arn_suffix
    LoadBalancer = aws_lb.test.arn_suffix
  }
}