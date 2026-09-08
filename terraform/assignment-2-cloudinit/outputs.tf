output "public_ip" {
  value = aws_instance.cloudinit_server.public_ip
}

output "url" {
  value = "http://${aws_instance.cloudinit_server.public_ip}"
}