resource "aws_security_group" "splunk_sandbox" {
  name = "splunk_sandbox"
}

resource "aws_security_group_rule" "outbound_all" {
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_all_my_ip" {
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "aws_security_group_rule" "inbound_splunk_uf" {
  for_each = {
    for index, instance in aws_instance.splunk_uf :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${aws_instance.splunk_uf[0].public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_cribl" {
  for_each = {
    for index, instance in aws_instance.cribl :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${aws_instance.cribl[0].public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_ubuntu" {
  for_each = {
    for index, instance in aws_instance.ubuntu :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_ubuntu_arm" {
  for_each = {
    for index, instance in aws_instance.ubuntu_arm :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_rhel" {
  for_each = {
    for index, instance in aws_instance.rhel :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_amazon" {
  for_each = {
    for index, instance in aws_instance.amazon :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_amazon_selinux" {
  for_each = {
    for index, instance in aws_instance.amazon_selinux :
    index => instance
  }
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${each.value.public_ip}/32"]
}

resource "aws_security_group_rule" "inbound_uberAgent" {
  count             = 1
  security_group_id = aws_security_group.splunk_sandbox.id
  type              = "ingress"
  from_port         = 19500
  to_port           = 19500
  protocol          = "tcp"
  cidr_blocks       = ["13.236.250.112/32"]
}
