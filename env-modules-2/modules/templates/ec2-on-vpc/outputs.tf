#####################################################
# Outputs
#####################################################
output "ec2_arn" {
  value = module.vm.ec2_arn
}

output "ec2_host_id" {
  value = module.vm.ec2_host_id
}

output "ec2_public_ip" {
  value = module.vm.ec2_public_ip
}
