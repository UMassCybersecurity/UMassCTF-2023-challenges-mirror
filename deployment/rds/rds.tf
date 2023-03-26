# DB used by CTFd
resource "aws_db_instance" "db" {
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  db_name                = var.name
  engine                 = "mysql"
  username               = var.username
  password               = var.password
  storage_type           = "gp3"
  apply_immediately      = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = true
}