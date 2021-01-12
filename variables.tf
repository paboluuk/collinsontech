variable "server_port" {
  description = "server will use for HTTP requests"
  type        = number
  default = 8080
}

variable "elb_port" {
  description = "HTTP requests are listened"
  type        = number
  default = 80
}