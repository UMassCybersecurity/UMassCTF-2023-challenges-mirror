resource "aws_cloudwatch_metric_alarm" "alarm_cpu_high" {
  count               = var.auto_scaling ? 1 : 0
  alarm_name          = "${var.name}-alarm-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  namespace           = "AWS/ECS"

  metric_name = "CPUUtilization"
  period      = 60
  threshold   = 80
  statistic   = "Average"

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_autoscaling_policy_up[count.index].arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu_low" {
  count               = var.auto_scaling ? 1 : 0
  alarm_name          = "${var.name}-alarm-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  namespace           = "AWS/ECS"

  metric_name = "CPUUtilization"
  period      = 60
  threshold   = 40
  statistic   = "Average"

  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_autoscaling_policy_down[count.index].arn]
}