module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  cidr_block   = "10.0.0.0/16"
}


module "subnets" {
    source = "./modules/subnets"
    vpc_id = module.vpc.vpc_id
    project_name = var.project_name
    region = var.aws_region
    
    azs = [
        "us-east-1a",
        "us-east-1b"
    ]

}
