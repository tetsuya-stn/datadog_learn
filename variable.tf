variable "datadog_api_key" {
  description = "DatadogのAPIキー"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadogのアプリケーションキー"
  type        = string
  sensitive   = true
}
