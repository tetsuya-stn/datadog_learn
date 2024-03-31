resource "datadog_monitor" "ecs_cpu_utilization" {
  evaluation_delay     = 0
  include_tags         = true
  message              = <<-EOT
                            {{#is_match "ecs_container_name.name" "prod"}}
                            ### アラート内容
                            {{#is_warning}}
                            - {{ecs_container_name}} のCPU使用率80%超過
                            {{/is_warning}}
                            {{#is_alert}}
                            - {{ecs_container_name}} のCPU使用率90%超過
                            {{/is_alert}}
                            {{/is_match}}
                          EOT
  name                 = "CPU監視 {{ecs_container_name}}"
  new_group_delay      = 0
  no_data_timeframe    = 0
  notify_audit         = false
  notify_by            = []
  notify_no_data       = false
  priority             = 0
  query                = "avg(last_30m):(avg:ecs.fargate.cpu.usage{ecs_container_name:*-container} by {ecs_container_name} / avg:ecs.fargate.cpu.limit{ecs_container_name:*-container} by {ecs_container_name}) * 0.0001 > 90"
  renotify_interval    = 20
  renotify_occurrences = 0
  require_full_window  = true
  tags = [
    "service:<service_name>"
  ]
  timeout_h = 0
  type      = "query alert"
  monitor_thresholds {
    critical          = "90"
    critical_recovery = "70"
    warning           = "80"
    warning_recovery  = "60"
  }
}

resource "datadog_monitor" "latency" {
  evaluation_delay     = 0
  include_tags         = true
  message              = <<-EOT
                            {{#is_match "service.name" "prod"}}
                            ### アラート内容
                            {{#is_warning}}
                            - {{service_name}} のレイテンシー500ms超過
                            {{/is_warning}}
                            {{#is_alert}}
                            - {{service_name}} のレイテンシー1000ms超過
                            {{/is_alert}}
                            {{/is_match}}
                          EOT
  name                 = "レイテンシー監視 {{service_name}}"
  new_group_delay      = 0
  no_data_timeframe    = 0
  notify_audit         = false
  notify_by            = []
  notify_no_data       = false
  priority             = 0
  query                = "avg(last_5m):avg:trace.cakephp.request{*} > 1000"
  renotify_interval    = 20
  renotify_occurrences = 0
  require_full_window  = true
  tags = [
    "service:<service_name>"
  ]
  timeout_h = 0
  type      = "query alert"
  monitor_thresholds {
    critical          = "1000"
    critical_recovery = "500"
    warning           = "500"
    warning_recovery  = "400"
  }
}

resource "datadog_monitor" "query_latency" {
  evaluation_delay    = 0
  include_tags        = false
  message             = <<-EOT
                            ### アラート内容
                            {{#is_warning}}
                            - {{service_name}} のクエリのレイテンシーが3秒超過
                            {{/is_warning}}
                            {{#is_alert}}
                            - {{service_name}} のクエリのレイテンシーが5秒超過
                            {{/is_alert}}
                          EOT
  name                = "クエリ監視"
  new_group_delay     = 0
  no_data_timeframe   = 0
  notify_audit        = false
  notify_by           = []
  notify_no_data      = false
  priority            = 0
  query               = "avg(last_5m):avg:trace.mysql.query.duration{*} > 5"
  require_full_window = false

  type = "query alert"
  monitor_thresholds {
    critical = "5"
    warning  = "3"
  }
}

