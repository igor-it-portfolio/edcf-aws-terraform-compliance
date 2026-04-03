# ⚖️ Mapeamento de Conformidade - Projeto EDCF
**Framework de Custódia de Dados Empresariais (LGPD/AWS)**

Este documento descreve como a infraestrutura técnica em nuvem atende aos requisitos legais da **Lei Geral de Proteção de Dados (Lei 13.709/2018)**.

---

## 1. Segurança e Sigilo (Artigo 46)
> *"Os agentes de tratamento devem adotar medidas de segurança, técnicas e administrativas aptas a proteger os dados pessoais..."*

* **Implementação:** Utilização de **AWS KMS (Key Management Service)** com chaves mestras simétricas (CMK).
* **Recurso:** `aws_kms_key.edcf_kms`
* **Garantia:** Todos os dados sensíveis no bucket de custódia são criptografados em repouso (AES-256), garantindo que apenas usuários autorizados e autenticados possam acessar o conteúdo.

## 2. Registro de Operações (Artigo 37)
> *"O controlador e o operador devem manter registro das operações de tratamento de dados pessoais..."*

* **Implementação:** Ativação do **AWS CloudTrail** com monitoramento de **Data Events**.
* **Recurso:** `aws_cloudtrail.edcf_trail`
* **Garantia:** Cada leitura, escrita ou deleção de um dado pessoal é registrada em um log de auditoria imutável, contendo quem acessou, quando e de onde.

## 3. Integridade e Proteção contra Alterações (Artigo 6º, Inciso X)
> *"Princípio da Responsabilização e Prestação de Contas."*

* **Implementação:** **S3 Object Lock** e **Versioning**.
* **Recurso:** `object_lock_enabled = true`
* **Garantia:** Uma vez que o dado é depositado, ele não pode ser alterado ou removido acidentalmente, garantindo a integridade da prova em caso de auditoria.

## 4. Término do Tratamento e Limitação (Artigo 15)
> *"Os dados pessoais devem ser eliminados após o término de seu tratamento..."*

* **Implementação:** **S3 Lifecycle Policies**.
* **Recurso:** `aws_s3_bucket_lifecycle_configuration.data_lifecycle`
* **Garantia:** Implementação de regras automáticas que movem dados para o Glacier após 90 dias e realizam a **exclusão definitiva** após 5 anos, evitando a retenção desnecessária de dados.

## 5. Prevenção e Detecção (Artigo 48)
> *"O controlador deverá comunicar à autoridade nacional a ocorrência de incidente de segurança..."*

* **Implementação:** **Amazon GuardDuty** (Código pronto para ativação).
* **Recurso:** `guardduty.tf`
* **Garantia:** Monitoramento contínuo através de Machine Learning para detectar tentativas de invasão, logins suspeitos ou exfiltração de dados em tempo real.