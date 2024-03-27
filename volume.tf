locals {
  storage           = "${local.filestore_capacity}Gi"
  volume_name       = "${local.filestore_name}-${random_string.resource_suffix.result}"
  volume_handle     = "modeInstance/${local.filestore_location}/${local.filestore_name}/${local.filestore_share_name}"
  volume_claim_name = kubernetes_persistent_volume_claim_v1.this.metadata[0].name

  // We enabled the filestore CSI driver on our GKE cluster
  // This automatically installs 5 storage classes:
  // - enterprise-multishare-rwx
  // - enterprise-rwx
  // - premium-rwx
  // - standard-rwx
  // - zonal-rwx
  // Based on the filestore's storage tier, we're going to try to choose the appropriate storage class
  // If we don't find one, we fall back to "standard-rwx"
  storage_tier_to_class = tomap({
    "STANDARD" : "standard-rwx",
    "PREMIUM" : "premium-rwx",
    "BASIC_HDD" : "standard-rwx",
    "BASIC_SSD" : "standard-rwx",
    "HIGH_SCALE_SSD" : "premium-rwx",
    "ZONAL" : "zonal-rwx",
    "REGIONAL" : "zonal-rwx",
    "ENTERPRISE" : "enterprise-rwx",
  })
  storage_class = coalesce(local.storage_tier_to_class[local.filestore_tier], "standard-rwx")
}

resource "kubernetes_persistent_volume_v1" "this" {
  metadata {
    // cluster-wide resource
    name   = local.volume_name
    labels = local.labels
  }

  spec {
    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    volume_mode                      = "Filesystem"
    storage_class_name               = local.storage_class

    capacity = {
      storage = local.storage
    }

    persistent_volume_source {
      csi {
        driver        = "filestore.csi.storage.gke.io"
        volume_handle = local.volume_handle
        volume_attributes = {
          ip     = local.filetore_ips[0]
          volume = local.filestore_share_name
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "this" {
  metadata {
    namespace     = local.kubernetes_namespace
    generate_name = "${local.filestore_name}-"
    labels        = local.labels
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    volume_name        = local.volume_name
    storage_class_name = local.storage_class

    resources {
      requests = {
        storage = local.storage
      }
    }
  }
}
