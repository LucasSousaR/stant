# README

# Meu Projeto Ruby on Rails

Este é um projeto Ruby on Rails que monta uma organização de horarios de palestradas cadastradas no sistema via upload de arquvo(xlsx/csv) ou pelo cadastro manual

## Requisitos do Sistema

- Ruby 3.0.2
- Rails 7.0.6
- PostgreSQL 15.1
- Node 14.20.0
- Redis Server

## Instalação

1. Clone o repositório.
2. Execute `bundle install` para instalar as dependências.
3. Execute `yarn install` para instalar as dependências Node.
4. Configure o banco de dados com `rails db:create db:migrate db:seed`.
5. Execute `rake assets:precompile` para compilar os Assets.
6. Execute `rake webpacker:compile` para compilar e empacotar os arquivos JavaScript e CSS .


## Configuração

- Configure as chaves de ambiente em `config/database.yml`.

## Uso

- Execute o servidor Rails com `rails server`.
- Acesse o aplicativo em `http://localhost:3000`.

## Estrutura de Arquivos

- `app/`: Contém os arquivos da aplicação.
- `config/`: Contém as configurações do Rails.
- ...


## Autores

- [Lucas Sousa Rodrigues](https://github.com/LucasSousaR)

## Licença

Este projeto está sob a [Licença MIT](LICENSE).

## Links Úteis

- [Linkedin](https://www.linkedin.com/in/lucas-sousa-rodrigues-818328170/)
- [Repositório no GitHub](https://github.com/LucasSousaR/stant.git)