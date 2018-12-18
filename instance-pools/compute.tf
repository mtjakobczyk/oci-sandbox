# bastion
resource "oci_core_instance" "bastion_vm" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "bastion-vm"
  availability_domain = "${local.ads[0]}"
  source_details {
    source_id = "${local.oracle_linux_image_ocid}"
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id = "${oci_core_subnet.bastion_ad1_net.id}"
    assign_public_ip = true
  }
  metadata {
    ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
  }
}
# private instance pool
resource "oci_core_instance_configuration" "instance_config" {
  compartment_id = "${var.compartment_ocid}"
  instance_details {
    instance_type = "compute"
    launch_details {
      compartment_id = "${var.compartment_ocid}"
      create_vnic_details {
        assign_public_ip = "false"
      }
      metadata {
        ssh_authorized_keys = "${file("~/.ssh/oci_id_rsa.pub")}"
      }
      shape = "VM.Standard2.1"
      source_details {
        source_type = "image"
        image_id = "${local.oracle_linux_image_ocid}"
      }
    }
  }
  display_name = "instance-config"
}

resource "oci_core_instance_pool" "instance_pool" {
  compartment_id = "${var.compartment_ocid}"
  instance_configuration_id = "${oci_core_instance_configuration.instance_config.id}"
  placement_configurations = [
    {
      availability_domain = "${local.ads[0]}"
      primary_subnet_id = "${oci_core_subnet.private_ad1_net.id}"
    },
    {
      availability_domain = "${local.ads[1]}"
      primary_subnet_id = "${oci_core_subnet.private_ad2_net.id}"
    }
  ]
  size = "${var.instance_pool_target_size}"
  display_name = "instance-pool"
}
