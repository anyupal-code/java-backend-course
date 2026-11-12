# Урок 6. Spring Boot: Введение (DI и IoC)

## Цель урока
Понять, как работает главный Java-фреймворк для бэкенда, разобраться в принципах внедрения зависимостей (DI) и научиться создавать первое Spring Boot приложение.

---

## Теория

### 1. Что такое Spring и Spring Boot?
**Spring** — это огромная экосистема фреймворков для создания Java-приложений (от веба до работы с базами данных).
**Spring Boot** — это надстройка над Spring, которая убирает всю рутинную настройку. Вы просто добавляете нужные «стартеры» (зависимости), и Spring Boot сам настраивает всё под капотом.

### 2. Главная идея: IoC и DI
Раньше мы сами создавали объекты через `new`:
~~~java
UserService service = new UserService(new UserRepository());
~~~
В больших проектах таких зависимостей становятся сотни, и управлять ими вручную невозможно.

Spring использует **IoC (Inversion of Control)** — инверсию управления. Вы больше не создаете объекты сами. Вместо этого вы говорите Spring'у: «Вот мой класс, создай его и передай ему нужные зависимости». 
Этот процесс называется **DI (Dependency Injection)** — внедрение зависимостей.

### 3. Аннотации Spring
Чтобы Spring знал, какие классы нужно создавать и внедрять, используются аннотации:
* `@Component` — обычный компонент.
* `@Service` — бизнес-логика (сервис).
* `@Repository` — работа с базой данных.
* `@Controller` / `@RestController` — веб-контроллеры.
* `@Autowired` — говорит Spring'у «внедри сюда зависимость» (в современных версиях Spring, если у класса один конструктор, эту аннотацию можно не писать).

Пример:
~~~java
@Service
public class UserService {
    private final UserRepository repository;

    // Spring автоматически найдет UserRepository и передаст сюда
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
~~~

### 4. Создание Spring Boot проекта
Самый быстрый способ создать проект — через сайт **start.spring.io**:
1. Project: Maven.
2. Language: Java.
3. Spring Boot: выберите последнюю стабильную версию (например, 3.2.x).
4. Project Metadata: Group — `ru.example`, Artifact — `backend-app`.
5. Packaging: Jar.
6. Java: 21 (или 17).
7. **Dependencies:** добавьте `Spring Web`.
8. Нажмите **Generate**, скачайте архив, распакуйте и откройте в IDEA.

*В IDEA можно сделать то же самое: `File -> New -> Project -> Spring Boot`.*

### 5. Структура Spring Boot проекта
После распаковки вы увидите:
* `pom.xml` — с уже добавленными зависимостями и плагинами.
* `src/main/java/ru/example/backendapp/BackendAppApplication.java` — главный класс с методом `main`.
* `src/main/resources/application.properties` — файл для настроек (порт, база данных и т.д.).

Главный класс выглядит так:
~~~java
@SpringBootApplication
public class BackendAppApplication {
    public static void main(String[] args) {
        SpringApplication.run(BackendAppApplication.class, args);
    }
}
~~~
Аннотация `@SpringBootApplication` включает автоконфигурацию и сканирование компонентов.

### 6. Запуск приложения
Если вы просто запустите главный класс, приложение запустится на порту 8080 (по умолчанию). В консоли вы увидите красивый баннер Spring и запись `Started BackendAppApplication in X seconds`.

---

## Практика
В этом уроке мы создадим минимальный Spring Boot проект и проверим, что он запускается.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужен Spring Boot.
- [ ] Понимаю принципы IoC и DI.
- [ ] Знаю основные аннотации (`@Service`, `@Autowired`).
- [ ] Умею генерировать проект через start.spring.io.
- [ ] Умею запускать Spring Boot приложение.

---

## Что дальше
На следующем уроке мы подключим **Spring Data JPA** для работы с базой данных без написания SQL-запросов.