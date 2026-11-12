# Урок 4. JDBC и пулы соединений

## Цель урока
Научиться подключать Java-программу к базе данных PostgreSQL с помощью JDBC, выполнять SQL-запросы из кода и использовать пул соединений (HikariCP) для повышения производительности.

---

## Теория

### 1. Что такое JDBC?
JDBC (Java Database Connectivity) — это стандартный API (набор классов и интерфейсов), который позволяет Java-программам взаимодействовать с базами данных.
Производители баз данных (PostgreSQL, MySQL, Oracle) выпускают свои **драйверы** — библиотеки, которые реализуют JDBC для конкретной СУБД.

Чтобы подключить PostgreSQL, нужно добавить в `pom.xml` зависимость драйвера:

~~~xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.2</version>
</dependency>
~~~

### 2. Основные интерфейсы JDBC
* `Connection` — соединение с базой данных.
* `Statement` — объект для отправки SQL-запросов.
* `PreparedStatement` — «предварительно скомпилированный» запрос (безопасный, защищает от SQL-инъекций).
* `ResultSet` — таблица с результатами `SELECT`-запроса.

### 3. Установка соединения
Для подключения нужен URL, логин и пароль.

~~~java
String url = "jdbc:postgresql://localhost:5432/mydb";
String user = "myuser";
String password = "mypassword";

try (Connection conn = DriverManager.getConnection(url, user, password)) {
    System.out.println("Подключение успешно!");
} catch (SQLException e) {
    System.out.println("Ошибка подключения: " + e.getMessage());
}
~~~
*Конструкция `try-with-resources` автоматически закрывает соединение после использования (даже если произошла ошибка).*

### 4. Выполнение запросов
Для безопасности всегда используйте `PreparedStatement` с плейсхолдерами `?`.

~~~java
String sql = "SELECT id, name, age FROM users WHERE age > ?";
try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
    pstmt.setInt(1, 20); // Подставляем значение вместо первого ?
    
    try (ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
            int id = rs.getInt("id");
            String name = rs.getString("name");
            int age = rs.getInt("age");
            System.out.println(id + ": " + name + ", " + age);
        }
    }
}
~~~

### 5. Зачем нужен пул соединений?
Открытие нового соединения с базой данных — дорогая операция (занимает время и ресурсы). Если приложение открывает и закрывает соединение на каждый запрос, оно будет работать медленно.
**Пул соединений** (Connection Pool) — это набор заранее созданных соединений, которые переиспользуются.

Самый популярный пул в Java — **HikariCP**. Он быстрый и надежный. Добавим его в `pom.xml`:

~~~xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.1.0</version>
</dependency>
~~~

Пример настройки HikariCP:

~~~java
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:postgresql://localhost:5432/mydb");
config.setUsername("myuser");
config.setPassword("mypassword");
config.setMaximumPoolSize(10); // Максимум 10 соединений

HikariDataSource dataSource = new HikariDataSource(config);
~~~

Теперь вместо `DriverManager.getConnection()` мы получаем соединение из пула:
~~~java
try (Connection conn = dataSource.getConnection()) {
    // Работа с базой данных
}
~~~

---

## Практика

В этом уроке мы создадим класс, который подключается к нашей базе данных и выполняет запросы. 
Код будет лежать в `src/main/java/lesson04/`.

Переходите к [Заданиям](TASKS.md) для пошаговой инструкции.

---

## Чек-лист
- [ ] Понимаю, что такое JDBC и для чего нужен драйвер базы данных.
- [ ] Умею подключаться к базе через `DriverManager`.
- [ ] Умею выполнять запросы через `PreparedStatement`.
- [ ] Понимаю, зачем нужен пул соединений (HikariCP).

---

## Что дальше
На следующем уроке разберем **тестирование (JUnit 5 и Mockito)**.