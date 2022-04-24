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


variable "cpu" {
  default     = 1024
  type        = number
  description = "Number of cpu units used by the task"
}

variable "ecs_cluster" {
  default     = null
  description = "ECS Cluster name to deploy the service"
}

variable "environment" {
  default     = "production"
  description = "Environment for deployment"
}

variable "owner" {
  default     = "Suren Raju"
  description = "Owner for the AWS resources"
}

variable "health_check_path" {
  default     = ""
  description = "Service health endpoint to check"
}


variable "memory" {
  default     = 2048
  type        = number
  description = "Amount (in MiB) of memory used by the task"
}

variable "port" {
  default     = 8080
  type        = number
  description = "Port the application runs on"
}

variable "project" {
  default     = ""
  description = "Project, aka the application name"
}

variable "region" {
  default     = ""
  description = "AWS region for resources"
}

variable "replicas" {
  default     = "1"
  description = "Number of containers (instances) to run"
}

variable "vpc_id" {
  default     = ""
  description = "VPC ID to use for the resources"
}

variable "task_iam_policy" {
  default     = ""
  description = "Policy document for ecs task"
}

variable "app_definitions" {
  default     = ""
  description = "Map of environment variables for the application"
}

variable "deployment_maximum_percent" {
  default     = "200"
  description = "Max percentage of the service's desired count during deployment"
}

variable "deployment_minimum_healthy_percent" {
  default     = "100"
  description = "Min percentage of the service's desired count during deployment"
}

variable "health_check_grace_period_seconds" {
  default     = "120"
  description = "Seconds to ignore failing load balancer health checks on new tasks"
}

variable "platform_version" {
  default     = "1.4.0"
  description = "Platform version on which to run your service."
}
