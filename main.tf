provider "aws" {
    region = "us-east-1"
    
}
terraform{
    backend "s3" {
        bucket = "my-app-004014397957"
        key="myapp-state/terraform.tfstate"
        region="us-east-1"

    }
    
}
resource "aws_vpc" "my-vpc"{  #dah name 5as bel terraform 3alashan 2ader 23mlo referecing wana b3mel subnets
    #cidr_block = var.cidr_blocks[0].cidr_block han5li el modo3 2shel
    cidr_block = var.vpc_cidr_block
    tags = { #dah el name eli hayzhar fel vpc 
        Name = "${var.env}-vpc"
    }
}
# variables b7otha inputs to modules
 module "myapp-subnet" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.my-vpc.id 
    subnet_cidr_block = var.subnet_cidr_block
    avil_zone = var.avil_zone
    env = var.env   #var.env_aws_vpc.myapperfix
 }

 module "myapp-server" {
    source = "./modules/server"
    vpc_id = aws_vpc.my-vpc.id 
    my_ip = var.my_ip
    avil_zone = var.avil_zone
    env = var.env
    subnet_id = module.myapp-subnet.subnet-details.id
    instance_type =var.instance_type
    public_key_location = var.public_key_location
 }
# resource "aws_default_route_table" "main_rtb"{
#    default_route_table_id = aws_vpc.my-vpc.default_route_table_id
#    route {
#         cidr_block="0.0.0.0/0"
#         gateway_id=aws_internet_gateway.my-app-igw.id
#      }
#    tags= {
#         Name = "${var.env}-main-rtb"
#     }

# }


