# workers / compute.tf
variable "instance_ads" {
  default = {
    "0" = "1"
    "1" = "2"
  }
}
resource "oci_core_instance" "worker_vm" {
  count = 2
  compartment_id = "${var.compartment_ocid}"
  display_name = "worker-${count.index + 1}-vm"
  availability_domain = "${var.ads[lookup(var.instance_ads, count.index)]}"
  source_details {
    source_id = "${var.image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.workers_net.id}"
    assign_public_ip = false
    hostname_label = "w${count.index + 1}"
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
    user_data = "${base64encode(file("workers/cloud-init/worker.config.yaml"))}"
  }
}
output "worker_private_ips" { value = [ "${oci_core_instance.worker_vm.*.private_ip}" ] }
