module "jenkinsapp" {
  # module source
  source = "./modules/jenkins-app"

  # Amazon VPC ID
  vpc_id = "YOUR_VPC_ID"

  # Amazon subnet ip range
  subnet_cidr = "YOUR_SUBNET_IP_RANGE"

  # SSH Key to access machines
  ssh_key = "public_key"

  # jenkinsapp machine name
  app_name = "jenkins"

  # Resource tags
  app_tags = {
    env      = "prod"
    project  = "Jenkins"
    customer = "Valdir Bitar"
    curso    = "CL0506"
  }

  # App Instance type
  app_instance = "t2.small"

}

resource "null_resource" "getJenkinsPwd" {
  triggers = {
    instance = module.jenkinsapp.jenkins-ec2
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/modules/jenkins-app/files/jenkins.pem")
    host        = module.jenkinsapp.jenkins-ec2
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 300",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }
}

output "jenkins-ip" {
  value = module.jenkinsapp.jenkins-ec2
}