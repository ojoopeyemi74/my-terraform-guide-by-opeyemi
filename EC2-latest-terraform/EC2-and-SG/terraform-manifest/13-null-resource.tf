# Create a Null Resource and Provisioners
resource "null_resource" "name" {
    depends_on = [
      module.bastion-ec2-instance # we need the bastion ec2 host to be created first
    ]

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    user     = "ec2-user"
    host     = aws_eip.eip-bastion-public-instance.public_ip
    private_key = file("${path.module}//private-key/terraform-key.pem")

  }
## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "${path.module}/private-key/terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }

## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
 provisioner "remote-exec" {
    inline = [
      "chmod 400 /tmp/terraform-key.pem"
    ]
  }

## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)

 ## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue




  }

## Local Exec Provisioner:  local-exec provisioner (Detroy -Time Provisioner - Triggered during destroying Resource)
/*
 provisioner "local-exec" {
    command = "echo destroy time  prov 'date' >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }
*/
  # Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)
}






