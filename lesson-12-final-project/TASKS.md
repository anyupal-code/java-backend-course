# Итоговый проект. Пошаговая инструкция

В этом задании мы свяжем книги и читателей, а также добавим логику выдачи книги.

## Шаг 1. Создание сущности Reader

В пакете `ru.example.backendapp.model` создайте класс `Reader.java`:

~~~java
package ru.example.backendapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "readers")
public class Reader {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    public Reader() {}
    public Reader(String name) { this.name = name; }

    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}
~~~

## Шаг 2. Обновление сущности Book (связь с Reader)

В классе `Book.java` добавьте поле `reader` и связь `@ManyToOne`.
Теперь книга знает, кто её взял.

~~~java
@Entity
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    private String author;

    private boolean isAvailable = true;

    // Связь: много книг могут быть выданы одному читателю
    @ManyToOne
    @JoinColumn(name = "reader_id") // Имя колонки в БД
    private Reader reader;

    // Конструкторы, геттеры и сеттеры
    public Book() {}
    public Book(String title, String author) {
        this.title = title;
        this.author = author;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }
    public Reader getReader() { return reader; }
    public void setReader(Reader reader) { this.reader = reader; }
}
~~~

## Шаг 3. Репозитории

Создайте `ReaderRepository.java`:

~~~java
package ru.example.backendapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.example.backendapp.model.Reader;

public interface ReaderRepository extends JpaRepository<Reader, Long> {
}
~~~

Обновите `BookRepository.java`, добавив поиск по доступности:

~~~java
import java.util.List;
import ru.example.backendapp.model.Book;

public interface BookRepository extends JpaRepository<Book, Long> {
    List<Book> findByIsAvailable(boolean isAvailable);
}
~~~

## Шаг 4. Бизнес-логика (BookService)

Создайте `BookService.java` (или обновите существующий). 
Здесь мы реализуем выдачу книги.

~~~java
package ru.example.backendapp.service;

import org.springframework.stereotype.Service;
import ru.example.backendapp.exception.ResourceNotFoundException;
import ru.example.backendapp.model.Book;
import ru.example.backendapp.model.Reader;
import ru.example.backendapp.repository.BookRepository;
import ru.example.backendapp.repository.ReaderRepository;

import java.util.List;

@Service
public class BookService {
    private final BookRepository bookRepository;
    private final ReaderRepository readerRepository;

    public BookService(BookRepository bookRepository, ReaderRepository readerRepository) {
        this.bookRepository = bookRepository;
        this.readerRepository = readerRepository;
    }

    public Book createBook(Book book) {
        return bookRepository.save(book);
    }

    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    public Book getBookById(Long id) {
        return bookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Книга не найдена"));
    }

    // Выдача книги читателю
    public Book issueBook(Long bookId, Long readerId) {
        Book book = getBookById(bookId);
        Reader reader = readerRepository.findById(readerId)
                .orElseThrow(() -> new ResourceNotFoundException("Читатель не найден"));

        if (!book.isAvailable()) {
            throw new RuntimeException("Книга уже выдана"); // В реальном проекте используйте кастомное исключение
        }

        book.setAvailable(false);
        book.setReader(reader);
        return bookRepository.save(book);
    }
}
~~~

## Шаг 5. Проверка через Docker
1. Соберите проект: `mvn clean package -DskipTests`.
2. Запустите: `docker-compose up --build`.
3. Через Postman или `curl` создайте книгу:
   ~~~bash
   curl -X POST http://localhost:8080/api/books -H "Content-Type: application/json" -d '{"title":"Java Book", "author":"Author"}'
   ~~~
4. Создайте читателя (нужно будет добавить `ReaderController` по аналогии с `UserController`).
5. Выдайте книгу через новый эндпоинт (например, `POST /api/books/1/issue?readerId=1`).
~~~
