variable "ext_port" {
  type = number
  

  validation {
    condition     = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "External port number must be in the range of 0-65535."
  }
}

variable "int_port" {
  type = number

  validation {
    condition     = var.int_port == 8080
    error_message = "The internal port must be 8080."
  }
}

variable "container_count" {
  type    = number
  default = 1
}