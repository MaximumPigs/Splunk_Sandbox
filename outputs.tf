output "cribl_ip" {
  value = [for instance in aws_instance.cribl : instance.public_ip]
}

output "splunk_ip" {
  value = [for instance in aws_instance.splunk : instance.public_ip]
}

output "syslog_ip" {
  value = [for instance in aws_instance.syslog : instance.public_ip]
}

output "windows_ip" {
  value = [for instance in aws_instance.windows : instance.public_ip]
}