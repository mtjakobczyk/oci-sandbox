# vars.tf
## Input Variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "region" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "private_key_password" {}
variable "compartment_ocid" {}

variable "instance_pool_target_size" { default = 0 }

### DO NOT CHANGE BELOW THIS LINE
# This is a feature gap workaround for Terraform 0.11.x missing null evaluation for data source
# Never set this variable for "apply" command
# You can use it only with "refresh" command like this:
# terraform refresh -var 'outputPoolIPs=true'
variable "outputPoolIPs" { default = false }
# This workaround will be removed in CY19Q1 as soon as Terraform 0.12 is released
