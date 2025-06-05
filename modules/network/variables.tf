variable "location" {
  type = string
}   

variable "resourcegroup" {
  type = string
}

variable "production-vnet" {
  type = string
  default = "production-vnet"
}

variable "production-subnet" {
  type = string
  default = "prodcution-subnet"
}