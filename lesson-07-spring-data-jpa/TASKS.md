# Задания к Уроку 7

## Задание 1. Подключение зависимостей
В этом задании мы будем работать в нашем Spring Boot проекте `backend-app` (который создали в прошлом уроке).

1. Откройте файл `pom.xml` вашего Spring Boot проекта.
2. Добавьте две зависимости: Spring Data JPA и драйвер PostgreSQL.

~~~xml
<dependencies>
    <!-- Spring Web (уже есть) -->
    <!-- ... -->

    <!-- Spring Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <!-- Драйвер PostgreSQL -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
~~~

3. Обновите проект в IDEA (нажмите на значок Maven в правом верхнем углу -> `Reload All Maven Projects`).

---

## Задание 2. Настройка подключения к базе
1. Откройте файл `src/main/resources/application.properties`.
2. Добавьте туда настройки подключения к вашей базе `mydb`:

~~~properties
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=myuser
spring.datasource.password=mypassword
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
~~~

*(Если ваша база данных называется иначе, измените URL и данные пользователя).*

---

## Задание 3. Создание сущности
1. В пакете `ru.example.backendapp` создайте новый пакет `model`.
2. Внутри создайте класс `User.java`:

~~~java
package ru.example.backendapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private int age;

    public User() {} // Обязательно для JPA

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Геттеры и сеттеры (можно сгенерировать через Alt+Insert)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}
~~~

---

## Задание 4. Создание репозитория
1. В пакете `ru.example.backendapp` создайте пакет `repository`.
2. Внутри создайте интерфейс `UserRepository.java`:

~~~java
package ru.example.backendapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.example.backendapp.model.User;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // Spring сам реализует этот метод
    List<User> findByAgeGreaterThan(int age);
}
~~~

---

## Задание 5. Использование в сервисе
1. В пакете `ru.example.backendapp` создайте пакет `service`.
2. Внутри создайте класс `UserService.java`:

~~~java
package ru.example.backendapp.service;

import org.springframework.stereotype.Service;
import ru.example.backendapp.model.User;
import ru.example.backendapp.repository.UserRepository;

import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User createUser(String name, int age) {
        User user = new User(name, age);
        return userRepository.save(user);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}
~~~

---

## Задание 6 (*). Проверка работы
Чтобы увидеть, как JPA сохраняет данные, измените класс `AppRunner` (созданный в прошлом уроке) следующим образом:

~~~java
package ru.example.backendapp.service;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import ru.example.backendapp.model.User;

@Component
public class AppRunner implements CommandLineRunner {
    private final UserService userService;

    public AppRunner(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void run(String... args) throws Exception {
        // Создаем двух пользователей
        userService.createUser("Иван", 25);
        userService.createUser("Мария", 30);

        // Читаем всех из базы
        System.out.println("--- Список пользователей из БД ---");
        for (User user : userService.getAllUsers()) {
            System.out.println(user.getId() + ": " + user.getName() + ", " + user.getAge());
        }
    }
}
~~~

3. Запустите приложение. 
4. В консоли вы увидите SQL-запросы, которые Hibernate сгенерировал автоматически (благодаря `show-sql=true`), а затем список пользователей.
5. Зайдите в базу данных через `psql` и проверьте таблицу `users` — данные там сохранились!