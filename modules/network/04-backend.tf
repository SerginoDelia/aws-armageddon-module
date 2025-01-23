resource "aws_db_subnet_group" "db" {
  for_each = {for k,v in var.network.subnets : k => v if endswith(k, "private")}
  name       = "${each.key}-db-subnet-group"
  subnet_ids = [for k, v in var.network.subnets : aws_subnet.subnets[k].id if endswith(k, "private")]
}

# resource "aws_db_subnet_group" "db" {
#   name = "db-subnet-group"
#   subnet_ids = [for k, v in var.network.subnets : aws_subnet.subnets[k].id if endswith(k, "private")]
# }

resource "aws_db_instance" "db" {
  for_each = {for k,v in var.network.subnets : k => v if endswith(k, "private")}
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "foobarbaz"
  skip_final_snapshot  = true
  deletion_protection  = false
  db_subnet_group_name = aws_db_subnet_group.db[each.key].name
  # db_subnet_group_name = aws_db_subnet_group.db.name
}