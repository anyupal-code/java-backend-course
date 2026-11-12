# Задания к Уроку 11

## Задание 1. Создание профилей
В этом задании мы разделим настройки для локальной разработки и для Docker (продакшн).

1. Откройте папку `src/main/resources` вашего Spring Boot проекта.
2. Создайте файл `application-dev.properties` и вставьте туда настройки для локальной разработки:

~~~properties
# Локальная база данных
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=myuser
spring.datasource.password=mypassword

# Показывать SQL в консоли и обновлять схему
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
~~~

3. Создайте файл `application-prod.properties` для работы в Docker:

~~~properties
# База данных берется из переменных окружения (которые мы зададим в docker-compose)
spring.datasource.url=${SPRING_DATASOURCE_URL}
spring.datasource.username=${SPRING_DATASOURCE_USERNAME}
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}

# Не показывать SQL и только проверять схему (безопасность)
spring.jpa.show-sql=false
spring.jpa.hibernate.ddl-auto=validate
~~~

4. Откройте основной файл `application.properties` и укажите профиль по умолчанию:

~~~properties
# По умолчанию используем профиль dev
spring.profiles.active=dev
~~~

---

## Задание 2. Обновление docker-compose.yml
Теперь настроим Docker Compose так, чтобы приложение запускалось в профиле `prod` и передавало правильные переменные окружения.

1. Откройте ваш `docker-compose.yml` (из прошлого урока).
2. Обновите сервис `app`, добавив переменную `SPRING_PROFILES_ACTIVE`:

~~~yaml
  app:
    build: .
    container_name: library-app
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      # Указываем, что используем профиль prod
      SPRING_PROFILES_ACTIVE: prod
      
      # Переменные для подключения к базе (Spring подхватит их)
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/mydb
      SPRING_DATASOURCE_USERNAME: myuser
      SPRING_DATASOURCE_PASSWORD: mypassword
~~~

*(Обратите внимание: в `application-prod.properties` мы ссылаемся на `${SPRING_DATASOURCE_URL}`, и Docker Compose передает это значение в контейнер).*

---

## Задание 3. Проверка работы
1. Убедитесь, что ваш локальный PostgreSQL запущен.
2. Запустите приложение локально (в IDEA). 
   * В консоли вы должны увидеть SQL-запросы (`show-sql=true`), так как активен профиль `dev`.
3. Остановите приложение.
4. Запустите приложение через Docker Compose:
   ~~~bash
   docker-compose up --build
   ~~~
   * В логах Docker вы **не должны** видеть SQL-запросы, так как активен профиль `prod`.
   * Приложение должно успешно подключиться к базе внутри Docker.

---

## Задание 4 (*). Переопределение настроек
Вы можете переопределить профиль, не меняя `application.properties`. 
Попробуйте запустить приложение локально через терминал, указав профиль `prod` (убедитесь, что у вас есть переменные окружения для базы):

~~~bash
SPRING_PROFILES_ACTIVE=prod mvn spring-boot:run
~~~

*(Этот способ полезен, если вы хотите быстро проверить, как приложение ведет себя с другими настройками).*