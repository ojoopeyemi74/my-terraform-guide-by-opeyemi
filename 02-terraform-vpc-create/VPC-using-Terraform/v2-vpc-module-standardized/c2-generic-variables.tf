# Input Variables

# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

# Enviroment variable
variable "enviroment" {
  description = "Enviroment Variable used as a prefix"
  type = string
  default = "dev"
}


# Business Division 
variable "business_division" {
  description = "Business Division in the large organization "
  type = string
  default = "HR"
}


