locals {
  instances = "${csvdecode(file(var.csv_input_file_name))}"
  # temp = ["temp"]
}
resource "google_compute_address" "internal_with_subnet_and_address" {
  for_each      = { for inst in local.instances : inst.gcp_vm_name => inst }
    name         = "${each.value.gcp_vm_name}-ip01"
    # subnetwork   = var.subnetwork
      subnetwork   = lookup(var.subnetwork, each.value.gcp_tier_app)
    address_type = "INTERNAL"
    address      = each.value.gcp_vm_phy_ip
    region       = each.value.gcp_region
}

resource "google_compute_instance" "instancecreationcsv" {
  for_each      = { for inst in local.instances : inst.gcp_vm_name => inst }
  name          = each.value.gcp_vm_name
  # machine_type  = "${lookup(var.machine_type_size, each.value.machine_type)}"
  # machine_type  = each.value.gcp_vm_machine_type
  description = each.value.gcp_desc
  machine_type    = each.value.gcp_vm_machine_type
  zone          = each.value.gcp_zone
  tags= var.os_tag
  allow_stopping_for_update = false
  desired_status = each.value.gcp_vm_state
  deletion_protection = each.value.gcp_vm_protection
  boot_disk {
    initialize_params {
      # image  = var.os_image
      # image = var.os_image
      image = lookup(var.os_image, each.value.gcp_os_image)
    }
    # auto_delete = each.value.auto_delete
  }
dynamic "scheduling" {
  for_each = var.sole_tenant
  content {
    node_affinities {
      # key = "os_type"
      key = var.st_key
      operator = "IN"
      values = var.st_values
      # values = [ "slb_windows" ]
    }
  }
}
  network_interface {
    # subnetwork = var.subnetwork
  #  subnetwork =  lookup(var.subnetwork, "${each.value.gcp_tier}-${each.value.gcp_vm_type}")
  subnetwork =  lookup(var.subnetwork, each.value.gcp_tier_app)
    network_ip = each.value.gcp_vm_phy_ip
  #  network_ip = google_compute_address.internal_with_subnet_and_address[a]
    dynamic "alias_ip_range" {
      # for_each = var.secondary_ip
      #  for_each = each.value.gcp_vm_lgl_ip[*]
      for_each =  each.value.gcp_vm_lgl_ip == "na" ? var.secondary_ip : var.alias_ip 
      content {
       ip_cidr_range = "${each.value.gcp_vm_lgl_ip}/32"
       subnetwork_range_name = "sec-1"
      }
    }
  }
  lifecycle {
    ignore_changes = [attached_disk, boot_disk.0.initialize_params.0.image, metadata ]
  }
  # dynamic "scheduling" {
  #   for_each = var.on_host_maintenance
  #   content {
  #   on_host_maintenance = "MIGRATE"
  #   }
  # }
  labels = {
    region      = each.value.gcp_region
    logicalname = each.value.gcp_logicalname
    creator     = each.value.gcp_creator
    clustervm   = each.value.gcp_clustervm
    os          = each.value.gcp_os_image
    server_type = each.value.gcp_vm_type
    sid         = each.value.gcp_sid
    tier        = each.value.gcp_tier
    serverstatus = each.value.gcp_serverstatus
  }
  # metadata_startup_script = "echo ${each.value.gcp_sid} >> C:\\abc.txt" 
  metadata = {
    # windows-startup-script-ps1 = "echo ${each.value.gcp_vm_name} >> c:\\input.txt ; echo ${each.value.gcp_vm_lgl_ip} >> c:\\input.txt ; echo ${each.value.gcp_sid} >> c:\\input.txt"
    windows-startup-script-ps1 = ( var.metadata == "yes" ? "echo ${each.value.gcp_vm_name} >> c:\\input.txt ; echo ${each.value.gcp_vm_lgl_ip} >> c:\\input.txt ; echo ${each.value.gcp_sid} >> c:\\input.txt ; echo hi >>c:\\input.txt" : "" )
    # sysprep-specialize-script-cmd = ( var.metadata == "yes" ? "echo ${each.value.gcp_vm_name} >> c:\\input.txt ; echo ${each.value.gcp_vm_lgl_ip} >> c:\\input.txt ; echo ${each.value.gcp_sid} >> c:\\input.txt" : "" )
  }

  # dynamic "metadata"  {
  #   for_each = var.sole_tenant
  #   content {
  #     windows-startup-script-ps1 = "echo ${each.value.gcp_vm_name} >> c:\\abc.txt ; echo ${each.value.gcp_vm_lgl_ip} >> c:\\abc.txt ; echo ${each.value.gcp_sid} >> c:\\abc.txt"
  #   }
  # }

  service_account {
    scopes = var.scopes
  }
}  



output "metadata" {
  value = var.metadata
}
output "sole_tenant" {
  value = var.sole_tenant
}