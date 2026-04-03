# 1. Criando o Bucket de Dados com o nome focado no Projeto EDCF
resource "aws_s3_bucket" "data_bucket" {
  # Novo nome: focado em Custódia de Dados e o padrão do projeto
  bucket = "edcf-data-custody-igorc-2026"

  # Habilitando o Object Lock (Trava de Conformidade) - ESSENCIAL PARA O PROJETO
  object_lock_enabled = true

  tags = {
    Name        = "EDCF Data Custody"
    Project     = "Enterprise Data Custody Framework"
    Compliance  = "LGPD-BACEN"
  }
}

# 2. Ativando o Versionamento (O nosso "Botão de Desfazer")
resource "aws_s3_bucket_versioning" "data_versioning" {
  bucket = aws_s3_bucket.data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Fazendo o "Casamento": Enviando logs deste bucket para o seu bucket de logs
resource "aws_s3_bucket_logging" "data_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = "logs-auditoria-igorc-2026-edcf"
  target_prefix = "s3-access-logs/"
}

# 4. Configurando a Regra de Retenção (Modo Compliance - 1 dia para teste)
resource "aws_s3_bucket_object_lock_configuration" "data_lock_config" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 1
    }
  }
}

# 5. Forçando o uso da sua chave KMS (Criptografia de Nível Bancário)
resource "aws_s3_bucket_server_side_encryption_configuration" "data_encryption" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      # Força o uso da chave KMS que você criou no arquivo kms.tf
      kms_master_key_id = aws_kms_key.edcf_key.arn
      sse_algorithm     = "aws:kms"
    }
    # Ativa a chave do bucket para reduzir custos de chamadas KMS e melhorar performance
    bucket_key_enabled = true
  }
}

# 6. Configuração de Ciclo de Vida para o Bucket de Dados (Custódia)
resource "aws_s3_bucket_lifecycle_configuration" "data_lifecycle" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    id     = "archive_and_cleanup_data"
    status = "Enabled"

    # Transição para o Glacier (Armazenamento Frio) após 90 dias
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Expiração (Deleção definitiva) após 5 anos para cumprir a LGPD
    expiration {
      days = 1825
    }

    # Limpeza de versões antigas (Versioning) após 30 dias para economizar
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}