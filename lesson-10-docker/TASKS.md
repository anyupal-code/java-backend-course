# Задания к Уроку 10

## Задание 1. Создание Dockerfile
В этом задании мы упакуем наше Spring Boot приложение `backend-app` в Docker-контейнер.

1. В корне вашего Spring Boot проекта (там, где лежит `pom.xml` и папка `src`) создайте файл `Dockerfile` (без расширения).
2. Вставьте в него следующий код:

~~~dockerfile
# Используем легковесный образ с JDK 21
FROM eclipse-temurin:21-jdk-alpine

# Создаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем собранный jar-файл в контейнер
# Убедитесь, что имя файла совпадает с тем, что генерирует ваш pom.xml
COPY target/backend-app-0.0.1-SNAPSHOT.jar app.jar

# Открываем порт 8080
EXPOSE 8080

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
~~~

*Примечание: Если вы не уверены в имени jar-файла, соберите проект (`mvn clean package`) и посмотрите в папку `target/`.*

---

## Задание 2. Создание docker-compose.yml
Чтобы приложение и база данных работали вместе, опишем их в одном файле.

1. В корне Spring Boot проекта создайте файл `docker-compose.yml`.
2. Вставьте в него следующий код:

~~~yaml
version: '3.8'

services:
  db:
    image: postgres:16-alpine
    container_name: library-db
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    ports:
      - "5433:5432"  # Пробрасываем на 5433, чтобы не конфликтовать с локальным PostgreSQL
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    container_name: library-app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/mydb
      SPRING_DATASOURCE_USERNAME: myuser
      SPRING_DATASOURCE_PASSWORD: mypassword
      SPRING_JPA_HIBERNATE_DDL_AUTO: update

volumes:
  postgres_data:
~~~

*Обратите внимание на порт базы данных: мы используем `5433` снаружи, чтобы не было конфликта, если у вас уже запущен локальный PostgreSQL на 5432. Внутри Docker-сети приложение все равно обращается к порту `5432`.*

---

## Задание 3. Сборка и запуск
1. Откройте терминал в корне Spring Boot проекта.
2. Соберите приложение (чтобы появился `.jar` файл):
   ~~~bash
   mvn clean package -DskipTests
   ~~~
   *(Флаг `-DskipTests` нужен, чтобы не запускать тесты при сборке, так как мы не хотим, чтобы они падали из-за отсутствия локальной базы данных).*

3. Запустите Docker Compose:
   ~~~bash
   docker-compose up --build
   ~~~

**Ожидаемый результат:**
* В терминале вы увидите логи запуска базы данных PostgreSQL и вашего Spring Boot приложения.
* Приложение запустится и будет слушать порт 8080.
* В логах Spring вы должны увидеть, что он подключился к базе данных и создал таблицы (благодаря `ddl-auto: update`).

4. Откройте браузер и проверьте: `http://localhost:8080/api/users`. Приложение должно работать так же, как и локально!

---

## Задание 4 (*). Остановка и очистка
1. Чтобы остановить контейнеры, нажмите `Ctrl+C` в терминале или выполните в новом терминале:
   ~~~bash
   docker-compose down
   ~~~
2. Если вы хотите удалить и данные из базы (очистить volume), выполните:
   ~~~bash
   docker-compose down -v
   ~~~
   *(Флаг `-v` удаляет volume, где хранились данные).*