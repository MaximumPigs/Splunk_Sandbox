resource "aws_security_group" "splunk_sandbox" {
  name = "splunk_sandbox"
}

resource "aws_security_group_rule" "outbound_all" {
  security_group_id = aws_security_group.splunk_sandbox.id
  type = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_all" {
  security_group_id = aws_security_group.splunk_sandbox.id
  type = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks        = [ "${chomp(data.http.myip.response_body)}/32" ]
}