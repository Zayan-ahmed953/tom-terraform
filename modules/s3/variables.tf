variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
}

variable "force_destroy" {
  description = "Delete all objects when destroying the bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the bucket."
  type        = map(string)
  default     = {}
}
