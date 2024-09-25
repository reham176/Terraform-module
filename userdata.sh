
#!/bin/bash
sudo yum update -y 
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker ec2-user
docker run -d -p 8080:80 nginx
sleep 30
                