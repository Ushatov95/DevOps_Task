resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name = var.sku_name
  os_type = var.os_type
}

resource "azurerm_linux_web_app" "app" {
  name = var.app_name
  location = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = var.python_version
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "web_autoscale" {
  name                = "${var.environment}-${var.region}-${var.app_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.plan.id
  enabled             = true

  profile {
    name = "AutoScaleProfile"

    capacity {
      minimum = "1"
      maximum = "3"
      default = "1"
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT15M"
        statistic          = "Average"
        time_window        = "PT15M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 85
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT15M"
        statistic          = "Average"
        time_window        = "PT15M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 60
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "SocketInboundAll"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT10M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 150
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
        }
    }

  rule {
    metric_trigger {
      metric_name        = "SocketInboundAll"
      metric_resource_id = azurerm_service_plan.plan.id
      time_grain         = "PT1M"
      statistic          = "Average"
      time_window        = "PT5M"
      time_aggregation   = "Average"
      operator           = "LessThan"
      threshold          = 50
    }

    scale_action {
      direction = "Decrease"
      type      = "ChangeCount"
      value     = "1"
      cooldown  = "PT10M"
    }
  }
}

  tags = var.tags
}
