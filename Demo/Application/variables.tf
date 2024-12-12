#################### Providers ###############################
variable "law_soft_delete_enabled" {
  type        = bool
  default     = false
  description = "Sould the workspace be soft deleted on destroy."
}

############################## Resource Group ##############################
