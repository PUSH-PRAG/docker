output "IPAddress" {
  value       = [for i in docker_container.httpd_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP Address and port  of the container"

}

output "container_name" {
  value       = docker_container.httpd_container[*].name
  description = "The name of the container"
}