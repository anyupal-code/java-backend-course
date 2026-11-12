# Урок 10. Docker и Docker Compose

## Цель урока
Понять, зачем нужна контейнеризация, научиться упаковывать Spring Boot приложение в Docker-образ и запускать его вместе с базой данных через Docker Compose.

---

## Теория

### 1. Что такое Docker?
Docker — это платформа для создания, доставки и запуска приложений в **контейнерах**.
Контейнер — это легковесная среда, которая содержит всё необходимое для работы приложения: код, библиотеки, настройки и даже операционную систему (обычно Linux).

**Проблема без Docker:** «У меня работает на Fedora, а на сервере Ubuntu — нет».
**Решение с Docker:** приложение работает в одинаковом контейнере везде.

### 2. Dockerfile
`Dockerfile` — это текстовый файл с инструкциями по сборке Docker-образа (как рецепт).

Пример простого `Dockerfile` для Spring Boot:

~~~dockerfile
# 1. Базовый образ с JDK
FROM eclipse-temurin:21-jdk-alpine

# 2. Рабочая директория внутри контейнера
WORKDIR /app

# 3. Копируем собранный jar-файл в контейнер
COPY target/backend-app-0.0.1-SNAPSHOT.jar app.jar

# 4. Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
~~~

*Важно: перед сборкой Docker-образа нужно сначала скомпилировать проект через `mvn clean package`, чтобы появился `.jar` в папке `target`.*

### 3. Как собрать и запустить контейнер
Собрать образ:
~~~bash
docker build -t backend-app .
~~~

Запустить контейнер:
~~~bash
docker run -p 8080:8080 backend-app
~~~
`-p 8080:8080` — пробрасывает порт 8080 из контейнера в ваш компьютер.

### 4. Docker Compose
В реальном проекте приложение работает не одно. Ему нужна база данных (PostgreSQL), возможно, Redis для кэша и т.д.
Запускать каждый контейнер вручную (`docker run`) неудобно.

**Docker Compose** позволяет описать все сервисы в одном файле `docker-compose.yml` и запустить их одной командой.

Пример `docker-compose.yml`:

~~~yaml
version: '3.8'

services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"

  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/mydb
      SPRING_DATASOURCE_USERNAME: myuser
      SPRING_DATASOURCE_PASSWORD: mypassword
~~~

* `depends_on` — говорит, что приложение нужно запускать после базы данных.
* `SPRING_DATASOURCE_URL` — переопределяет настройки базы данных через переменные окружения (Spring Boot автоматически их подхватывает).
* `db` в URL — это имя сервиса (контейнера) с базой, оно работает как хостнейм внутри Docker-сети.

### 5. Запуск через Docker Compose
~~~bash
docker-compose up --build
~~~
* `--build` — пересобрать образ приложения, если изменился код.
* Для остановки нажмите `Ctrl+C` или выполните `docker-compose down` (это также удалит контейнеры).

---

## Практика
В этом уроке мы добавим `Dockerfile` и `docker-compose.yml` в наш Spring Boot проект.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужна контейнеризация.
- [ ] Умею писать `Dockerfile`.
- [ ] Умею собирать и запускать Docker-контейнер.
- [ ] Понимаю, как работает `docker-compose` с двумя сервисами.

---

## Что дальше
На следующем уроке разберем **конфигурацию и профили Spring** (dev, prod).