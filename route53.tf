resource "aws_route53_record" "alb" {
  zone_id = var.PRIVATE_HOSTED_ZONE_ID
  name    = "${var.COMPONENT}-${var.ENV}.roboshop.internal"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.alb.dns_name]
}

