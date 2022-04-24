module "ecs" {
   source                  = "./ecs"
   environment          = var.environment
   project              = var.project
   region               = var.region
   app_definitions      = local.app_definitions
   health_check_path    = "/"
   vpc_cidr             = var.vpc_cidr
   public_subnet_1_cidr = var.public_subnet_1_cidr
   public_subnet_2_cidr = var.public_subnet_2_cidr
   public_subnet_3_cidr = var.public_subnet_3_cidr
 }