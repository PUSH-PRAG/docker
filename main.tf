terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.12.0"
    }
  }
}

provider "docker" {}


resource "null_resource" "dockervol" {
    provisioner "local-exec" {
        command = "mkdir httpdvol1/ || true && sudo chown -R 1000:1000 httpdvol/"
    }
}




resource "docker_image" "httpd_image" {
  name = "httpd:latest"
}

resource "random_string" "random" {
  count   = var.container_count
  length  = 4
  special = false
  upper   = false
}



resource "docker_container" "httpd_container" {
  count = var.container_count
  name  = join("-", ["httpd", random_string.random[count.index].result])
  image = docker_image.httpd_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
  volumes {
    container_path = "/data"
    host_path = "/home/ubuntu/environment/terraform"
 }

}
