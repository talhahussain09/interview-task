resource "aws_cloudwatch_dashboard" "interview_task_dashboard" {
  dashboard_name = "interview-task-dashboard"

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
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 CPU Utilization"
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
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.web.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Memory Usage Percentage"
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
            ["CWAgent", "disk_used_percent", "InstanceId", aws_instance.web.id, "path", "/", "device", "rootfs", "fstype", "rootfs"]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Root Disk Usage Percentage"
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          query  = "SOURCE '/interview-task/application/app' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region = var.aws_region
          title  = "Application Logs"
          view   = "table"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6

        properties = {
          query  = "SOURCE '/interview-task/system/syslog' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region = var.aws_region
          title  = "System Logs"
          view   = "table"
        }
      }
    ]
  })
}