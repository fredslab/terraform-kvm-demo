# VM Configuration Variables
variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "vm1"
}

variable "vm_memory" {
  description = "Memory allocation for the VM in MB"
  type        = number
  default     = 3048
}

variable "vm_vcpu" {
  description = "Number of virtual CPUs for the VM"
  type        = number
  default     = 2
}

variable "vm_network" {
  description = "Name of the network to attach the VM to"
  type        = string
  default     = "default" # Matches your original network_name
}

variable "vm_disk_size" {
  description = "Size of the VM disk in bytes (minimum 2GB)"
  type        = number
  default     = null
  validation {
    condition     = var.vm_disk_size == null || var.vm_disk_size >= 2147483648
    error_message = "Disk size must be at least 2GB (2147483648 bytes)."
  }
}

# Root Password Variable (moved from vm.tf)
variable "rootpassword" {
  description = "Root password for the VM"
  type        = string
  default     = "default_password"
}