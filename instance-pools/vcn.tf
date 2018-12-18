resource "oci_core_virtual_network" "solution_vcn" {
  compartment_id = "${var.compartment_ocid}"
  cidr_block = "10.1.0.0/16"
  display_name = "solution-vcn"
  dns_label = "vcn"
}
resource "oci_core_internet_gateway" "solution_igw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
}
resource "oci_core_nat_gateway" "solution_ngw" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  display_name = "solution-ngw"
}
### PRIVATE SUBNETS
resource "oci_core_route_table" "private_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  route_rules {
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_nat_gateway.solution_ngw.id}"
  }
  display_name = "private-rt"
}
resource "oci_core_security_list" "private_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  egress_security_rules = [
    { stateless="true" destination="10.1.0.0/16" protocol="all" },
    { stateless="false" destination="0.0.0.0/0" protocol="all" }
  ]
  ingress_security_rules = [
    { stateless="true" source="10.1.0.0/16" protocol="6" tcp_options { min=22 max=22 } }
  ]
  display_name = "private-sl"
}
resource "oci_core_subnet" "private_ad1_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  display_name = "private-ad1-net"
  availability_domain = "${local.ads[0]}"
  cidr_block = "10.1.30.0/24"
  route_table_id = "${oci_core_route_table.private_rt.id}"
  security_list_ids = [ "${oci_core_security_list.private_sl.id}" ]
  dhcp_options_id = "${oci_core_virtual_network.solution_vcn.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
  dns_label = "private1"
}
resource "oci_core_subnet" "private_ad2_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  display_name = "private-ad2-net"
  availability_domain = "${local.ads[1]}"
  cidr_block = "10.1.31.0/24"
  route_table_id = "${oci_core_route_table.private_rt.id}"
  security_list_ids = [ "${oci_core_security_list.private_sl.id}" ]
  dhcp_options_id = "${oci_core_virtual_network.solution_vcn.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "true"
  dns_label = "private2"
}
### PUBLIC BASTION SUBNET
resource "oci_core_route_table" "bastion_rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  route_rules {
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.solution_igw.id}"
  }
  display_name = "bastion-rt"
}
resource "oci_core_security_list" "bastion_sl" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  egress_security_rules = [
    { stateless="true" destination="10.1.0.0/16" protocol="all" },
    { stateless="false" destination="0.0.0.0/0" protocol="all" }
  ]
  ingress_security_rules = [
    { stateless="true" source="10.1.0.0/16" protocol="all" },
    { stateless="false" source="0.0.0.0/0" protocol="6" tcp_options { min=22 max=22 } }
  ]
  display_name = "bastion-sl"
}
resource "oci_core_subnet" "bastion_ad1_net" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.solution_vcn.id}"
  display_name = "bastion-ad1-net"
  availability_domain = "${local.ads[0]}"
  cidr_block = "10.1.1.0/24"
  route_table_id = "${oci_core_route_table.bastion_rt.id}"
  security_list_ids = [ "${oci_core_security_list.bastion_sl.id}" ]
  dhcp_options_id = "${oci_core_virtual_network.solution_vcn.default_dhcp_options_id}"
  prohibit_public_ip_on_vnic = "false"
  dns_label = "bastion1"
}
