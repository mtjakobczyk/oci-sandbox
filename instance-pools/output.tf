####### BASTION
data "oci_core_instance" "bastion" {
  instance_id = "${oci_core_instance.bastion_vm.id}"
}
output "Bastion host public IP" { value = "${data.oci_core_instance.bastion.public_ip}" }

####### POOLED INSTANCES
data "oci_core_instance_pool_instances" "instances" {
  compartment_id = "${var.compartment_ocid}"
  instance_pool_id = "${oci_core_instance_pool.instance_pool.id}"
}

### 1 - Working Solution that DOES NOT scale
data "oci_core_instance" "instance1" {
  instance_id = "${data.oci_core_instance_pool_instances.instances.instances.0.id}"
}
data "oci_core_instance" "instance2" {
  instance_id = "${data.oci_core_instance_pool_instances.instances.instances.1.id}"
}
output "Pooled instances private IPs" { value = [ "${data.oci_core_instance.instance1.private_ip}", "${data.oci_core_instance.instance2.private_ip}" ] }

### 2 - Expected solution that WOULD scale
#data "oci_core_instance" "instance" {
#  count = "${oci_core_instance_pool.instance_pool.size}"
#  instance_id = "${data.oci_core_instance_pool_instances.instances.instances.*.id}"
#}
#output "Pooled instances private IPs" { value = [ "${data.oci_core_instance.instance.*.private_ip}" ] }

## Errors:
#Error: Error refreshing state: 1 error(s) occurred:
#* data.oci_core_instance.instance: 2 error(s) occurred:
#* data.oci_core_instance.instance[0]: data.oci_core_instance.instance.0: Service error:InvalidParameter. AvailabilityDomain could not be inferred from the Request. http status code: 400.
#* data.oci_core_instance.instance[1]: data.oci_core_instance.instance.1: Service error:InvalidParameter. AvailabilityDomain could not be inferred from the Request. http status code: 400.
