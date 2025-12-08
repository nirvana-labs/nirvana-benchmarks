variable "region" {
  description = "Nirvana region to deploy resources"
  type        = string
  default     = "us-sva-2"
}

variable "name" {
  description = "Name for all resources"
  type        = string
  default     = "clickbench-hardware"
}

variable "tags" {
  description = "Tags for all resources"
  type        = list(string)
  default     = ["benchmarking"]
}

variable "my_ip" {
  description = "My IP address"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "cpu" {
  description = "CPU"
  type        = number
  default     = 24
}

variable "memory" {
  description = "Memory"
  type        = number
  default     = 64
}

variable "boot_disk_size" {
  description = "Boot disk size"
  type        = number
  default     = 64
}

variable "data_disk_size" {
  description = "Data disk size"
  type        = number
  default     = 64
}

variable "provisioner_timeout" {
  description = "Timeout for remote-exec provisioner"
  type        = string
  default     = "30m"
}

locals {
  volume_type = var.region == "us-sva-2" ? "abs" : "nvme"
}
