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
data "oci_core_instance" "instance" {
  count = "2"
  instance_id = "${lookup(data.oci_core_instance_pool_instances.instances.instances[count.index], "id")}"
}
output "Pooled instances private IPs" { value = [ "${data.oci_core_instance.instance.*.private_ip}" ] }
