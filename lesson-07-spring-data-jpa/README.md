# Урок 7. Spring Data JPA

## Цель урока
Научиться работать с базой данных через Spring Data JPA, используя объекты Java вместо ручного написания SQL-запросов.

---

## Теория

### 1. Что такое JPA и Hibernate?
* **JPA (Java Persistence API)** — это стандарт (спецификация) для работы с реляционными базами данных в Java.
* **Hibernate** — самая популярная реализация JPA (движок, который выполняет всю работу).
* **Spring Data JPA** — надстройка над JPA, которая избавляет от написания шаблонного кода.

Главная идея: вы работаете с классами Java (сущностями) как с обычными объектами, а Hibernate автоматически превращает их в строки в таблицах базы данных (и наоборот).

### 2. Сущность (Entity)
Класс, который соответствует таблице в базе, помечается аннотацией `@Entity`.
Поля класса соответствуют колонкам.

~~~java
import jakarta.persistence.*;

@Entity
@Table(name = "users") // Если название таблицы не совпадает с названием класса
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Аналог SERIAL в PostgreSQL
    private Long id;

    @Column(nullable = false) // Аналог NOT NULL
    private String name;

    private int age;

    // Пустой конструктор обязателен для JPA
    public User() {}

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Геттеры и сеттеры...
}
~~~

### 3. Репозиторий (Repository)
Spring Data JPA позволяет создавать интерфейсы для доступа к данным. Вам не нужно писать реализацию — Spring сгенерирует её сам.

~~~java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // Здесь можно объявлять дополнительные методы, Spring их реализует
    List<User> findByName(String name);
    List<User> findByAgeGreaterThan(int age);
}
~~~

* `JpaRepository<User, Long>` — говорит, что этот репозиторий работает с сущностью `User`, у которой ID типа `Long`.
* Магия: если вы напишете `findByName(String name)`, Spring сам сгенерирует SQL-запрос `SELECT * FROM users WHERE name = ?`.

### 4. Основные методы JpaRepository
Даже если вы ничего не объявите в интерфейсе, вам уже доступны методы:
* `save(entity)` — сохранить или обновить.
* `findById(id)` — найти по ID (возвращает `Optional`).
* `findAll()` — получить все записи.
* `deleteById(id)` — удалить по ID.
* `count()` — количество записей.

### 5. Настройка подключения к базе
Чтобы Spring Data JPA заработал, в файл `application.properties` (в папке `resources` вашего Spring Boot проекта) нужно добавить настройки подключения к PostgreSQL:

~~~properties
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=myuser
spring.datasource.password=mypassword

# Автоматически создавать/обновлять таблицы (использовать только в разработке!)
spring.jpa.hibernate.ddl-auto=update

# Показывать SQL-запросы в консоли (удобно для отладки)
spring.jpa.show-sql=true
~~~

### 6. Использование в сервисе
В сервисном слое вы просто внедряете репозиторий и вызываете его методы:

~~~java
@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User createUser(String name, int age) {
        User user = new User(name, age);
        return userRepository.save(user); // Сохранение в базу
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}
~~~

---

## Практика
В этом уроке мы добавим сущность и репозиторий в наш Spring Boot проект.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, что такое JPA и Hibernate.
- [ ] Умею создавать сущность с `@Entity`.
- [ ] Умею создавать репозиторий через `JpaRepository`.
- [ ] Понимаю, как настраивать подключение к базе в `application.properties`.

---

## Что дальше
На следующем уроке мы создадим **REST API** — научим наше приложение общаться с внешним миром через HTTP-запросы.