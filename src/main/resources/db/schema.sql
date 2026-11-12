-- Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    age INT CHECK (age >= 0)
);

-- Создание таблицы книг (для нашего сквозного проекта)
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    year INT,
    is_available BOOLEAN DEFAULT TRUE
);

-- Вставка тестовых данных
INSERT INTO users (name, email, age) VALUES 
('Иван', 'ivan@example.com', 25),
('Мария', 'maria@example.com', 30);

INSERT INTO books (title, author, year) VALUES 
('Война и мир', 'Лев Толстой', 1869),
('1984', 'Джордж Оруэлл', 1949);