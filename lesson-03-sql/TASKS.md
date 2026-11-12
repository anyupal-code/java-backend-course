# Задания к Уроку 3

## Задание 1. Применяем схему базы данных
1. Убедитесь, что PostgreSQL установлен и запущен (см. теорию).
2. Подключитесь к вашей базе данных (например, через терминал: `psql -U myuser -d mydb`).
3. Скопируйте содержимое файла `src/main/resources/db/schema.sql` и выполните его в консоли PostgreSQL.
4. Проверьте, что таблицы создались:
   ~~~sql
   \dt
   ~~~
   *(Должны появиться таблицы `users` и `books`).*

## Задание 2. SQL-запросы
В той же консоли PostgreSQL напишите и выполните следующие запросы:

1. Выведите всех пользователей старше 20 лет.
2. Добавьте новую книгу: "Мастер и Маргарита", "Михаил Булгаков", 1967.
3. Выведите все доступные книги (`is_available = true`), отсортированные по году выпуска (от старых к новым).
4. Обновите возраст пользователя "Иван" на 26 лет.
5. Удалите книгу "1984".

**Решения (примеры):**

~~~sql
-- 1
SELECT * FROM users WHERE age > 20;

-- 2
INSERT INTO books (title, author, year) VALUES ('Мастер и Маргарита', 'Михаил Булгаков', 1967);

-- 3
SELECT * FROM books WHERE is_available = true ORDER BY year ASC;

-- 4
UPDATE users SET age = 26 WHERE name = 'Иван';

-- 5
DELETE FROM books WHERE title = '1984';
~~~

## Задание 3 (*). Связь таблиц
Создайте таблицу `orders` (заказы), которая ссылается на `users`:
* `id` (SERIAL PRIMARY KEY)
* `user_id` (INT, внешний ключ на `users.id`)
* `product` (VARCHAR)
* `amount` (DECIMAL)

Внешний ключ задается так: `FOREIGN KEY (user_id) REFERENCES users(id)`.
Добавьте один заказ для пользователя "Мария" и напишите `JOIN`-запрос, чтобы вывести имя пользователя и название товара.

**Решение:**

~~~sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product VARCHAR(100),
    amount DECIMAL(10, 2)
);

INSERT INTO orders (user_id, product, amount) 
VALUES ((SELECT id FROM users WHERE name = 'Мария'), 'Книга "Java"', 1500.00);

SELECT users.name, orders.product, orders.amount
FROM users
JOIN orders ON users.id = orders.user_id;
~~~