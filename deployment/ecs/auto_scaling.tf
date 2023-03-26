resource "aws_appautoscaling_target" "app_autoscaling_target" {
  count              = var.auto_scaling ? 1 : 0
  max_capacity       = 8
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "app_autoscaling_policy_down" {
  count              = var.auto_scaling ? 1 : 0
  name               = "${var.name}-autoscale-down"
  resource_id        = aws_appautoscaling_target.app_autoscaling_target[count.index].id
  scalable_dimension = aws_appautoscaling_target.app_autoscaling_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_autoscaling_target[count.index].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "app_autoscaling_policy_up" {
  count              = var.auto_scaling ? 1 : 0
  name               = "${var.name}-autoscale-up"
  resource_id        = aws_appautoscaling_target.app_autoscaling_target[count.index].id
  scalable_dimension = aws_appautoscaling_target.app_autoscaling_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.app_autoscaling_target[count.index].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}