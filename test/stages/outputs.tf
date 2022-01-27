output "public_subnet_ids" {
  depends_on = [
    module.dev_vpc_subnet
  ]
  value = module.dev_vpc_subnet.public_subnet_ids

}
output "private_subnet_ids" {
  depends_on = [
    module.dev_vpc_subnet
  ]
  value = module.dev_vpc_subnet.private_subnet_ids
}