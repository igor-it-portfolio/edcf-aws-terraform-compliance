# 1. Criando a Chave Mestra (CMK)
resource "aws_kms_key" "edcf_key" {
  description             = "Chave Mestra para Documentos Confidenciais - EDCF"
  
  # REGRA DO BANCO CENTRAL: Rotação automática anual
  enable_key_rotation     = true 

  # Se deletarmos, ela espera 30 dias antes de sumir (Segurança contra erros)
  deletion_window_in_days = 30

  tags = {
    Projeto = "Enterprise Data Custody Framework"
    Setor   = "Compliance"
  }
}

# 2. Criando um ALIAS (Um apelido para a chave)
# É mais fácil chamar a chave de 'projeto-edcf' do que por um ID gigante.
resource "aws_kms_alias" "edcf_key_alias" {
  name          = "alias/projeto-edcf"
  target_key_id = aws_kms_key.edcf_key.key_id
}