resource "aws_iam_policy" "policy" {
  count       = var.IAM_POLICY_CREATE ? 1 : 0
  name        = "${var.COMPONENT}-${var.ENV}-secret-manager-read-policy"
  path        = "/"
  description = "${var.COMPONENT}-${var.ENV}-secret-manager-read-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource" : "arn:aws:secretsmanager:us-east-1:739561048503:secret:roboshop-lTGHdX"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2-role" {
  count = var.IAM_POLICY_CREATE ? 1 : 0
  name  = "${var.COMPONENT}-${var.ENV}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.COMPONENT}-${var.ENV}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  count      = var.IAM_POLICY_CREATE ? 1 : 0
  role       = aws_iam_role.ec2-role.*.name[0]
  policy_arn = aws_iam_policy.policy.*.arn[0]
}

resource "aws_iam_instance_profile" "instance-profile" {
  count = var.IAM_POLICY_CREATE ? 1 : 0
  name  = "${var.COMPONENT}-${var.ENV}-ec2-role"
  role  = aws_iam_role.ec2-role.*.name[0]
}



