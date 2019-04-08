# control-plane / compute.tf
resource "oci_core_instance" "master_1_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "master-1-vm"
  availability_domain = "${var.ads[1]}"
  source_details {
    source_id = "${var.image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.cplane_net.id}"
    assign_public_ip = false
    hostname_label = "master-1"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
    user_data = "${base64encode(file("control-plane/cloud-init/master.config.yaml"))}"
  }
}
output "cplane_private_ips" { value = [ "${oci_core_instance.master_1_vm.private_ip}" ] }
