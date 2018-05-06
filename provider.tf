# Configure the Azure Provider
provider "azurerm" { }

provider "consul" {
  address    = "localhost:8500"
  datacenter = "nyc1"
}