resource "null_resource" "ansible_init" {
  count = "${var.count}"
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join(",", azurerm_virtual_machine.avm.*.id)}"
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
      type     = "ssh"
      host     = "${element(azurerm_public_ip.api.*.ip_address, count.index)}"
      user     = "${var.system_user}"
      password = "${var.system_password}"
  }
  
  provisioner "file" {
      source = "${path.module}/files/requirements.txt"
      destination = "/tmp/requirements.txt"
  }

  provisioner "remote-exec" {
      inline = [
          "sudo apt-get update",
          "sudo apt-get install -y python-pip",
          "sudo pip install -r /tmp/requirements.txt"
      ]
  }
}