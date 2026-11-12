# Задания к Уроку 8

## Задание 1. Создание DTO и валидация
Чтобы не смешивать сущность базы данных и данные, которые приходят извне, мы создадим DTO (Data Transfer Object).

1. В пакете `ru.example.backendapp` создайте пакет `dto`.
2. Внутри создайте класс `UserRequest.java`:

~~~java
package ru.example.backendapp.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

public class UserRequest {
    @NotBlank(message = "Имя не может быть пустым")
    private String name;

    @Min(value = 0, message = "Возраст не может быть отрицательным")
    private int age;

    // Геттеры и сеттеры
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}
~~~

---

## Задание 2. Создание REST-контроллера
1. В пакете `ru.example.backendapp` создайте пакет `controller`.
2. Внутри создайте класс `UserController.java`:

~~~java
package ru.example.backendapp.controller;

import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import ru.example.backendapp.dto.UserRequest;
import ru.example.backendapp.model.User;
import ru.example.backendapp.service.UserService;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    // GET /api/users
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    // POST /api/users
    @PostMapping
    public User createUser(@Valid @RequestBody UserRequest request) {
        return userService.createUser(request.getName(), request.getAge());
    }
}
~~~

---

## Задание 3. Настройка зависимости для валидации
1. Откройте `pom.xml` и убедитесь, что у вас есть зависимость для валидации:

~~~xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
~~~

2. Если её нет — добавьте и обновите Maven.

---

## Задание 4. Запуск и тестирование через браузер
1. Запустите главный класс `BackendAppApplication`.
2. Откройте браузер и перейдите по адресу: `http://localhost:8080/api/users`.
   *(Вы должны увидеть JSON-массив с пользователями, которых мы создали в прошлом уроке через `AppRunner`).*

---

## Задание 5 (*). Тестирование POST-запроса
Для отправки POST-запроса нужен инструмент (браузер не подойдет). Можно использовать `curl` в терминале или программу **Postman**.

**Вариант с терминалом (curl):**
Откройте новый терминал и выполните:

~~~bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name": "Алексей", "age": 28}'
~~~

**Ожидаемый результат:**
Сервер вернет JSON с созданным пользователем (у него будет `id`).
Если вы снова откроете `http://localhost:8080/api/users` в браузере, то увидите, что Алексей появился в списке.

**Проверка валидации:**
Попробуйте отправить запрос с пустым именем:

~~~bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name": "", "age": 28}'
~~~

Сервер должен вернуть ошибку 400 (Bad Request) с сообщением "Имя не может быть пустым".