# Jetbase Rails REST API

[![Build Status](https://travis-ci.org/jetbase-io/jetbase-rails.svg?branch=master)](https://travis-ci.org/jetbase-io/jetbase-rails)

Swagger API: https://raw.githubusercontent.com/jetbase-io/jetbase-swagger/master/swagger.yml

# Running rails server in docker

In order to start rails api inside of docker run the following commands

```
docker-compose build
```
_this command will build a docker image of rails app_

```
docker-compose up
```
_this command will start rails app in docker_

_next step we should create database_

```
docker-compose run jetbase-rails rake db:create

docker-compose run jetbase-rails rake db:migrate
```
_this two commands will create DB and runn migrations_

