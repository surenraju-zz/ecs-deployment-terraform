module "ecs" {
   source                  = "./ecs"
   environment          = var.environment
   project              = var.project
   region               = var.region
   app_definitions      = local.app_definitions
   health_check_path    = "/"
   vpc_cidr              = "10.0.0.0/16"
   public_subnet_1_cidr  = "10.0.16.0/20"
   public_subnet_2_cidr  = "10.0.32.0/20"
   public_subnet_3_cidr  = "10.0.48.0/20"
   private_subnet_1_cidr = "10.0.64.0/20"
   private_subnet_2_cidr = "10.0.80.0/20"
   private_subnet_3_cidr = "10.0.96.0/20"
 }