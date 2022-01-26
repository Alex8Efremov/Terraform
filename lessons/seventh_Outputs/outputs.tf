output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ipv4" {
  value = aws_eip.my_static_ip.public_ip # если не понятно что где брать
}                                        # ИДЁМ В ДОКУМЕНТАЦИЮ!!!!

output "webserver_security_id" {
  value = aws_security_group.my_name_SecGr.id
}

output "webserver_security_arn" {
  value       = aws_security_group.my_name_SecGr.arn
  description = "This is Description only for you=)"
}
