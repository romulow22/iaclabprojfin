
## Pratica 04 - Projeto Final

## Participante

- Nome: Rômulo Alves de Souza Silva
- E-mail: 1545593@sga.pucminas.br
- Matricula: 212457

## Estrutura do projeto

```bash

```

## Exemplo de roteiro

### Criar Backend 

Se faz necessario a criação de um storage account e um blob container na Azure para armazenar o tfstate deste projeto visto que o agente devops utilizado nesta pipeline é efêmero.

As variáveis com o nome escolhido poderão ser configuradas no arquivo backend.tf

### Provisionar infraestrutura

```bash
terraform init -upgrade
terraform plan -out apply.tfplan -var-file=student.tfvars
terraform apply apply.tfplan
```

### Configurar serviços

```bash
ansible-playbook -i inventory.ini playbook.yml
```

### Destruir ambiente

```bash
cd ..
terraform plan -destroy -out destroy.tfplan -var-file=acme.tfvars
terraform apply destroy.tfplan
```

## Evidências
