variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_pair_name" {
  type    = string
  default = "terraform-key"
}

/*
# AWS ec2 Private instance count
variable "private_instance_count" {
  description = "AWS ec2 Private Instance Count"
  type        = number
  default     = 1
}
*/