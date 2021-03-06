# root / variables
## Global Variables
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "region" {}
## Compartment
variable "compartment_ocid" {}

# root module variables
variable "vcn_cidr" { type = "string" default = "10.0.1.0/24" }
variable "bastion_subnet_cidr" { type = "string" default = "10.0.1.0/27" }
variable "workers_subnet_cidr" { type = "string" default = "10.0.1.160/27" }
variable "control_subnet_cidr" { type = "string" default = "10.0.1.128/27" }
