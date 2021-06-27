// any variables with no default are sourced from .env
variable "region" {
  type = string
}

variable "endpoint" {
  type = string
}

variable "fn_name" {
  type = string
}

variable "fn_iam" {
  type    = string
  default = "echo.add-role"
}

variable "fn_archive" {
  type = string
}
