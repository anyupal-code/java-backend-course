# Java Backend Course - Курс по бэкенд-разработке на Java

Курс по бэкенд-разработке на Java. От инструментов сборки и работы с базами данных до создания полноценного REST API на Spring Boot и его упаковки в Docker.

Этот курс является логическим продолжением [Java Basics Course](https://github.com/anyupal-code/java-basics-course). Здесь мы переходим от изучения синтаксиса языка к созданию реальных серверных приложений.

---

## Чему вы научитесь

* Работать с системами сборки (Maven) и управлять зависимостями.
* Настраивать профессиональное логирование (SLF4J, Logback).
* Проектировать реляционные базы данных (PostgreSQL) и писать SQL-запросы.
* Подключать базу данных к Java-приложению через JDBC и HikariCP.
* Писать юнит-тесты с помощью JUnit 5 и Mockito.
* Создавать веб-сервисы на Spring Boot (IoC, DI).
* Работать с базами данных через Spring Data JPA (Hibernate).
* Разрабатывать REST API и валидировать входящие данные.
* Обрабатывать ошибки и возвращать правильные HTTP-статусы.
* Упаковывать приложение и базу данных в Docker-контейнеры.
* Управлять конфигурацией приложения через Spring-профили.

---

## Оглавление курса

* [Урок 1. Maven и структура проекта](lesson-01-maven/README.md)
* [Урок 2. Логирование (SLF4J, Logback)](lesson-02-logging/README.md)
* [Урок 3. SQL и PostgreSQL](lesson-03-sql/README.md)
* [Урок 4. JDBC и пулы соединений](lesson-04-jdbc/README.md)
* [Урок 5. Тестирование (JUnit 5, Mockito)](lesson-05-testing/README.md)
* [Урок 6. Spring Boot: Введение (DI, IoC)](lesson-06-spring-boot/README.md)
* [Урок 7. Spring Data JPA](lesson-07-spring-data-jpa/README.md)
* [Урок 8. REST API и валидация](lesson-08-rest-api/README.md)
* [Урок 9. Обработка ошибок](lesson-09-error-handling/README.md)
* [Урок 10. Docker и Docker Compose](lesson-10-docker/README.md)
* [Урок 11. Конфигурация и профили Spring](lesson-11-spring-config/README.md)
* [Урок 12. Итоговый проект (REST-сервис в Docker)](lesson-12-final-project/README.md)

---

## Требования для запуска

* **JDK:** 17 или выше (рекомендуется LTS-версия: 21 или 25).
* **Среда разработки:** IntelliJ IDEA Community Edition.
* **Сборщик:** Maven.
* **База данных:** PostgreSQL (понадобится с третьего урока).
* **Docker и Docker Compose:** для запуска итогового проекта.

---

## Как проходить курс

1. Читаем теорию в `README.md` текущего урока.
2. Выполняем настройку окружения (если требуется).
3. Пишем код, следуя инструкциям в `TASKS.md`.
4. Сверяемся с решениями, если возникают трудности.
5. Делаем коммит после каждого пройденного урока.