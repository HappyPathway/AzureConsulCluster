resource "azurerm_network_security_group" "ssh" {
    name                = "${var.service_name}-sg"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        service = "${var.service_name}"
        environment = "${var.env}"
    }
}

resource "azurerm_network_security_group" "consul" {
    name                = "${var.service_name}-sg"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8300-8600"
        source_address_prefix      = "${var.consul_access}"
        destination_address_prefix = "*"
    }

    tags {
        service = "${var.service_name}"
        environment = "${var.env}"
    }
}