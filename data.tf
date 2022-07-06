data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "${var.COMPONENT}-${var.APP_VERSION}"
  owners      = ["self"]
}

data "aws_secretsmanager_secret" "secret" {
  name = "roboshop"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
