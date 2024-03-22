variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "mount_path" {
  type        = string
  description = <<EOF
Mount path identifies the location in the application to mount the filesystem.
EOF
}

variable "mount_path_env_var" {
  type        = string
  description = <<EOF
Mount path env name defines the name of the environment variable to inject the mount path directory to the application.
If left blank, this will not inject any environment variables.
EOF
  default     = ""
}
