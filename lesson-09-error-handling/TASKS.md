# Задания к Уроку 9

## Задание 1. Создание класса для ответа об ошибке
1. В пакете `ru.example.backendapp` создайте пакет `exception`.
2. Внутри создайте класс `ErrorResponse.java`:

~~~java
package ru.example.backendapp.exception;

public class ErrorResponse {
    private int status;
    private String message;

    public ErrorResponse(int status, String message) {
        this.status = status;
        this.message = message;
    }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
~~~

---

## Задание 2. Создание собственного исключения
1. В пакете `exception` создайте класс `ResourceNotFoundException.java`:

~~~java
package ru.example.backendapp.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
~~~

---

## Задание 3. Создание глобального обработчика
1. В пакете `exception` создайте класс `GlobalExceptionHandler.java`:

~~~java
package ru.example.backendapp.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // Обработка 404 (Ресурс не найден)
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage());
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    // Обработка 400 (Ошибка валидации)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String errorMessage = ex.getBindingResult().getFieldErrors()
                .stream()
                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.joining(", "));
        
        ErrorResponse error = new ErrorResponse(HttpStatus.BAD_REQUEST.value(), errorMessage);
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }

    // Обработка всех остальных ошибок (500)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleAll(Exception ex) {
        ErrorResponse error = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), 
                "Внутренняя ошибка сервера: " + ex.getMessage());
        return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
~~~

---

## Задание 4. Использование исключения в сервисе
1. Откройте `UserService.java`.
2. Добавьте метод для поиска пользователя по ID, который будет выбрасывать наше исключение, если пользователь не найден:

~~~java
public User getUserById(Long id) {
    return userRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Пользователь с ID " + id + " не найден"));
}
~~~
*(Не забудьте импортировать `ResourceNotFoundException`)*

3. В `UserController` добавьте эндпоинт для получения одного пользователя:

~~~java
@GetMapping("/{id}")
public User getUserById(@PathVariable Long id) {
    return userService.getUserById(id);
}
~~~

---

## Задание 5. Проверка работы
1. Запустите приложение.
2. В браузере попробуйте запросить несуществующего пользователя: `http://localhost:8080/api/users/999`.
   **Ожидаемый результат:** вместо стандартной ошибки Spring вы увидите красивый JSON:
   ~~~json
   {
     "status": 404,
     "message": "Пользователь с ID 999 не найден"
   }
   ~~~

3. Попробуйте отправить POST-запрос с некорректными данными (через терминал или Postman):

~~~bash
curl -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name": "", "age": -5}'
~~~

   **Ожидаемый результат:** статус 400 и JSON с перечнем ошибок валидации (какие поля не прошли проверку).