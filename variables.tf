

variable "image" {
  type        = map(any)
  description = "Image for container"
  default = {
    dev  = "httpd:latest"
    prod = "httpd:latest-minimal"
  }
}

variable "ext_port" {
  type = map

  validation {
    condition = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 0
    error_message = "The external port must be in the range of 0 - 65535."
  }
  validation {
    condition = max(var.ext_port["prod"]...) <= 65535 && min(var.ext_port["prod"]...) >= 0
    error_message = "The external port must be in the range of 0 - 65535."
  }
}

variable "int_port" {
  type    = number
  default = 8080

  validation {
    condition     = var.int_port == 8080
    error_message = "The internal port must be 8080."
  }
}

locals {
  container_count = length(var.ext_port[terraform.workspace])
}
