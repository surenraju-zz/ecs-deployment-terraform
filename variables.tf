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

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
}

variable "public_subnet_3_cidr" {
  description = "CIDR Block for Public Subnet 3"
}


variable "nifi_admin_username" {
  default     = "admin"
  description = "NIFI admin username"
}

variable "nifi_admin_password" {
  default     = "secret"
  description = "NIFI admin password"
}

