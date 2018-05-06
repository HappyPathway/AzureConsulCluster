resource "null_resource" "datadog" {
  
  count = "${var.datadog_monitor ? var.count : 0}"
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

  provisioner "file" {
      source = "${path.module}/playbooks"
      destination = "/tmp/playbooks"
  }

  provisioner "remote-exec" {
      inline = [
          "sudo apt-get update",
          "sudo apt-get install -y python-pip",
          "sudo pip install -r /tmp/requirements.txt"
      ]
  }

  provisioner "remote-exec" {
    inline = [
      "curl ${var.ddog_install_script} | sudo DD_API_KEY=${var.datadog_key} bash",
      "sudo ansible-playbook /tmp/playbooks/datadog_agent.yaml -e datadog_api_key=${var.datadog_key} -e service_name=${var.service_name}",
      "rm -rf /tmp/playbooks"
    ]
  }
}