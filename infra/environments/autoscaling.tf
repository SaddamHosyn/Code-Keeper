# ==========================================
# Dynamic Auto-Scaling Policies for ECS Services...
# ==========================================

# API Gateway Auto-Scaling (Stateless, safe to scale)
resource "aws_appautoscaling_target" "api_gateway" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${var.environment}-api-gateway-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.api_gateway_service]
}

resource "aws_appautoscaling_policy" "api_gateway_cpu" {
  name               = "${var.environment}-api-gateway-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api_gateway.resource_id
  scalable_dimension = aws_appautoscaling_target.api_gateway.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api_gateway.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}