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
* AWS CLI (logado com o usuário da sua conta AWS)
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

## Verificando o resultado na AWS:

* Logar na sua conta AWS e acessar o serviço **EC2**. O cluster deverá estar desta forma após a execução do script terraform dos passos anteriores:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/7f037850-013f-4b9f-94a0-357b4d8238e7)

<br />

* Acessar o serviço **RDS**. A base de dados deverá estar conforme abaixo:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/f2afd2f0-dbfe-43b6-b598-b5a323250a77)

<br />

* Acessar o serviço **Load Balancers**, do EC2. Deverá existir um Load Balancer chamado **quickorder**. Copiar para área de transferência o valor do DNS name:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/3103844a-86ce-42ce-b32f-4c3e682e641d)


<br />

* Colar na barra de endereços do browser o valor do DNS name copiado no passo anterior, para que fique dessa forma: quickorder-1380821274.us-east-1.elb.amazonaws.com/swagger. Dessa forma, a API que fui publicada na aplicação poderá ser acessada. O resultado deverá ser conforme abaixo:

<br />

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/cbc8ce6f-2603-4e72-a71f-9b19fb44d24b)

![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/091e1cf7-504f-410d-8346-a8a606ed037c)

<br />

**Passo a passo WebHooks**
   <img src="![image](https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/5f610c8e-5840-4ecd-96ce-871bf0b8ef5e)"
<br />
<div align="center">
      <a href="https://www.youtube.com/watch?v=qNlFbp0ErRk">
     <img src="https://github.com/TechChallenge-4SOAT-G74/QuickOrder-Infra-Terraform/assets/19378661/5f610c8e-5840-4ecd-96ce-871bf0b8ef5e" 
      alt="Api" 
      style="width:560px;height:315px;">
      </a>
</div>
