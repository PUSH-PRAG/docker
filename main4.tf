terraform {
 required_providers {
     docker =  {
        source = "kreuzwerker/docker"
        version = "~>2.12.0"
        
     }
 }   
}

provider "docker" {}
#how to use local-exec provisioner and make it idempetent
resource "null_resource" "dockervol" {
    provisioner "local-exec" {
        command = "mkdir grafanavol/ || true && sudo chown -R 9000:3000 grafanavol/"
    }
}


#setting variables
# variable "external_port" {
#     type = number
#     default =8080
    
#     #setting validation
#     validation {
#         condition = var.external_port<=65535 && var.external_port > 0
#         error_message = "The external port must be 0-65535."
#     }
# }
# variable "int_port" {
#     type = number
#     default = 8080
    
#     #setting validation
#     validation {
#         condition = var.int_port == 8080
#         error_message = "The internal por should be 8080."
#     }
# }

# variable "container_count" {
#     type = number
#     default = 1
# }
#Create a terraform resource tha will pull the lates "grafana/grafana image to he node. Name resource "contiainer_image" and map the image.
# resource "docker_image" "grafana_image" {
#     name = "grafana/grafana:latest"
# }

# resource "docker_image" "grafana_image" {
#     name = lookup(var.image, var.env)
# }

#referencing workspace
# resource "docker_image" "grafana_image" {
#     name = lookup(var.image, terraform.workspace)
# }

resource "docker_image" "grafana_image" {
    name = var.image[terraform.workspace]
}
#create a random string
# resource "random_string" "random"{
#     length = 4
#     special = false
#     upper = false
# }

#use the count expression to create 2 random string
# resource "random_string" "random"{
#     count = var.container_count
#     length = 4
#     special = false
#     upper = false
# }

#how to reference local variables
resource "random_string" "random"{
    count = local.container_count
    length = 4
    special = false
    upper = false
}
#second random string for second container
# resource "random_string" "random2"{
#     length = 4
#     special = false
#     upper = false
# }

# reference your image
# resource "docker_container" "grafana_container" {
#     name = "grafana"
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = 8080
#         #external = 8080
#     }
# }

#referening the random result
# resource "docker_container" "grafana_container" {
#     name = join("-", ["grafana", random_string.random.result])
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = 8080
#         #external = 8080
#     }
# }

#use count.index to create 2 grafana containers
# resource "docker_container" "grafana_container" {
#     count = var.container_count
#     name = join("-", ["grafana", random_string.random[count.index].result])
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = var.int_port
#         external = var.external_port[count.index]
#     }
#     volumes {
#     #put the volume path here to persist docker volume
#         container_path = "/etc/grafana"
#         host_path = "/home/ubuntu/environment/terraform/grafanavol"
#     }
# }

#how to reference local variables
# resource "docker_container" "grafana_container" {
#     count = local.container_count
#     name = join("-", ["grafana", random_string.random[count.index].result])
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = var.int_port
#         external = lookup(var.external_port, var.env)[count.index]
#     }
    
    
    # resource "docker_container" "grafana_container" {
    # count = local.container_count
    # name = join("-", ["grafana", random_string.random[count.index].result])
    # image = docker_image.grafana_image.latest   
    # ports {
    #     internal = var.int_port
    #     external = lookup(var.external_port, terraform.workspace)[count.index]
    # }
    
    #referencing terraform.workspace
    # resource "docker_container" "grafana_container" {
    # count = local.container_count
    # name = join("-", ["grafana", terraform.workspace, random_string.random[count.index].result])
    # image = docker_image.grafana_image.latest   
    # ports {
    #     internal = var.int_port
    #     external = lookup(var.external_port, terraform.workspace)[count.index]
    # }
    
    
     resource "docker_container" "grafana_container" {
    count = local.container_count
    name = join("-", ["grafana", terraform.workspace, random_string.random[count.index].result])
    image = docker_image.grafana_image.latest   
    ports {
        internal = var.int_port
        #utilising map keys instead of lookups
        external = var.external_port[terraform.workspace][count.index]
    }
    volumes {
    #use string interpolation to make sure your cwd does not change
        container_path = "/etc/grafana"
        host_path = "${path.cwd}/grafanavol"
    }
    
    # volumes {
    # #put the volume path here to persist docker volume
    #     container_path = "/etc/grafana"
    #     host_path = "/home/ubuntu/environment/terraform"
    # }
}

#second container
# resource "docker_container" "grafana_container2" {
#     name = "grafana2"
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = 8080
#         #external = 8080
#     }
# }

#referencing random string for second container
# resource "docker_container" "grafana_container2" {
#     name = join("-",["grafana2",random_string.random2.result])
#     image = docker_image.grafana_image.latest   
#     ports {
#         internal = 8080
#         #external = 8080
#     }
# }
#outputs
# output "IPAddress" {
#     value = docker_container.grafana_container.ip_address
#     description = "The ip address of the container"
# }

# output "name" {
#     value = docker_container.grafana_container.name
#     description = "The name of the container"
# }
# #second output
# output "name2" {
#     value = docker_container.grafana_container2.name
#     description = "The name of the container"
# }


# #Using the join function, produce the name of the container and the port it is exposed
# output "IPAddress" {
#     value = join(":", [docker_container.grafana_container.ip_address, docker_container.grafana_container.ports[0].external])
#     description = "The ip address of the container"
# # }

#second join ip and name
# output "IPAddress2" {
#     value = join(":", [docker_container.grafana_container2.ip_address, docker_container.grafana_container2.ports[0].external])
#     description = "The ip address of the container"
# }

# #Use the splat expression to avoid duplicates for our outputs
# output "name" {
#     value = docker_container.grafana_container[*].name
#     description = "The name of the container"
# }

# #use the for loop to output the ip address and port
# output "IPAddress" {
#     value = [for i in docker_container.grafana_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
#     description = "The ip address  and exernal port of the container"
# }