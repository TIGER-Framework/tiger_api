# TIGER API

This repository contains TIGER API funcitonality to setup and schedule tests.

## HowTo
Follow the steps below to start using it:
* Install Docker with docker-compose functionality support;
* Create ** tiger ** folder and navigate to it;
* Clone the https://github.com/TIGER-Framework/tiger_influx.git repository to the ** tiger ** folder;
* Clone this repository to the ** tiger ** folder;
* Create a docker-compose file using template below and launch all the stuff using the ** docker-compose build && docker-compose up ** command.


```hcl
version: '3' services:
  influxdb: 
    build:
      context: tiger_influx
      dockerfile: Dockerfile
    hostname: influxdb.tiger-framework.com
    domainname: tiger-framework.com
    ports:
      - 8086:8086
    volumes:
      - ./influxdb:/var/lib/influxdb
    environment:
      - INFLUXDB_ADMIN_USER=tiger_admin
      - INFLUXDB_ADMIN_PASSWORD=admin_password_to_replace
      - INFLUXDB_USER=tiger_user
      - INFLUXDB_USER_PASSWORD=user_password_to_replace
      - INFLUXDB_HTTP_AUTH_ENABLED=true
  db:
    image: postgres:9.6.18
    hostname: db.tiger-framework.com
    domainname: tiger-framework.com
    environment:
      - POSTGRES_USER=tiger_rails
      - POSTGRES_DB=tiger_rails
      - POSTGRES_PASSWORD=DB_passowrd_to_replace
    ports:
      - "5432:5432"
    volumes:
      - ./tiger_postgres/db:/var/lib/postgresql/data
  api:
    build:
      context: tiger_api
      dockerfile: Dockerfile
    image: tiger_api
    hostname: api.tiger-framework.com
    domainname: tiger-framework.com
    entrypoint: ["./docker-entrypoint.sh"]
    environment:
      - RAILS_ENV=development
      #- DATABASE_URL: postgres://10.0.2.15:5432/rails_event_store_active_record?pool=5
      - db_name=tiger_rails
      - db_username=tiger_rails
      - db_password=DB_password_to_replace
      - db_host=db
      - db_port=5432
    ports:
      - "3100:3100"
    depends_on:
      - db
      - influxdb
```
