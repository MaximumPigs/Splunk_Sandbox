resource "aws_key_pair" "generated_key" {
  public_key = var.pub_key
}