variable "csv_input_file_name" {}
# variable "subnetwork" {}
# variable "os_image" {}
# variable "machine_type_size" {
#     type = map
# default = {
#     small   = "n1-standard-1"
#     medium  = "n1-standard-1"
#     large   = "n1-standard-1"
#     }
#   }
# variable "instance_type_size" {
#     type = map
# default = {
#     hana   ="centos-7"
#     sql    ="windows-2016"
#     app    ="windows-2016"
#     }
#   }

variable "subnetwork" {
    type = map
default = {
    x2q_app   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-qa-n-app-nl2018"
    x2q_hana  ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-qa-n-hana-db-nl2018"
    x2q_sql   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-qa-n-sql-db-nl2018"
    x2d_app   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-app-nl2018"
    x2d_hana  ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-hana-db-nl2018"
    x2d_sql   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-sql-db-nl2018"
    x2s_app   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-app-nl2018"
    x2s_hana  ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-hana-db-nl2018"
    x2s_sql   ="projects/slb-it-infrastructure-01/regions/europe-west4/subnetworks/subnet01-ite-sap-dev-sbx-n-sql-db-nl2018"
    }
  }
variable "secondary_ip" {
    type = list(string)
    default = []
}
variable "alias_ip" {
   type = list(string)
      default = ["yes"]
   }
  variable "sole_tenant" {
    type = list(string)
    default = []
  }
variable "os_image" {
    type = map
    default = {
        windows2016 = "projects/b95696467908/global/images/family/slb-sap-windows2016-byol-app"
        windows2012 = "projects/b95696467908/global/images/family/slb-sap-windows2016-byol-app"
        sles12sp4   = "projects/b95696467908/global/images/sles12sp4-std-byol-slb-image-01202021-v6"
    }
  }
variable "os_tag" {
    type        = list(string)
    default = []
}
variable "metadata" {
    type =string
    default = ""
}
#   variable "on_host_maintenance" {
#       default = ["yes"]
#   }
#   variable "scheduling_a" {
#       type = object({
#          on_host_maintenance = list(string)   
#       })
#       default = "MIGRATE"
#   } 
variable "st_key" {
    type = string
    default = ""
}
variable "st_values" {
    type = list(string)
    default = []
}
variable "scopes" {
    type = list(string)
    default = ["compute-ro", "storage-rw", "service-management", "monitoring-write", "logging-write", "service-control", "https://www.googleapis.com/auth/trace.append" ]
}