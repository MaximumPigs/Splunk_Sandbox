# provider information

variable "key_pair" {
  type    = string
  default = "MaximumPigs_Key_Pair"
}

# Network Information

variable "my_ip" {
  type    = string
  default = ""
}

variable "pub_key" {
  type    = string
  default = ""
}

variable "runner_access_enabled" {
  type    = bool
  default = true
}

# Splunk Specific

variable "splunk_license" {
  type    = string
  default = ""
}

# Cribl Specific

variable "gh_user" {
  type        = string
  description = "The GitHub user with permission to fetch the Cribl remote repository"
  sensitive   = true
  default     = ""
}

variable "gh_pat" {
  type        = string
  description = "The GitHub Private Access Token assigned to user with permission to fetch the Cribl remote repository"
  sensitive   = true
  default     = ""
}

variable "gh_owner" {
  type        = string
  description = "The GitHub owner account of the Cribl remote repository"
  sensitive   = true
  default     = ""
}

variable "gh_repo" {
  type        = string
  description = "The name of the Cribl remote repository"
  sensitive   = true
  default     = ""
}

variable "gh_branch_prod" {
  type        = string
  description = "The Prod branch name of the Cribl remote repository to fetch"
  sensitive   = true
  default     = "master"
}

variable "gh_branch_dev" {
  type        = string
  description = "The Dev branch name of the Cribl remote repository to write changes to for review"
  sensitive   = true
  default     = "dev"
}

variable "cribl_token" {
  type        = string
  description = "The Cribl authentication token for bootstrapping workers"
  sensitive   = true
  default     = ""
}

# Instance Detauls

variable "cribl_count" {
  type        = number
  description = "The number of Cribl Linux instances to build"
  default     = 0
}

variable "splunk_single_count" {
  type        = number
  description = "The number of Splunk Single Linux instances to build"
  default     = 0
}

variable "splunk_uf_count" {
  type        = number
  description = "The number of Splunk UF Linux instances to build"
  default     = 0
}

variable "ubuntu_count" {
  type        = number
  description = "The number of Ubuntu Linux instances to build"
  default     = 0
}

variable "ubuntu_arm_count" {
  type        = number
  description = "The number of Ubuntu ARM Linux instances to build"
  default     = 0
}

variable "rhel_count" {
  type        = number
  description = "The number of RHEL Linux instances to build"
  default     = 0
}

variable "amazon_count" {
  type        = number
  description = "The number of Amazon Linux instances to build"
  default     = 0
}

variable "amazon_selinux_count" {
  type        = number
  description = "The number of Amazon SELinux instances to build"
  default     = 0
}

variable "windows_count" {
  type        = number
  description = "The number of Windows instances to build"
  default     = 0
}