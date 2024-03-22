data "ns_connection" "filestore" {
  name     = "filestore"
  contract = "datastore/gcp/filestore"
}

locals {
  filestore_name       = data.ns_connection.filestore.outputs.filestore_name
  filestore_tier       = data.ns_connection.filestore.outputs.filestore_tier
  filestore_location   = data.ns_connection.filestore.outputs.filestore_location
  filestore_capacity   = data.ns_connection.filestore.outputs.filestore_capacity
  filetore_ips         = data.ns_connection.filestore.outputs.filestore_ips
  filestore_share_name = data.ns_connection.filestore.outputs.filestore_share_name
}
