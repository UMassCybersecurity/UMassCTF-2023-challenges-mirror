data "aws_iam_policy_document" "ecsTaskExecutionRoleECSClusterDocument" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRoleECSCluster" {
  assume_role_policy = data.aws_iam_policy_document.ecsTaskExecutionRoleECSClusterDocument.json
  name               = "${var.name}-ecsTaskExecutionRoleECSCluster"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRoleECSClusterAttachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecsTaskExecutionRoleECSCluster.name
}