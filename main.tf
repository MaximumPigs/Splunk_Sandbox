resource "aws_instance" "cribl" {

  count                       = var.cribl_count
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.large"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]
  iam_instance_profile        = data.aws_iam_instance_profile.Cribl_EC2_Role.name

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "Cribl_Sandbox_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data_base64 = base64encode(templatefile("cloudinit/userdata_cribl.tmpl", {
    gen_key        = var.pub_key,
    gh_owner       = var.gh_owner,
    gh_repo        = var.gh_repo,
    gh_branch_prod = var.gh_branch_prod,
    gh_branch_dev  = var.gh_branch_dev
    cribl_token    = var.cribl_token,
    install_script = base64encode(file("scripts/cribl_install.sh")),
    priv_key       = base64encode(file("gh_priv")),
  }))
}

resource "aws_instance" "splunk_single" {

  count                       = var.splunk_single_count
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.xlarge"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]
  iam_instance_profile        = data.aws_iam_instance_profile.Cribl_EC2_Role.name

  root_block_device {
    delete_on_termination = true
    volume_size           = "15"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "splunk_single_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data_base64 = base64encode(templatefile("cloudinit/userdata_gen.tmpl", {
    gen_key        = var.pub_key,
    install_script = base64encode(file("scripts/splunk_single_install.sh")),
  }))
}

resource "aws_instance" "splunk_uf" {
  depends_on = [aws_instance.cribl]

  count                       = var.splunk_uf_count
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]
  iam_instance_profile        = data.aws_iam_instance_profile.Cribl_EC2_Role.name

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "splunk_uf_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  user_data_base64 = base64encode(templatefile("cloudinit/userdata_splunk_uf.tmpl", {
    gen_key        = var.pub_key,
    install_script = base64encode(file("scripts/splunk_uf_install.sh")),
    cribl_ip       = aws_instance.cribl[0].public_ip
  }))
}

resource "aws_instance" "ubuntu" {

  count                       = var.ubuntu_count
  ami                         = "ami-08f0bc76ca5236b20"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "Ubuntu_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "ubuntu_arm" {

  count                       = var.ubuntu_arm_count
  ami                         = "ami-02e9625c5bc9a2d34"
  instance_type               = "t4g.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "Ubuntu_ARM_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "rhel" {

  count                       = var.rhel_count
  ami                         = "ami-086918d8178bfe266"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "10"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "RHEL_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "amazon" {

  count                       = var.amazon_count
  ami                         = "ami-0e326862c8e74c0fe"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "Amazon_Linux_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "amazon_selinux" {

  count                       = var.amazon_selinux_count
  ami                         = "ami-08d7fedd4b5ab9306"
  instance_type               = "t3.micro"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = "8"
  }

  tags = {
    "project" = "splunk_sandbox"
    "Name"    = "Amazon_SELinux_Grech"
  }

  credit_specification {
    cpu_credits = "standard"
  }
}

resource "aws_instance" "windows" {

  count                       = var.windows_count
  ami                         = "ami-0618bc348d63ed100"
  instance_type               = "t3.medium"
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.splunk_sandbox.id}"]

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
