data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}

data "aws_region" "current" {}

data "aws_iam_instance_profile" "Cribl_Test_EC2_Role" {
  name = "Cribl_Test_EC2_Role"
}