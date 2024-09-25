#security group
resource "aws_security_group" "myapp-sg"{
    name ="my-app-sg"
    vpc_id=var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol="tcp"
        cidr_blocks=[var.my_ip] #keda el ip bta3i bas eli y2dr ywsl llport 22 ana bas eli 2dr 23ml ssh 3ala el server
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"] #laken hena 2i 7ad fel donia y2dr ywsl to server 3ala elport 8080
    }
    egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        prefix_list_ids=[]
    }
   tags= {
        Name = "${var.env}-my-app-sg"
    } 
}

#fetch the ami
data "aws_ami" "amazon-linux-image"{
    most_recent= true    #btgeb 25er 7aga 20 25er version
    #b filter bel owners 3alashan 2t2ked 2nha bta3et amazon
    owners= ["amazon"]
    #filter 3alashan 2geb image mo3ina
    filter {
        name= "name"   #key hndor bel name el ami name
        values =["amzn2-ami-*x86_64-gp2"]  #2i 7aga mn kmtha tdlna 3aliha w 7na 25trna to filter by name * ya3ni 2i 7aga fel nos

    }
    #zyada t2keed fa b3mel filter bel virtulization type
    filter {
        name= "virtualization-type"
        values =["hvm"]

    }
}

#creating ec2
resource "aws_instance" "myapp-server"{
    ami=data.aws_ami.amazon-linux-image.id #hatgeb value of ami mn el data keda el ec2 bta3i hytcreate fi 2i region y2dr ywsl lami bdon mshakel
    instance_type= var.instance_type #ec2 btkon sizes b5tar binhom el free t2.micro han3mlo var 3alashan lo 7ad 3ayz y2om ec2 bsize tani
    #subnet_id= aws_subnet.my-app-subnet.id #ha2om el ec2 fi 2nhi subnet
    subnet_id=var.subnet_id
    vpc_security_group_ids= [aws_security_group.myapp-sg.id] #sg eli 3ala ec2 ha3mlha 3ala shakl list l2nha aktr mn id l2n momken akt mn sg
    availability_zone= var.avil_zone
    associate_public_ip_address= true #3lashan at2ked 2n el e2 hya5od public ip 2ol may2om k2ni 3mlto enable 3alashan el nas t2dr access 3alih
    key_name =aws_key_pair.ssh-key.key_name
    user_data = file("userdata.sh")
    tags= {
        Name = "${var.env}-server"
    } 
    # connection {
    #     type = "ssh" #terraform ssh
    #     host = self.public_ip #ip of ec2 
    #     user = "ec2-user"#user eli had5l bih w el keys eli ssh biha
    #     private_key = file(var.private_key_location)
    # }
    # #terraform after creating ec2 hia t3mel ssh 3alih w tnfz commands
    # provisioners "remote_exec" {
    #     # inline = [
    #     #     "mkdir reham" ,
    #     #     "touch txt"
    #     # ]
    #     script = file("userdata.sh") #to run this script lazem ykon mogod 3la remote server
    # }
    # #flazem ykon fi 7aga btodi el file dah ll remote 3ala shan 2st5dem script
    # provisioners "file" {
    #     source = 
    #     destination = #pass of file in local machine

    # }
}
 resource "aws_key_pair" "ssh-key"{
    key_name= "myapp-key"
    public_key =file(var.public_key_location) 
    
 }
   