# 1. Criando o Bucket que vai RECEBER os logs ("Cofre de Provas")
resource "aws_s3_bucket" "log_bucket" {
  # Usando o seu padrão de nome para o bucket de logs
  bucket = "logs-auditoria-igorc-2026-edcf"

  tags = {
    Name        = "Bucket de Logs de Auditoria"
    Environment = "Dev-Compliance"
  }
}

# 2. Configurando a Propriedade de Posse (Necessário para segurança moderna)
resource "aws_s3_bucket_ownership_controls" "log_bucket_oc" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 3. Tornando o bucket privado (Ninguém da internet pode ver os logs!)
resource "aws_s3_bucket_public_access_block" "log_bucket_access" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Definindo que este bucket é um destino de LOGS
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_oc]

  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write" # Permissão especial para o S3 escrever logs aqui
}

resource "aws_s3_bucket_policy" "allow_cloudtrail" {
  bucket = "logs-auditoria-igorc-2026-edcf"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::logs-auditoria-igorc-2026-edcf"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::logs-auditoria-igorc-2026-edcf/AWSLogs/*",
            "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
        }
    ]
}
POLICY
}

# Configuração de Ciclo de Vida para o Bucket de Logs
resource "aws_s3_bucket_lifecycle_configuration" "log_lifecycle" {
  bucket = "logs-auditoria-igorc-2026-edcf"

  rule {
    id     = "archive_old_logs"
    status = "Enabled"

    # Logs de auditoria raramente são lidos após 3 meses. Glacier neles!
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Logs de auditoria devem ser mantidos por 5 anos para Compliance
    expiration {
      days = 1825
    }
  }
}