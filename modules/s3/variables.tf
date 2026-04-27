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

variable "iam_user_arn" {
  description = "ARN of the IAM user to grant S3 access via bucket policy. No policy is created if empty."
  type        = string
  default     = ""
}
