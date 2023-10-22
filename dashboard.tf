resource "datadog_dashboard" "ecs" {
  title            = "ECS Fargate"
  reflow_type      = "auto"
  layout_type      = "ordered"

  template_variable {
    defaults = ["*"]
    name     = "var"
  }

  widget {
    timeseries_definition {
      legend_columns = [
        "avg",
        "max",
        "min",
        "sum",
        "value",
      ]
      legend_layout = "auto"
      show_legend   = false
      title         = "メモリ使用率（container_name, cluster: cluster-name-*）"
      marker {
        display_type = "error solid"
        value        = "y = 80"
      }
      request {
        display_type   = "line"
        on_right_yaxis = false
        formula {
          formula_expression = "(query1 / query2) * 100"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query1"
            query       = "avg:ecs.fargate.mem.usage{ecs_container_name:*-container,cluster_name:cluster-name-*} by {container_name}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query2"
            query       = "avg:ecs.fargate.mem.hierarchical_memory_limit{ecs_container_name:*-container,cluster_name:cluster-name-*} by {container_name}"
          }
        }
        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      yaxis {
        include_zero = true
        max          = "auto"
        min          = "auto"
        scale        = "linear"
      }
    }
  }
}