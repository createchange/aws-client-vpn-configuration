output "{{ item }}_cert_body" {
  value = "${module.acm.{{ item }}_cert_body}"
}

output "{{ item }}_private_key" {
  value = "${module.acm.{{ item }}_private_key}"
}

