# Тестовое задание для Деловой среды
## Системные требования
- ruby >= v3.0.2
- postgresql >= v13
- docker >= v20 (опционально)
  
## Установка
### Установка без Docker
- Клонировать проект `git clone git@github.com:gpunker/delovaya_sreda_golovachev_test.git`
- Скопировать файл *.env.dist* с именем *.env*: `cp .env.dist .env`
- В файле *.env* указать пароль пользователя postgres в вашем PostgreSQL
- Создать БД: `bundle exec rails db:create`
- Выполнить миграции: `bundle exec rails db:migrate`
- Выполнить сиды: `bundle exec rails db:seed`
- Запустить сервер: `bundle exec rails s`
- Можно отправлять запросы на *localhost:3000*
  
### Установка с Docker
- Клонировать проект `git clone git@github.com:gpunker/delovaya_sreda_golovachev_test.git`
- Скопировать файл *.env.dist* с именем *.env*: `cp .env.dist .env`
- Запустить docker: `docker-compose up`
- Зайти внутрь контейнера *app*: `docker-compose exec app bash`
- Создать БД: `bundle exec rails db:create`
- Выполнить миграции: `bundle exec rails db:migrate`
- Выполнить сиды: `bundle exec rails db:seed`
- Можно отправлять запросы на *localhost:3080*

## Swagger
В докере есть сервис с свагером. Досупен по адресу: `localhost:8095`

## Тесты
Запуск тестов: `bundle exec rspec`
### Информация о покрытии тестами
После запуска тестов в папке coverage появится html-файл, который нужно открыть в браузере
#### Для Docker
Перейти по адресу: localhost:8096
#### Без Docker
Открыть в браузере файл *coverage/index.html*