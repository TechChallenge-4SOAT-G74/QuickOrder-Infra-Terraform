# Quick Order - Tech Challenge FIAP

Projeto do Tech Challenge da FIAP - Fase 3

**INTEGRANTES DO GRUPO 74**

* Moisés Barboza de Figueiredo Junior
moises.figueiredo@gmail.com

* Gabriela da Silva Lopes
gabrieladslopes@gmail.com

* Francisco Tadeu da Silva e Souza
fsouza.thadeu@gmail.com

<br />

## Pré-Requisitos

Antes de executar este projeto, os seguintes itens deverão estar instalados no computador:

* Terraform CLI
* AWS CLI
* Visual Studio Code
<br />

## Instalação pelo Visual Studio Code

Passo a passo:

* Baixar o projeto através do repositório do **GitHub**
* Abrir o projeto no **Visual Studio Code**
* Localizar os arquivos **main.tf** e **vars.tf** no Explorer:
<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/d4fb4b62-133e-46f1-9f16-eb07c11c9c69)


<br />

* Abrir o terminal do Visual Studio Code e executar o comando  `terraform init`. O resultado deverá ser conforme abaixo:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/c366580b-f05e-4ee9-a6f5-8f3dee4b12a0)

<br />

* Executar no terminal o comando  `terraform apply`. O terminal solicitará o imput das variáveis de credenciais AWS e de banco de dados. Após isso, o plano de provisionamento será mostrado conforme abaixo e deverá ser informado `yes`, para prosseguir:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/76934751-1a64-4090-879d-114bb05a2e09)

<br />

* Após alguns minutos executando o script, terminal deverá exibir um resultado dessa forma:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/07898a44-48b9-4e42-960e-7d5033145d31)

<br />
