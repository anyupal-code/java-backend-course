# Урок 11. Конфигурация и профили Spring

## Цель урока
Научиться разделять настройки приложения для разных сред (разработка, тестирование, продакшн) с помощью профилей Spring и переменных окружения.

---

## Теория

### 1. Проблема разных сред
На вашем компьютере база данных работает на `localhost:5432`, а на сервере — на `db:5432`. 
Локально вы хотите видеть SQL-запросы в консоли (`show-sql=true`), а на продакшене это будет засорять логи.
Если хранить все настройки в одном `application.properties`, придется постоянно их менять вручную перед деплоем.

### 2. Файлы профилей
Spring Boot позволяет создавать отдельные файлы настроек для каждой среды:
* `application.properties` — базовые настройки (общие для всех).
* `application-dev.properties` — настройки для разработки.
* `application-prod.properties` — настройки для продакшна.

### 3. Активация профиля
Чтобы Spring понял, какой профиль использовать, его нужно активировать.
* В файле `application.properties`:
  ~~~properties
  spring.profiles.active=dev
  ~~~
* Либо через переменную окружения (например, в Docker):
  ~~~bash
  export SPRING_PROFILES_ACTIVE=prod
  ~~~

### 4. Что писать в профилях
**`application-dev.properties` (для разработки):**
~~~properties
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=myuser
spring.datasource.password=mypassword
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
~~~

**`application-prod.properties` (для продакшна):**
~~~properties
# На сервере база данных доступна по имени сервиса (в Docker)
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.jpa.show-sql=false
spring.jpa.hibernate.ddl-auto=validate
~~~

*Обратите внимание на `${DB_URL}` — это **переменные окружения**. На продакшене вы не храните пароли в коде, а передаете их через Docker Compose или настройки сервера.*

### 5. Внешние переменные (Environment Variables)
Spring Boot автоматически подхватывает переменные окружения. 
Например, если в системе есть переменная `DB_PASSWORD`, вы можете использовать её в `application.properties`:
~~~properties
spring.datasource.password=${DB_PASSWORD}
~~~

### 6. Зачем нужен ddl-auto=validate в prod?
* `update` — Hibernate сам добавляет новые колонки и таблицы. Это удобно в разработке, но опасно в продакшне (можно случайно удалить данные).
* `validate` — Spring проверяет, что структура базы данных соответствует сущностям, но ничего не меняет. Если есть несоответствия — приложение упадет с ошибкой при запуске.

---

## Практика
В этом уроке мы настроим профили `dev` и `prod` для нашего Spring Boot проекта.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужны профили.
- [ ] Умею создавать файлы `application-{profile}.properties`.
- [ ] Знаю, как активировать профиль через `spring.profiles.active`.
- [ ] Понимаю, как использовать переменные окружения `${...}`.
- [ ] Знаю разницу между `ddl-auto=update` и `validate`.

---

## Что дальше
На финальном уроке мы соберем всё вместе и сделаем **Итоговый проект** — полноценный REST-сервис в Docker.