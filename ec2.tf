resource "aws_instance" "ec2" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name      = "pritam"
  associate_public_ip_address = true 
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = <<EOF
#!/bin/bash
sudo yum update 
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
  EOF
  tags = {
    Name = "cdecb5-ec2"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "cdecb5-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cdecb5-sg"
  }
}