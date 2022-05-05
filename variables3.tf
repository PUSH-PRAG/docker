
#setting up env
# variable "env" {
#     type = string 
#     default = "dev"
#     description = "env to deploy to"
# }

variable "image" {
    type = map
    description = "image for container"
    default = {
        dev  = "grafana/grafana:latest"
        prod = "grafana/grafana:latest-minimal"
    }
}

# variable "external_port" {
#     type = list
#     # sensitive = true
    
    variable "external_port" {
    type = map
    # sensitive = true
    
    #setting validation
#     validation {
#         condition = var.external_port<=65535 && var.external_port > 0
#         error_message = "The external port must be 0-65535."
#     }



#setting max and min and using the max spread operator
    # validation {
    #     condition = max(var.external_port...)<=65535 && min(var.external_port...)> 0
    #     error_message = "The external port must be 0-65535."
    # }
 #}
 
 #setting up validation rule for our dev and prod
    validation {
        condition = max(var.external_port["dev"]...)<=65535 && min(var.external_port["dev"]...)>= 8080
        error_message = "The external port must be 0-65535."
    }
 
 validation {
        condition = max(var.external_port["prod"]...)<=8084 && min(var.external_port["prod"]...)>= 8080
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

# variable "container_count" {
#     type = number
#     default = 3
# }

#setting up local variables
# locals {
#     container_count = length(var.external_port)
# }
#mapping exernal ports
# locals {
#     container_count = length(lookup(var.external_port, var.env))
# }
#referencing our workspace
# locals {
#     container_count = length(lookup(var.external_port, terraform.workspace))
# }


locals {
    container_count = length(var.external_port[terraform.workspace])
}