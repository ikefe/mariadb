resource "aws_db_parameter_group" "default_parameter" {
  name   = "mariadbparameter"
  family = "mariadb10.5"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_subnet_group" "default_subnet" {
  name       = "mainsubnet"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.5.13"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  username               = "root"
  password               = "funflip001"
  parameter_group_name   = aws_db_parameter_group.default_parameter.name
  db_subnet_group_name   = aws_db_subnet_group.default_subnet.name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  availability_zone      = aws_subnet.private_1.availability_zone
  skip_final_snapshot    = true
}

output "end_point" {
  value = aws_db_instance.default.endpoint
}
