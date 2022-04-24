variable "region" {
  default     = "me-south-1"
  description = "AWS Region"
}

variable "project" {
    default = "data-platform"
    description = "Project name"
}

variable "environment" {
    default = "production"
    description = "Environment"
}

variable "owner" {
    default = "Suren Raju"
    description = "Owner of the AWS resources"
}