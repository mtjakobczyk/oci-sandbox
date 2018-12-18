# vars.tf
## Input Variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "region" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "private_key_password" {}
variable "compartment_ocid" {}

variable "instance_pool_target_size" { default = 2 }
