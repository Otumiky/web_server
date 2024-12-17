resource "aws_instance" "example" {
  ami                         = "ami-0b0ea68c435eb488d"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.instance.id]
  user_data                   = <<-EOF
                #!/bin/bash
                   echo "Hello, World" > index.html
                   nohup busybox httpd -f -p ${var.server_port} &
                   EOF
  user_data_replace_on_change = true


  tags = {
    Name = "terraform-example"
  }
}


resource "aws_security_group" "instance" {
  name = var.instance_name

  ingress {

    to_port   = var.server_port
    from_port = var.server_port

  }
}
