# Задания к Уроку 4

## Задание 1. Подключение к базе данных
В этом задании мы настроим зависимости и напишем простой класс, который проверяет подключение к PostgreSQL.

1. Откройте `pom.xml` и добавьте драйвер PostgreSQL и HikariCP в блок `<dependencies>`:

~~~xml
<dependencies>
    <!-- Драйвер PostgreSQL -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <version>42.7.2</version>
    </dependency>
    
    <!-- Пул соединений HikariCP -->
    <dependency>
        <groupId>com.zaxxer</groupId>
        <artifactId>HikariCP</artifactId>
        <version>5.1.0</version>
    </dependency>
</dependencies>
~~~

2. Создайте класс `src/main/java/lesson04/DatabaseConnection.java`:

~~~java
package lesson04;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseConnection {
    private static HikariDataSource dataSource;

    static {
        // Настройка пула соединений
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/mydb");
        config.setUsername("myuser");
        config.setPassword("mypassword");
        config.setMaximumPoolSize(10);
        
        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void main(String[] args) {
        // Проверяем подключение
        try (Connection conn = getConnection()) {
            System.out.println("Успешное подключение к базе данных!");
        } catch (SQLException e) {
            System.out.println("Ошибка подключения: " + e.getMessage());
        }
    }
}
~~~

3. Запустите класс `DatabaseConnection.java`.
**Ожидаемый результат:** в консоли должно появиться сообщение "Успешное подключение к базе данных!". Если вы видите ошибку — проверьте, что PostgreSQL запущен и данные (URL, логин, пароль) верны.

---

## Задание 2. Чтение данных из базы
Теперь давайте прочитаем данные из таблицы `users`, которую мы создали в прошлом уроке.

Создайте класс `src/main/java/lesson04/ReadUsers.java`:

~~~java
package lesson04;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReadUsers {
    public static void main(String[] args) {
        String sql = "SELECT id, name, age FROM users";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            System.out.println("Список пользователей:");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int age = rs.getInt("age");
                System.out.println(id + ": " + name + ", возраст " + age);
            }

        } catch (SQLException e) {
            System.out.println("Ошибка при чтении данных: " + e.getMessage());
        }
    }
}
~~~

Запустите класс. Вы должны увидеть список пользователей, которых мы добавили через SQL-скрипты.

---

## Задание 3 (*). Добавление данных из Java
Напишите метод, который добавляет нового пользователя в базу данных. Используйте `PreparedStatement`.

Создайте класс `src/main/java/lesson04/InsertUser.java`:

~~~java
package lesson04;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class InsertUser {
    public static void main(String[] args) {
        String sql = "INSERT INTO users (name, email, age) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Устанавливаем значения для плейсхолдеров
            pstmt.setString(1, "Алексей");
            pstmt.setString(2, "alexey@example.com");
            pstmt.setInt(3, 28);

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Добавлено строк: " + rowsAffected);

        } catch (SQLException e) {
            System.out.println("Ошибка при добавлении: " + e.getMessage());
        }
    }
}
~~~

Запустите класс, а затем снова запустите `ReadUsers.java`, чтобы убедиться, что новый пользователь появился в базе.