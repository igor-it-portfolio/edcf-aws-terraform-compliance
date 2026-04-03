/* # ESTE RECURSO ESTÁ DESATIVADO PARA EVITAR CUSTOS NA CONTA DE ESTUDANTE
# ELE FAZ PARTE DA ESTRATÉGIA DE SEGURANÇA ATIVA (ART. 48 LGPD)

resource "aws_guardduty_detector" "edcf_detector" {
  enable = true
}

resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.edcf_detector.id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}
*/