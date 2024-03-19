variable "awsRegion" {
  default = "us-east-1"
}

variable "applicationName" {
  default = "quickorder"
}

variable "applicationImage" {
  default = "339713150595.dkr.ecr.us-east-1.amazonaws.com/quickorder:latest"
}

variable "databasePostgres" {
  default = "quickorderdb"
}

variable "userPostgres" {

}

variable "passwordPostgres" {

}

variable "databaseMongo" {
  default = "quickorderdb"
}


variable "userMongo" {

}

variable "passwordMongo" {

}

variable "awsAccessKeyValue" {

}

variable "awsAccessKeyIdValue" {

}