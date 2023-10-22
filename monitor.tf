resource "datadog_monitor" "example" {
  name    = "Discounts service request time"
  message = <<EOT
Investigate the source of the problem. Try checking the [APM service page](https://app.datadoghq.com/apm/services/store-discounts/operations/flask.request?env=foundation-lab&start=1684155366000&end=1684158966000&paused=false) for `store-discounts`.

Contact @incident@example.com after triage.
EOT
  query   = "avg(last_5m):avg:trace.flask.request{service:store-discounts} > 2"
  type    = "metric alert"

  include_tags        = false
  require_full_window = false

  monitor_thresholds {
    critical = "2"
    warning  = "1.5"
  }
}

resource "datadog_monitor" "ecs_cpu_utilization" {
  evaluation_delay     = 0
  include_tags         = true
  message              = <<-EOT
                            {{#is_match "ecs_container_name.name" "prod"}}
                            ### アラート内容
                            {{#is_warning}}
                            - {{ecs_container_name}} のCPU使用率70%超過
                            {{/is_warning}}
                            {{#is_alert}}
                            - {{ecs_container_name}} のCPU使用率80%超過
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
  query                = "avg(last_30m):(avg:ecs.fargate.cpu.usage{ecs_container_name:*-container} by {ecs_container_name} / avg:ecs.fargate.cpu.limit{ecs_container_name:*-container} by {ecs_container_name}) * 0.0001 > 80"
  renotify_interval    = 20
  renotify_occurrences = 0
  require_full_window  = true
  tags = [
    "service:<service_name>"
  ]
  timeout_h = 0
  type      = "query alert"
  monitor_thresholds {
    critical          = "80"
    critical_recovery = "60"
    warning           = "70"
    warning_recovery  = "50"
  }
}
