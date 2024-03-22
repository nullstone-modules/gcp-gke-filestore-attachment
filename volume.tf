locals {
  storage           = "${local.filestore_capacity}Gi"
  volume_name       = local.filestore_name
  volume_claim_name = "pvc-${local.filestore_name}"
  volume_handle     = "modeInstance/${local.filestore_location}/${local.filestore_name}/${local.filestore_share_name}"
}

resource "kubernetes_persistent_volume_v1" "this" {
  metadata {
    // cluster-wide resource
    name = local.volume_name
  }

  spec {
    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    volume_mode                      = "Filesystem"

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
    namespace = local.kubernetes_namespace
    name      = local.volume_claim_name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    volume_name  = local.volume_name

    resources {
      requests = {
        storage = local.storage
      }
    }
  }
}
