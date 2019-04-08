# workers / compute.tf
resource "oci_core_instance" "worker1_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "worker-1-vm"
  availability_domain = "${var.ads[1]}"
  source_details {
    source_id = "${var.image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.workers_net.id}"
    assign_public_ip = false
    hostname_label = "w1"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
    user_data = "${base64encode(file("workers/cloud-init/worker.config.yaml"))}"
  }
}
resource "oci_core_instance" "worker2_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "worker-2-vm"
  availability_domain = "${var.ads[2]}"
  source_details {
    source_id = "${var.image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.workers_net.id}"
    assign_public_ip = false
    hostname_label = "w2"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
    user_data = "${base64encode(file("workers/cloud-init/worker.config.yaml"))}"
  }
}
output "worker_private_ips" { value = [ "${oci_core_instance.worker1_vm.private_ip}", "${oci_core_instance.worker2_vm.private_ip}" ] }
