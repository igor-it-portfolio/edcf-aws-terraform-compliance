# 1. Configurando o CloudTrail para o Projeto EDCF
resource "aws_cloudtrail" "main_trail" {
  name                          = "auditoria-geral-edcf"
  s3_bucket_name                = "logs-auditoria-igorc-2026-edcf" # Destino dos logs
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true # Segurança Máxima: impede alteração dos logs

  # 2. Eventos de Dados: Rastreia quem baixar, ler ou deletar arquivos
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      # Aqui ele pega automaticamente o nome novo do seu bucket!
      values = ["${aws_s3_bucket.data_bucket.arn}/"]
    }
  }

  tags = {
    Project    = "EDCF"
    Monitoring = "Data-Events"
  }
}