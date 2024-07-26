
## Pratica 04 - Projeto Final

## Participante

- Nome: Rômulo Alves de Souza Silva
- E-mail: 1545593@sga.pucminas.br
- Matricula: 212457

## Estrutura do projeto

```bash
vagrant@iaclab2:/vagrant_data$ tree
.
├── ansible
│   ├── inventory.tpl
│   └── playbook.yml
├── export-terraform-vars.sh
├── README.md
└── terraform
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── student.tfvars
    └── variables.tf

2 directories, 10 files
```

## Exemplo de roteiro

### Criar Backend 

Se faz necessario a criação de um storage account e um blob container na Azure para armazenar o tfstate deste projeto visto que o agente devops utilizado nesta pipeline é efêmero.

As variáveis com o nome escolhido poderão ser configuradas no arquivo backend.tf

### GitHub Actions

Foram criados 2 jobs "Terraform Apply" e "Terraform Destroy"

- Ir na aba Actions do GitHub
- Selecionar a action Terraform
- Clicar em Run workflow
- Responder a pertunta com "apply" ou "destroy" para escolher o job a ser executado=