output "instance_ips" {
  value = [for instance in aws_instance.cribl : instance.public_ip]
}