data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
locals {
  ads = [
    "${lookup(data.oci_identity_availability_domains.ads.availability_domains[0], "name")}",
    "${lookup(data.oci_identity_availability_domains.ads.availability_domains[1], "name")}",
    "${lookup(data.oci_identity_availability_domains.ads.availability_domains[2], "name")}"
  ]
}
data "oci_core_images" "oracle_linux_image" {
  compartment_id = "${var.tenancy_ocid}"
  display_name = "Oracle-Linux-7.6-2018.11.19-0"
}
locals  {
  oracle_linux_image_ocid = "${data.oci_core_images.oracle_linux_image.images.0.id}"
}
