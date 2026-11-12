# Задания к Уроку 2

## Задание 1. Подключаем логирование
Добавьте зависимости SLF4J и Logback в ваш `pom.xml` (если еще не сделали этого).

Создайте в папке `src/main/java/lesson02/` класс `LoggingExample.java`:

~~~java
package lesson02;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoggingExample {
    // Создаем логгер
    private static final Logger logger = LoggerFactory.getLogger(LoggingExample.class);

    public static void main(String[] args) {
        logger.info("Приложение запущено.");
        
        String userName = "Иван";
        int age = 25;
        
        // Используем плейсхолдеры
        logger.info("Пользователь {} вошел в систему, возраст: {}", userName, age);
        
        try {
            int result = 10 / 0;
            logger.info("Результат: {}", result);
        } catch (ArithmeticException e) {
            // Логируем ошибку и передаем сам объект исключения (чтобы был стектрейс)
            logger.error("Произошла ошибка при делении на ноль", e);
        }
        
        logger.warn("Программа завершает работу.");
    }
}
~~~

**Что сделать:**
1. Соберите проект через терминал: `mvn clean package`.
2. Запустите класс `LoggingExample` через IDE (зеленая стрелка).

**Ожидаемый результат:**
В консоли вы увидите красиво отформатированный вывод с датой, временем, уровнем важности (`INFO`, `WARN`, `ERROR`) и именем класса. Ошибка выведет полный стектрейс (trace).

---

## Задание 2. Настройка Logback
По умолчанию Logback выводит логи в консоль. Но мы можем настроить его так, чтобы он также писал их в файл.

1. В папке `src/main/resources/` создайте файл `logback.xml` (если папки нет — создайте её).

2. Вставьте в файл следующий код:

~~~xml
<configuration>
    <!-- Вывод в консоль -->
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- Вывод в файл -->
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>app.log</file>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- Применяем оба аппендера к корневому логгеру -->
    <root level="INFO">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
~~~

3. Снова запустите `LoggingExample.java`.
4. Посмотрите в корень проекта — там должен появиться файл `app.log` с теми же сообщениями.

*Уровень `root level="INFO"` означает, что сообщения уровней `TRACE` и `DEBUG` будут проигнорированы.*