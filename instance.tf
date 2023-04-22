data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


}


resource "aws_instance" "s1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf-key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "server1"
  }
  user_data = file("${path.module}/script.sh")
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "readme.md"
    destination = "/tmp/readme.md"
  }
  provisioner "file" {
    content     = "This is my content"
    destination = "/tmp/content.md"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'at delete' "
  }

  provisioner "remote-exec" {
    inline = [
      "ifconfig > /tmp/ifconfig.output",
      "echo 'hello vivek' > /tmp/test.txt"
    ]
  }

  provisioner "remote-exec" {
    script = "./testscript.sh"

  }

}
