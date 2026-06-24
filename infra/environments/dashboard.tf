resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-cloud-design-dashboard" # ADDED ENV

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${title(var.environment)} ECS Cluster CPU Utilization" # ADDED ENV
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${title(var.environment)} ECS Cluster Memory Utilization" # ADDED ENV
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            # UPDATED SERVICE NAMES TO INCLUDE ENVIRONMENT PREFIX
            ["AWS/ECS", "CPUUtilization", "ServiceName", "${var.environment}-api-gateway-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "CPUUtilization", "ServiceName", "${var.environment}-billing-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "CPUUtilization", "ServiceName", "${var.environment}-inventory-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "CPUUtilization", "ServiceName", "${var.environment}-rabbitmq-service", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${title(var.environment)} ECS Services CPU Utilization" # ADDED ENV
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            # UPDATED SERVICE NAMES TO INCLUDE ENVIRONMENT PREFIX
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "${var.environment}-api-gateway-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "MemoryUtilization", "ServiceName", "${var.environment}-billing-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "MemoryUtilization", "ServiceName", "${var.environment}-inventory-service", "ClusterName", aws_ecs_cluster.main.name],
            [".", "MemoryUtilization", "ServiceName", "${var.environment}-rabbitmq-service", "ClusterName", aws_ecs_cluster.main.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "${title(var.environment)} ECS Services Memory Utilization" # ADDED ENV
        }
      }
    ]
  })
}