variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "27152942-a39b-441f-905e-cc6165c153de"
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "MMMG04"
}

variable "public_address_id" {
  description = "Public IP Address ID"
  type        = string
  default     = "/subscriptions/27152942-a39b-441f-905e-cc6165c153de/resourceGroups/MMMG04/providers/Microsoft.Network/publicIPAddresses/ECOM04-IP"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "West Europe"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

variable "public_ssh_key" {
  description = "Public SSH Key for VM"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDmblgonLIm7elzzmKX6cjV8c8TTJM2H/cKxr5RmxrPr69oi7KqP8Vp87aIFF+VupcCNpE7CBchrphZ5JcCugRnEFT1VliKMx0u84a4xl0I+GHAVdrbDU+vkq2cCh51b3rlhV9GD+youmX6CXJkIagXxPpxbC0jfInWAEx8dbhySuTokQ+VUkrNjrFjFmzSVPHZOip/DN/qBP7ddyFapAOiCzI3clwD0738OdqTq3S3XEIiLz/KEx2NDRpl2Rl6OYwuISaqr4qlDY51LqBhEI7sm92JX7gxVoRD1SQtlT46CB5fJ4q5KYo4jR4txxW6Z5abVBJLcZY10Ijhf6IjSacVDNx2DplGNXT8R9VsrvDb9c5HSeDAYLzSzzblxsyZITUQqrAlikmIaThBxaCwmsfpg1vaUdQbLkqgPk/bHB+Mt1IWFdD5KPATv958X1ku0Vo0xvd+PEBD7kkxLFo87soPTCnzJqu6H/ablhumUdIZrw5gI2XOrUi8VbRxjDSBFE= generated-by-azure"
}
