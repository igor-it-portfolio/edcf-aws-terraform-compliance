# 🛡️ EDCF: Enterprise Data Custody Framework
### Cloud-Native Data Governance & Regulatory Compliance (AWS/Terraform)

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4.svg?style=for-the-badge&logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud_Security-232F3E.svg?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com/)
[![LGPD](https://img.shields.io/badge/Compliance-LGPD_/_GDPR-green.svg?style=for-the-badge)](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)

## 📖 Visão Geral do Projeto
O **EDCF** é um framework de infraestrutura como código (IaC) projetado para resolver o desafio crítico de **Custódia de Dados Sensíveis** em ambientes corporativos. Ele automatiza a criação de um ecossistema de armazenamento imutável, auditável e criptografado, alinhando controles técnicos rígidos aos requisitos da **LGPD (Lei Geral de Proteção de Dados)** e normas do **BACEN**.

---

## 🏗️ Arquitetura de Solução
A solução foi desenhada seguindo o **AWS Well-Architected Framework**, focando nos pilares de Segurança e Otimização de Custos.

### 🔐 Segurança & Imutabilidade (Data Guard)
* **KMS Managed Encryption:** Implementação de Chaves Mestras de Cliente (CMK) com rotação e políticas de acesso granulares.
* **S3 Object Lock (Compliance Mode):** Proteção contra remoção ou alteração de dados, garantindo a integridade da prova digital (WORM - Write Once, Read Many).
* **Versioning:** Controle de estados históricos para recuperação de desastres e auditoria retroativa.

### 🕵️ Auditoria & Monitoramento (Threat Detection)
* **AWS CloudTrail (Data Events):** Monitoramento de 100% das chamadas de API nos objetos sensíveis, gerando uma trilha de evidências inquestionável.
* **Amazon GuardDuty (IA):** Detecção de anomalias e tentativas de exfiltração de dados via Machine Learning (configuração pronta para ativação).
* **Isolated Logging:** Armazenamento de logs em bucket dedicado com políticas de acesso restritivas para evitar a "queima de arquivo".

### 💰 FinOps & Lifecycle (Cost Management)
* **Automated Tiering:** Transição automática de objetos para a classe **S3 Glacier** após 90 dias, reduzindo custos de armazenamento em até 90%.
* **Data Expiration:** Purga automática de registros após o período legal de retenção (5 anos), mitigando riscos de passivo de dados.

---

## 🛠️ Stack Tecnológica
* **IaC:** Terraform v1.x
* **Cloud:** Amazon Web Services (AWS)
* **Security:** AWS KMS, GuardDuty, IAM
* **Storage:** Amazon S3 (Standard & Glacier)
* **Governance:** AWS CloudTrail

---

## 📂 Estrutura do Repositório
```bash
.
├── main.tf           # Definição de Providers e Configurações Globais
├── kms.tf            # Gestão de Chaves Criptográficas
├── data_bucket.tf    # Armazenamento de Custódia (Object Lock/KMS)
├── log_bucket.tf     # Armazenamento de Trilhas de Auditoria
├── cloudtrail.tf     # Configuração de Monitoramento de API
├── guardduty.tf      # Detecção Inteligente de Ameaças (Draft/Ready)
├── COMPLIANCE.md     # Mapeamento Técnico-Jurídico (LGPD)
└── README.md         # Documentação Principal

## ⚙️ Implementação e Deploy

1. **Pré-requisitos:** AWS CLI configurado e Terraform instalado.
2. **Inicialização:** `terraform init`
3. **Validação:** `terraform plan`
4. **Deploy:** `terraform apply`

---

## ⚖️ Conformidade Legal

Este projeto implementa controles específicos para os seguintes artigos da **LGPD**:

* **Art. 6º:** Princípio da Segurança e Prevenção.
* **Art. 37:** Manutenção de registros de operações.
* **Art. 46:** Medidas técnicas e administrativas de proteção.

> Para detalhes completos, consulte o arquivo [COMPLIANCE.md](./COMPLIANCE.md).

---

**Desenvolvido por Igor Pantoja.** *Especialista em Cloud Security & Infrastructure*