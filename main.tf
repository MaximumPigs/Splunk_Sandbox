resource "aws_instance" "cribl" {

  count                       = 1
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.medium"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]
  iam_instance_profile        = aws_iam_instance_profile.s3_access.name

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data_base64 = base64encode(templatefile("cloudinit/userdata.tmpl", {
    gen_key        = var.pub_key,
    gh_owner       = var.gh_owner,
    gh_repo        = var.gh_repo,
    gh_branch_prod = var.gh_branch_prod,
    gh_branch_dev  = var.gh_branch_dev
    cribl_token    = var.cribl_token,
    install_script = base64encode(file("scripts/cribl_install.sh")),
    priv_key       = base64encode(file("gh_priv"))
  }))
}

resource "aws_instance" "splunk" {

  count                       = 0
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.xlarge"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "15"
  }

  tags = {
    "project" = "splunk_sandbox"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data_base64 = base64encode(templatefile("cloudinit/userdata.tmpl", {
    gen_key        = var.pub_key,
    gh_owner       = "",
    gh_repo        = "",
    gh_branch_prod = "",
    gh_branch_dev  = "",
    cribl_token    = "",
    install_script = base64encode(file("scripts/splunk_install.sh")),
    priv_key       = ""
  }))
}
/*
resource "aws_instance" "syslog" {

  count                       = 0
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = ["${aws_security_group.security_group.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "windows" {

  count                       = 0
  ami                         = "ami-0618bc348d63ed100"
  instance_type               = "t3.medium"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = ["${aws_security_group.security_group.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "30"
  }

  tags = {
    "project" = "splunk_sandbox"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}
*/