variable "external_port" {
    type = number
    default =8080
    # sensitive = true
    
    #setting validation
    validation {
        condition = var.external_port<=65535 && var.external_port > 0
        error_message = "The external port must be 0-65535."
    }
}
variable "int_port" {
    type = number
    default = 8080
    #using the sensitive flag to make deails reductant
    # sensitive = true
    
    #setting validation
    validation {
        condition = var.int_port == 8080
        error_message = "The internal por should be 8080."
    }
}

variable "container_count" {
    type = number
    default = 1
}