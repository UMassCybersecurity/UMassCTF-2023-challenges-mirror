resource "aws_security_group" "db_sg" {
  name        = "${var.name}-db_sg"
  description = "Security group for the RDS used by CTFd"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.subnet]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}