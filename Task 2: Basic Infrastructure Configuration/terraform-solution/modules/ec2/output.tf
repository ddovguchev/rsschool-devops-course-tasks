output "instances_info" {
  description = "Information about the created instances"
  value = { for k, v in aws_instance.server : k => {
    ec_name        = v.tags.Name
    ec_id          = v.id
    eni_id         = v.primary_network_interface_id
    ip_public      = v.public_ip != "" ? v.public_ip : "No public IP"
    ip_private     = v.private_ip
    key_pairs_name = v.key_name != "" ? v.key_name : "No ssh key IP"

  }}
}