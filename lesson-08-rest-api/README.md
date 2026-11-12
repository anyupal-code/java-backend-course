# Урок 8. REST API и валидация

## Цель урока
Научиться создавать REST-контроллеры в Spring Boot, обрабатывать HTTP-запросы (GET, POST) и валидировать входящие данные.

---

## Теория

### 1. Что такое REST API?
REST (Representational State Transfer) — это архитектурный стиль для создания веб-сервисов. В REST мы работаем с **ресурсами** (например, пользователями или книгами), и для каждого действия используем свой HTTP-метод:
* `GET` — получить данные (список пользователей или одного пользователя).
* `POST` — создать новый ресурс.
* `PUT` / `PATCH` — обновить существующий ресурс.
* `DELETE` — удалить ресурс.

Данные обычно передаются в формате **JSON**.

### 2. Аннотация @RestController
Чтобы Spring знал, что класс обрабатывает HTTP-запросы, его помечают аннотацией `@RestController`.

~~~java
@RestController
@RequestMapping("/api/users")
public class UserController {
    // ...
}
~~~

* `@RestController` = `@Controller` + `@ResponseBody` (автоматически превращает возвращаемый объект в JSON).
* `@RequestMapping("/api/users")` задает базовый путь для всех методов в классе.

### 3. Обработка GET-запросов
~~~java
@GetMapping
public List<User> getAllUsers() {
    return userService.getAllUsers();
}

@GetMapping("/{id}")
public User getUserById(@PathVariable Long id) {
    return userService.getUserById(id);
}
~~~
* `@GetMapping` — обрабатывает GET-запрос по пути `/api/users`.
* `@GetMapping("/{id}")` — обрабатывает GET-запрос по пути `/api/users/1`.
* `@PathVariable` — берет значение `{id}` из URL и передает его в параметр метода.

### 4. Обработка POST-запросов
Для создания нового ресурса используется `@PostMapping` и аннотация `@RequestBody` (она берет JSON из тела запроса и превращает его в Java-объект).

~~~java
@PostMapping
public User createUser(@RequestBody User user) {
    return userService.createUser(user.getName(), user.getAge());
}
~~~

### 5. Валидация данных
Если пользователь отправит пустое имя или отрицательный возраст, это может сломать базу данных. Чтобы этого избежать, используется валидация.
1. Добавьте зависимость в `pom.xml`:
   ~~~xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-validation</artifactId>
   </dependency>
   ~~~
2. Поставьте аннотации над полями в классе сущности (или DTO):
   ~~~java
   public class User {
       @NotBlank(message = "Имя не может быть пустым")
       private String name;

       @Min(value = 0, message = "Возраст не может быть отрицательным")
       private int age;
   }
   ~~~
3. В контроллере добавьте аннотацию `@Valid`:
   ~~~java
   @PostMapping
   public User createUser(@Valid @RequestBody User user) {
       return userService.createUser(user.getName(), user.getAge());
   }
   ~~~
Если данные не пройдут проверку, Spring автоматически вернет HTTP-статус 400 (Bad Request) с описанием ошибок.

### 6. Как тестировать API?
Когда приложение запущено, вы можете отправлять запросы через:
* Браузер (только GET-запросы).
* Консоль (`curl`).
* Специальные программы (Postman, Insomnia).

Например, чтобы получить всех пользователей, в браузере откройте: `http://localhost:8080/api/users`.

---

## Практика
В этом уроке мы добавим контроллер в наш проект и научимся отправлять запросы.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю принципы REST и основные HTTP-методы.
- [ ] Умею создавать контроллер с `@RestController`.
- [ ] Умею обрабатывать GET-запросы (`@GetMapping`).
- [ ] Умею обрабатывать POST-запросы (`@PostMapping`, `@RequestBody`).
- [ ] Умею добавлять валидацию через `@Valid`.

---

## Что дальше
На следующем уроке разберем **обработку ошибок** (`@ControllerAdvice`), чтобы API возвращал понятные сообщения вместо стандартных ошибок Spring.