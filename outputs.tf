output "cribl_ip" {
  value = {
    for index, instance in aws_instance.cribl :
    index => instance.public_ip
  }
}

output "splunk_single_ip" {
  value = {
    for index, instance in aws_instance.splunk_single :
    index => instance.public_ip
  }
}

output "splunk_uf_ip" {
  value = {
    for index, instance in aws_instance.splunk_uf :
    index => instance.public_ip
  }
}

output "ubuntu_ip" {
  value = {
    for index, instance in aws_instance.ubuntu :
    index => instance.public_ip
  }
}

output "ubuntu_arm_ip" {
  value = {
    for index, instance in aws_instance.ubuntu_arm :
    index => instance.public_ip
  }
}

output "rhel_ip" {
  value = {
    for index, instance in aws_instance.rhel :
    index => instance.public_ip
  }
}

output "amazon_ip" {
  value = {
    for index, instance in aws_instance.amazon :
    index => instance.public_ip
  }
}

output "amazon_selinux_ip" {
  value = {
    for index, instance in aws_instance.amazon_selinux :
    index => instance.public_ip
  }
}

output "windows_ip" {
  value = {
    for index, instance in aws_instance.windows :
    index => instance.public_ip
  }
}