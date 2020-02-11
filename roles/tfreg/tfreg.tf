module "tfreg" {
    source = "apparentlymart/tf-registry/aws"
}

output "rest_api_id" {
  value = module.tfreg.rest_api_id
}

output "services" {
  value = module.tfreg.services
}