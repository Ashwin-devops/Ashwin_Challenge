variable "cidr_block" {
  description = "cidr block to be used to create the vpc"
  default = "10.0.0.0/16"
}

variable "env" {
  description = "name of the enviroment (example: prod, dev)"
  default = "dev"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "application" {
    description = "name of the application that we are deploying for (example: apiserver)"
    default = "spingboot"
}

variable "internal" {
    default = "false"
    description = "if the alb is internal or external"
}

