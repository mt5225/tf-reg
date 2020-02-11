variable "env_tag_map" {
  type = map(string)

  default = {
    prod = "production"
    stag = "staging"
    qa   = "qa"
    dev  = "dev"
    dr   = "dr"
  }
}

variable "account" {
  description = "name of the aws account"
}

variable "created_by" {
  description = "who created me?"
  default     = "terraform"
}

variable "environment" {
  description = "environment name containing products-environment-region"
}

variable "product" {
  description = "the product"
}

variable "vpc_id" {
  description = "vpc id"
}