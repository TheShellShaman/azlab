variable "location" {
  type = string
}

variable "resourcegroup" {
  type = string
}

variable "storageaccount" {
  type = string
  default = "jacobsazlabstorage2"
}

variable "production-subnet" {
  type = string
}

variable "appservice_subnet" {
  type = string 
}