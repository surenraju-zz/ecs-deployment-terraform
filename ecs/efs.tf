resource "aws_efs_file_system" "efs" {
  creation_token = "${var.project}-${var.environment}"

  tags = {
    Name = "${var.project}-${var.environment}"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}

resource "aws_efs_mount_target" "mt-1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private-subnet-1.id
  security_groups = [aws_security_group.efs-security-group.id]
}

resource "aws_efs_mount_target" "mt-2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private-subnet-2.id
  security_groups = [aws_security_group.efs-security-group.id]
}

resource "aws_efs_mount_target" "mt-3" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private-subnet-3.id
  security_groups = [aws_security_group.efs-security-group.id]
}


resource "aws_efs_access_point" "nifi-database-repository" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/opt/nifi/nifi-current/database_repository"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "775"
    }
  }
}


resource "aws_efs_access_point" "nifi-state" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/opt/nifi/nifi-current"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "775"
    }
  }
}

resource "aws_efs_access_point" "nifi-flowfile-repository" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/opt/nifi/nifi-current/flowfile_repository"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "775"
    }
  }
}

resource "aws_efs_access_point" "nifi-content-repository" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/opt/nifi/nifi-current/content_repository"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "775"
    }
  }
}

resource "aws_efs_access_point" "nifi-provenance-repository" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/opt/nifi/nifi-current/provenance_repository"
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "775"
    }
  }
}


resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id

  bypass_policy_lockout_safety_check = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "EcsOnFargateTaskReadWriteAccess",
    "Statement": [
        {
            "Sid": "EcsOnFargateTaskReadWriteAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Principal": {
                "AWS": "${aws_iam_role.task.arn}"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "StringEquals": {
                    "elasticfilesystem:AccessPointArn": [
                        "${aws_efs_access_point.nifi-state.arn}",
                        "${aws_efs_access_point.nifi-database-repository.arn}",
                        "${aws_efs_access_point.nifi-flowfile-repository.arn}",
                        "${aws_efs_access_point.nifi-content-repository.arn}",
                        "${aws_efs_access_point.nifi-provenance-repository.arn}"
                    ]
                }
            }
        }
    ]
}
POLICY
  depends_on = [
    aws_efs_file_system.efs,
    aws_efs_access_point.nifi-state,
    aws_efs_access_point.nifi-database-repository,
    aws_efs_access_point.nifi-flowfile-repository,
    aws_efs_access_point.nifi-content-repository,
    aws_efs_access_point.nifi-provenance-repository
  ]
}
