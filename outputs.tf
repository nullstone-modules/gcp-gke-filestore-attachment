locals {
  env = length(var.mount_path_env_var) > 0 ? [{ name = var.mount_path_env_var, value = var.mount_path }] : []
}

output "env" {
  value = local.env
}

output "volumes" {
  value = [
    {
      name = local.volume_name
      persistent_volume_claim = jsonencode({
        claim_name = local.volume_claim_name
      })
    }
  ]
}

output "volume_mounts" {
  value = [
    {
      name       = local.volume_name
      mount_path = var.mount_path
    }
  ]
}
