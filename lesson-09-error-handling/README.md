# Урок 9. Обработка ошибок в REST API

## Цель урока
Научиться перехватывать исключения по всему приложению и возвращать клиенту понятные JSON-ответы с правильными HTTP-статусами (400, 404, 500).

---

## Теория

### 1. Зачем нужна глобальная обработка?
Если в контроллере произойдет ошибка (например, `NullPointerException`), Spring по умолчанию вернет огромный стектрейс. Это небезопасно (может раскрыть внутреннюю структуру кода) и неудобно для клиента.
Клиент (например, мобильное приложение или фронтенд) ожидает получить JSON вида:
~~~json
{
  "status": 404,
  "message": "Пользователь с ID 99 не найден"
}
~~~

### 2. @RestControllerAdvice
Аннотация `@RestControllerAdvice` позволяет создать класс, который будет перехватывать исключения из **любых** контроллеров.

~~~java
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    // Обработчики ошибок будут здесь
}
~~~

### 3. Обработка конкретных исключений
Внутри этого класса мы пишем методы с аннотацией `@ExceptionHandler`, указывая, какое исключение они перехватывают.

~~~java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ExceptionHandler(ResourceNotFoundException.class)
public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
    ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
    return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
}
~~~

* `ResponseEntity` позволяет задать не только тело ответа (JSON), но и HTTP-статус (404, 400, 500).
* `HttpStatus.NOT_FOUND` — это и есть 404.

### 4. Создание своих исключений
Для бизнес-ошибок лучше создавать собственные исключения. Например, `ResourceNotFoundException`.

~~~java
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
~~~

В сервисе мы будем их выбрасывать:
~~~java
public User getUserById(Long id) {
    return userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Пользователь с ID " + id + " не найден"));
}
~~~

### 5. Обработка ошибок валидации (@Valid)
Если данные не прошли валидацию, Spring выбрасывает `MethodArgumentNotValidException`. Мы можем перехватить её и красиво оформить список ошибок по каждому полю.

~~~java
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
    // Извлекаем все ошибки из исключения
    String errorMessage = ex.getBindingResult().getFieldErrors()
            .stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.joining(", "));
    
    ErrorResponse error = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), errorMessage);
    return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
}
~~~

### 6. Класс для ответа об ошибке
Создадим простой класс `ErrorResponse` для единого формата ошибок.

~~~java
public class ErrorResponse {
    private int status;
    private String message;

    public ErrorResponse(int status, String message) {
        this.status = status;
        this.message = message;
    }

    // Геттеры...
}
~~~

---

## Практика
В этом уроке мы добавим глобальный обработчик ошибок и научим API возвращать статус 404 для несуществующих пользователей.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужна глобальная обработка ошибок.
- [ ] Умею использовать `@RestControllerAdvice`.
- [ ] Умею перехватывать исключения через `@ExceptionHandler`.
- [ ] Умею возвращать правильные HTTP-статусы через `ResponseEntity`.

---

## Что дальше
На следующем уроке мы упакуем наше приложение в **Docker**, чтобы его можно было запустить на любом сервере одной командой.