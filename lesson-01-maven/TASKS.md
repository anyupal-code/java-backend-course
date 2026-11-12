# Задания к Уроку 1

## Задание 1. Создание Maven-проекта с нуля
В этом задании мы создадим проект вручную, чтобы понять, как он устроен изнутри (IDEA потом делает это автоматически, но важно знать базу).

1. В корне вашего репозитория `java-backend-course` создайте файл `pom.xml` и вставьте в него код из теории (раздел 3).
2. В папке `src/main/java/lesson01/` создайте файл `Main.java`:

~~~java
package lesson01;

public class Main {
    public static void main(String[] args) {
        System.out.println("Maven-проект успешно собран!");
    }
}
~~~

3. Откройте терминал в корне проекта (там, где лежит `pom.xml`) и выполните команду для компиляции и сборки:

~~~bash
mvn clean package
~~~

*(Maven скачает необходимые плагины и создаст папку `target/` с готовым `.jar` файлом).*

4. Запустите программу через Maven:

~~~bash
mvn exec:java -Dexec.mainClass="lesson01.Main"
~~~

**Ожидаемый результат:**
Вы должны увидеть в консоли: `Maven-проект успешно собран!`

---

## Задание 2. Добавление зависимости
Теперь давайте подключим стороннюю библиотеку. В Java есть встроенный класс `String`, но для сложной обработки текста часто используют `Apache Commons Lang`.

1. Откройте `pom.xml` и добавьте в него блок `<dependencies>`:

~~~xml
<dependencies>
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.14.0</version>
    </dependency>
</dependencies>
~~~

2. Обновите `Main.java`, чтобы использовать новую библиотеку:

~~~java
package lesson01;

import org.apache.commons.lang3.StringUtils;

public class Main {
    public static void main(String[] args) {
        String text = "   Привет, Maven!   ";
        
        // Используем метод из библиотеки Apache Commons Lang
        String trimmed = StringUtils.trim(text);
        String reversed = StringUtils.reverse(trimmed);
        
        System.out.println("Оригинал: '" + text + "'");
        System.out.println("Без пробелов: '" + trimmed + "'");
        System.out.println("Перевернуто: '" + reversed + "'");
    }
}
~~~

3. Снова запустите сборку и программу:

~~~bash
mvn clean package
mvn exec:java -Dexec.mainClass="lesson01.Main"
~~~

**Ожидаемый результат:**
Вы должны увидеть, что программа использует методы `StringUtils`, которых нет в стандартной библиотеке Java. Maven автоматически скачал эту библиотеку из репозитория.