# Урок 5. Тестирование: JUnit 5 и Mockito

## Цель урока
Понять, зачем нужно писать тесты, научиться использовать JUnit 5 для проверки логики и Mockito для изоляции зависимостей.

---

## Теория

### 1. Зачем писать тесты?
Представьте, что вы добавили новую функцию и случайно сломали старую. Без тестов вы узнаете об этом только от пользователей. 
Тесты — это код, который проверяет другой код. Они запускаются за секунды и сразу показывают, что сломалось.

**Пирамида тестирования:**
* **Юнит-тесты** (много) — проверяют отдельные методы и классы в изоляции.
* **Интеграционные тесты** (меньше) — проверяют, как компоненты работают вместе (например, код + база данных).
* **E2E-тесты** (мало) — проверяют всю систему с точки зрения пользователя.

Мы начнем с **юнит-тестов**.

### 2. JUnit 5
JUnit — стандартный фреймворк для тестирования в Java.
Чтобы начать, добавьте зависимость в `pom.xml`:

~~~xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.2</version>
    <scope>test</scope>
</dependency>
~~~

*Атрибут `<scope>test</scope>` означает, что эта библиотека нужна только для тестов и не попадет в финальную сборку.*

### 3. Первый тест
Тесты лежат в папке `src/test/java/` (зеркально структуре `src/main/java/`).

~~~java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {

    @Test
    void testAddition() {
        Calculator calc = new Calculator();
        int result = calc.add(2, 3);
        
        // Проверяем, что результат равен 5
        assertEquals(5, result);
    }
}
~~~

* `@Test` — помечает метод как тест.
* `assertEquals(ожидаемое, фактическое)` — проверяет равенство.

Основные методы проверки (ассерты):
* `assertEquals(a, b)` — равны ли значения.
* `assertTrue(условие)` / `assertFalse(условие)` — проверка логического значения.
* `assertNull(obj)` / `assertNotNull(obj)` — проверка на null.
* `assertThrows(Exception.class, () -> ...)` — проверяет, что код выбрасывает исключение.

### 4. Mockito
Представьте, что ваш класс `UserService` обращается к базе данных. В юнит-тесте мы не хотим подключаться к настоящей базе (это медленно и ненадежно). 
Вместо этого мы используем **заглушку** (mock), которая имитирует поведение базы.

**Mockito** — самая популярная библиотека для создания таких заглушек.
Добавьте зависимость в `pom.xml`:

~~~xml
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.11.0</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-junit-jupiter</artifactId>
    <version>5.11.0</version>
    <scope>test</scope>
</dependency>
~~~

### 5. Пример с Mockito
Допустим, у нас есть `UserRepository` (работа с базой) и `UserService` (логика).

~~~java
// Тестируемый класс
public class UserService {
    private UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public String getUserName(int id) {
        String name = repository.findNameById(id);
        return name != null ? name : "Неизвестный";
    }
}
~~~

В тесте мы «подсовываем» фейковый репозиторий:

~~~java
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    @Test
    void testGetUserName_UserExists() {
        // 1. Создаем mock-объект
        UserRepository mockRepo = mock(UserRepository.class);

        // 2. Настраиваем поведение: если вызовут findNameById(1), верни "Иван"
        when(mockRepo.findNameById(1)).thenReturn("Иван");

        // 3. Передаем mock в сервис
        UserService service = new UserService(mockRepo);

        // 4. Проверяем результат
        assertEquals("Иван", service.getUserName(1));
        
        // 5. Проверяем, что метод репозитория действительно вызывался
        verify(mockRepo).findNameById(1);
    }
}
~~~

`when(...).thenReturn(...)` — настройка поведения. `verify(...)` — проверка того, что метод был вызван.

---

## Практика
В этом уроке мы напишем тесты для простого калькулятора и сервиса с mock-зависимостью.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужны тесты.
- [ ] Умею писать тесты с аннотацией `@Test`.
- [ ] Использую `assertEquals` и `assertThrows`.
- [ ] Умею создавать mock-объекты через Mockito.
- [ ] Понимаю, зачем нужен `<scope>test</scope>`.

---

## Что дальше
На следующем уроке мы начнем изучать **Spring Boot** — главный фреймворк для бэкенд-разработки.