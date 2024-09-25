resource "aws_subnet" "my-app-subnet"{
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avil_zone
    tags = {
        Name = "${var.env}-subnet"
    }
}
resource "aws_route_table" "my-app-rtb"{
    vpc_id = var.vpc_id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.my-app-igw.id
    }
    tags= {
        Name = "${var.env}-rtb"
    }
}
resource "aws_internet_gateway" "my-app-igw" {
    vpc_id = var.vpc_id
    tags ={
        Name = "${var.env}-igw"
    }
}


resource "aws_route_table_association" "rtb-subnet-association" {
    subnet_id=aws_subnet.my-app-subnet.id
    route_table_id=aws_route_table.my-app-rtb.id
}