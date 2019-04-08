# control-plane / vcn.tf
resource "oci_core_route_table" "cplane_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  route_rules {
    network_entity_id = "${var.vcn_nat_ocid}"
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
  }
  display_name = "control-plane-rt"
}
resource "oci_core_security_list" "cplane_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  egress_security_rules = [
    { stateless="true" destination="${var.vcn_cidr}" protocol="all" },
    { stateless="false" destination="0.0.0.0/0" protocol="all" }
  ]
  ingress_security_rules = [
    { stateless="true" source="${var.vcn_cidr}" protocol="all" }
  ]
  display_name = "control-plane-sl"
}
resource "oci_core_subnet" "cplane_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${var.vcn_ocid}"
  display_name = "control-plane-net"
#  availability_domain = "${var.ads[1]}" # REGIONAL will be used
  cidr_block = "${var.vcn_subnet_cidr}"
  route_table_id = "${oci_core_route_table.cplane_rt.id}"
  security_list_ids = [ "${oci_core_security_list.cplane_sl.id}" ]
  prohibit_public_ip_on_vnic = "true"
  dns_label = "master"
}
