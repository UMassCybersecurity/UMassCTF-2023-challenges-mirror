data "aws_ecr_repository" "ecr" {
  name = var.ecr_repo_name
}