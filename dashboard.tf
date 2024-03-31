resource "datadog_dashboard" "ecs" {
  description      = "[[suggested_dashboards]]"
  layout_type      = "ordered"
  reflow_type      = "auto"
  title            = "ECS Containers dashboard"

  widget {
    timeseries_definition {
      legend_columns = ["avg", "max", "min", "sum", "value"]
      legend_layout  = "auto"
      show_legend    = true
      title          = "CPU使用率"
      title_align    = "left"
      title_size     = "16"
      request {
        display_type   = "line"
        on_right_yaxis = false

        formula {
          formula_expression = "query1 / 2"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query1"
            query       = "max:ecs.fargate.cpu.percent{*} by {container_id,container_name}"
          }
        }
        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
    }
  }
  widget {
    timeseries_definition {
      legend_columns = ["avg", "max", "min", "sum", "value"]
      legend_layout  = "auto"
      show_legend    = true
      title          = "メモリ使用率"
      title_align    = "left"
      title_size     = "16"
      request {
        display_type   = "line"
        on_right_yaxis = false
        formula {
          formula_expression = "query1 * 100 / query2"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query1"
            query       = "max:ecs.fargate.mem.usage{*} by {container_name,container_id}"
          }
        }
        query {
          metric_query {
            aggregator  = null
            data_source = "metrics"
            name        = "query2"
            query       = "max:ecs.fargate.mem.limit{*} by {container_name,container_id}"
          }
        }
        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
    }
  }
  widget {
    timeseries_definition {
      legend_columns = ["avg", "max", "min", "sum", "value"]
      legend_layout  = "auto"
      show_legend    = true
      title          = "Latency"
      title_align    = "left"
      title_size     = "16"
      request {
        display_type   = "line"
        on_right_yaxis = false
        formula {
          formula_expression = "p50"
        }
        formula {
          formula_expression = "p75"
        }
        formula {
          formula_expression = "p90"
        }
        formula {
          formula_expression = "p95"
        }
        formula {
          formula_expression = "p99"
        }
        formula {
          formula_expression = "p100"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p50"
            query       = "p50:trace.cakephp.request{*}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p75"
            query       = "p75:trace.cakephp.request{*}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p90"
            query       = "p90:trace.cakephp.request{*}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p95"
            query       = "p95:trace.cakephp.request{*}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p99"
            query       = "p99:trace.cakephp.request{*}"
          }
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "p100"
            query       = "max:trace.cakephp.request{*}"
          }
        }
        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      yaxis {
        include_zero = false
        scale        = "linear"
      }
    }
  }
  widget {
    timeseries_definition {
      legend_columns = ["avg", "max", "min", "sum", "value"]
      legend_layout  = "auto"
      show_legend    = true
      title          = "Request count"
      title_align    = "left"
      title_size     = "16"
      request {
        display_type   = "bars"
        on_right_yaxis = false
        formula {
          formula_expression = "query1"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query1"
            query       = "sum:trace.cakephp.request.hits{*}.as_count()"
          }
        }
        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      request {
        display_type   = "bars"
        on_right_yaxis = false
        formula {
          formula_expression = "query1"
        }
        query {
          metric_query {
            data_source = "metrics"
            name        = "query1"
            query       = "sum:trace.cakephp.request.errors{*}.as_count()"
          }
        }
        style {
          palette    = "warm"
        }
      }
    }
  }
}
