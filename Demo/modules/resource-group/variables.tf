variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string  
}

variable "location" {
  description = "The location/region for the resource group"
  type        = string
}
variable "create_resource_group" {
  description = "Create a new resource group or use an existing one"
  type        = bool
  default     = true  
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group."
  type        = map(string)
  default     = {}  
}