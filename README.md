# AFT Bootstrap

Repositório de exemplo para bootstrap do [AFT (Account Factory for Terraform)](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html). Ele fornece uma estrutura de pastas e arquivos pré-configurada que pode ser usada como ponto de partida para novos projetos com o AFT.

## Estrutura do Repositório

```
aft-bootstrap/
├── aft-account-customizations/      # Customizações por tipo de conta
├── aft-account-provisioning-customizations/  # Customizações executadas durante o provisionamento
├── aft-account-request/             # Definições de contas a serem provisionadas
└── aft-global-customizations/       # Customizações aplicadas a todas as contas
```

## Pré-requisitos

- [AWS Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html) configurado na sua organização
- [AFT](https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html) implantado via Terraform
- Acesso a um provedor Git (CodeCommit, GitHub, Bitbucket, etc.)

## Como Utilizar

### 1. Criar a pipeline do AFT

Utilize o CloudFormation disponível no repositório abaixo para criar a pipeline de execução do AFT:

> https://github.com/aws-samples/aft-bootstrap-pipeline

> ⚠️ **Atenção:** Nos parâmetros do CloudFormation, ao executar o bootstrap de criação do AFT Pipeline, informe a versão do Terraform mais recente no momento atual (1.14).
### 2. Criar os repositórios Git

Após a criação da pipeline, crie 4 repositórios no provedor Git da sua escolha:

| Repositório | Pasta correspondente | Descrição |
|---|---|---|
| `aft-account-request` | `aft-account-request/` | Define as contas que serão provisionadas pelo AFT |
| `aft-account-customizations` | `aft-account-customizations/` | Customizações específicas por tipo de conta |
| `aft-account-provisioning-customizations` | `aft-account-provisioning-customizations/` | Customizações executadas durante o provisionamento da conta |
| `aft-global-customizations` | `aft-global-customizations/` | Customizações aplicadas globalmente a todas as contas |

### 3. Copiar o conteúdo

Para cada repositório criado, copie o conteúdo da pasta correspondente deste repositório.

### 4. Configurar a região

Antes de utilizar o `aft-global-customizations`, defina a região no arquivo `aft-global-customizations/terraform/aft-config.j2`:

```json
{% 
  set regions = [
    {
      "key": "primary",
      "name": "us-east-1"
    }
  ]
%}
```

### 5. Solicitar novas contas

Para solicitar novas contas, crie arquivos `.tf` no repositório `aft-account-request` seguindo os exemplos existentes (`ct-log-archive.tf`, `ct-security-tooling.tf`). Arquivos com extensão `.tf.hold` estão desabilitados e podem ser ativados renomeando para `.tf`.

## O que vem pré-configurado

- Política de senha IAM com requisitos de complexidade e rotação
- Bloqueio de acesso público ao S3 e AMI
- Criptografia EBS habilitada por padrão
- Enforcement de IMDSv2
- Step Function para customizações de provisionamento
- Exemplos de account request para contas Log Archive e Security Tooling

## Referências

- [AWS Control Tower Account Factory for Terraform](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [AFT Blueprints](https://github.com/awslabs/aft-blueprints)
- [AFT Bootstrap Pipeline](https://github.com/aws-samples/aft-bootstrap-pipeline)

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
