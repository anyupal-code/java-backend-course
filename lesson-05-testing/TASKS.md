# Задания к Уроку 5

## Задание 1. Тестируем калькулятор
В этом задании мы напишем класс и сразу покроем его юнит-тестами.

1. Создайте основной класс `src/main/java/lesson05/Calculator.java`:

~~~java
package lesson05;

public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }

    public int divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Деление на ноль!");
        }
        return a / b;
    }
}
~~~

2. Создайте тестовый класс `src/test/java/lesson05/CalculatorTest.java`:

~~~java
package lesson05;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {

    @Test
    void testAddition() {
        Calculator calc = new Calculator();
        assertEquals(5, calc.add(2, 3));
        assertEquals(-1, calc.add(2, -3));
    }

    @Test
    void testDivision() {
        Calculator calc = new Calculator();
        assertEquals(2, calc.divide(10, 5));
    }

    @Test
    void testDivisionByZero() {
        Calculator calc = new Calculator();
        // Проверяем, что при делении на ноль выбрасывается именно ArithmeticException
        assertThrows(ArithmeticException.class, () -> {
            calc.divide(10, 0);
        });
    }
}
~~~

3. Запустите тесты. В IDEA можно нажать зеленую стрелку рядом с классом `CalculatorTest` (Run 'CalculatorTest') или использовать панель Maven (`Lifecycle -> test`).
**Ожидаемый результат:** все три теста должны быть пройдены (зеленая галочка).

---

## Задание 2. Тестируем сервис с Mockito
Представим, что у нас есть сервис, который зависит от базы данных. Мы протестируем его, не подключаясь к настоящей базе.

1. Создайте интерфейс репозитория `src/main/java/lesson05/UserRepository.java`:

~~~java
package lesson05;

public interface UserRepository {
    String findNameById(int id);
}
~~~

2. Создайте сервис `src/main/java/lesson05/UserService.java`:

~~~java
package lesson05;

public class UserService {
    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    public String getUserName(int id) {
        String name = repository.findNameById(id);
        return name != null ? name : "Неизвестный";
    }
}
~~~

3. Создайте тест `src/test/java/lesson05/UserServiceTest.java`:

~~~java
package lesson05;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    @Test
    void testGetUserName_UserExists() {
        // 1. Создаем mock-объект
        UserRepository mockRepo = mock(UserRepository.class);

        // 2. Настраиваем поведение
        when(mockRepo.findNameById(1)).thenReturn("Иван");

        // 3. Передаем mock в сервис
        UserService service = new UserService(mockRepo);

        // 4. Проверяем результат
        assertEquals("Иван", service.getUserName(1));

        // 5. Проверяем, что метод вызывался
        verify(mockRepo).findNameById(1);
    }

    @Test
    void testGetUserName_UserNotFound() {
        UserRepository mockRepo = mock(UserRepository.class);
        // Настраиваем на возврат null, если пользователя нет
        when(mockRepo.findNameById(99)).thenReturn(null);

        UserService service = new UserService(mockRepo);

        assertEquals("Неизвестный", service.getUserName(99));
    }
}
~~~

4. Запустите тесты через IDEA.
**Ожидаемый результат:** оба теста пройдены. Мы протестировали логику `UserService`, не подключаясь к реальной базе данных.

---

## Задание 3 (*). Покрытие тестами
В классе `Calculator` добавьте метод `multiply(int a, int b)`. 
Напишите для него тест с проверкой нескольких случаев (включая умножение на ноль и на отрицательное число).

**Решение:**

~~~java
// В Calculator.java:
public int multiply(int a, int b) {
    return a * b;
}

// В CalculatorTest.java:
@Test
void testMultiplication() {
    Calculator calc = new Calculator();
    assertEquals(15, calc.multiply(3, 5));
    assertEquals(0, calc.multiply(10, 0));
    assertEquals(-20, calc.multiply(4, -5));
}
~~~