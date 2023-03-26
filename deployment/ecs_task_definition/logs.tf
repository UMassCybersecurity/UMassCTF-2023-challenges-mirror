# Logs for ECS service
resource "aws_cloudwatch_log_group" "log_group" {
  name = local.log_group
}