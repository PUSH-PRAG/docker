#Use the splat expression to avoid duplicates for our outputs
output "name" {
    value = docker_container.grafana_container[*].name
    description = "The name of the container"
}

#use the for loop to output the ip address and port
output "IPAddress" {
    value = [for i in docker_container.grafana_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
    description = "The ip address  and exernal port of the container"
    
    #use sensitive flag to protect your datat
    # sensitive = true
}