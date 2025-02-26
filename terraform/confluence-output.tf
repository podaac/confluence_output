# Job Definition
resource "aws_batch_job_definition" "generate_batch_jd_output" {
  name                  = "${var.prefix}-output"
  type                  = "container"
  container_properties  = <<CONTAINER_PROPERTIES
  {
    "image": "${local.account_id}.dkr.ecr.us-west-2.amazonaws.com/${var.prefix}-output",
    "executionRoleArn": "${data.aws_iam_role.exe_role.arn}",
    "jobRoleArn": "${data.aws_iam_role.job_role.arn}",
    "fargatePlatformConfiguration": { "platformVersion": "LATEST" },
    "logConfiguration": {
      "logDriver" : "awslogs",
      "options": {
        "awslogs-group" : "${data.aws_cloudwatch_log_group.cw_log_group.name}"
      }
    },
    "resourceRequirements": [
      {"type": "MEMORY", "value": "65536"},
      {"type": "VCPU", "value": "16"}
    ],
    "mountPoints": [
      {
        "sourceVolume": "input",
        "containerPath": "/mnt/data/input",
        "readOnly": true
      },
      {
        "sourceVolume": "flpe",
        "containerPath": "/mnt/data/flpe",
        "readOnly": true
      },
      {
        "sourceVolume": "moi",
        "containerPath": "/mnt/data/moi",
        "readOnly": true
      },
      {
        "sourceVolume": "diagnostics",
        "containerPath": "/mnt/data/diagnostics",
        "readOnly": true
      },
      {
        "sourceVolume": "offline",
        "containerPath": "/mnt/data/offline",
        "readOnly": true
      },
      {
        "sourceVolume": "validation",
        "containerPath": "/mnt/data/validation",
        "readOnly": true
      },
      {
        "sourceVolume": "output",
        "containerPath": "/mnt/data/output",
        "readOnly": false
      }
    ],
    "volumes": [
      {
        "name": "input",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_input.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "flpe",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_flpe.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "moi",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_moi.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "diagnostics",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_diagnostics.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "offline",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_offline.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "validation",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_validation.file_system_id}",
          "rootDirectory": "/"
        }
      },
      {
        "name": "output",
        "efsVolumeConfiguration": {
          "fileSystemId": "${data.aws_efs_file_system.aws_efs_output.file_system_id}",
          "rootDirectory": "/"
        }
      }
    ]
  }
  CONTAINER_PROPERTIES
  platform_capabilities = ["FARGATE"]
  propagate_tags        = true
  tags = { "job_definition": "${var.prefix}-output" }
}
