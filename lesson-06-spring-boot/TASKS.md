# Задания к Уроку 6

## Задание 1. Создание проекта Spring Boot

В этом уроке мы отойдем от ручного создания файлов в нашем текущем проекте и создадим отдельное Spring Boot приложение.

1. Перейдите на сайт **[start.spring.io](https://start.spring.io/)**.
2. Настройте проект следующим образом:
   * **Project:** Maven
   * **Language:** Java
   * **Spring Boot:** выберите версию без пометки `(SNAPSHOT)` или `(MILESTONE)` (например, 3.2.x или 3.3.x).
   * **Project Metadata:**
     * Group: `ru.example`
     * Artifact: `backend-app`
     * Name: `backend-app`
     * Packaging: Jar
     * Java: 21 (или 17)
   * **Dependencies:** нажмите `ADD DEPENDENCIES` и выберите **Spring Web**.
3. Нажмите кнопку **GENERATE** (скачается zip-архив).
4. Распакуйте архив в удобную папку (например, `~/projects/backend-app`).
5. Откройте IntelliJ IDEA, выберите `File -> Open` и укажите папку `backend-app` (туда, где лежит `pom.xml`).
6. Дождитесь, пока IDEA скачает зависимости (внизу будет прогресс-бар Maven).

---

## Задание 2. Запуск приложения

1. Откройте главный класс `src/main/java/ru/example/backendapp/BackendAppApplication.java`.
2. Нажмите зеленую стрелку `Run` слева от метода `main`.
3. В консоли вы должны увидеть:
   * Логотип Spring (баннер).
   * Строку `Tomcat started on port 8080`.
   * Строку `Started BackendAppApplication in X.XXX seconds`.

Поздравляю, ваше первое веб-приложение запущено! Оно пока ничего не делает, но уже слушает порт 8080 и готово принимать запросы. Чтобы остановить приложение, нажмите красную кнопку `Stop` в IDEA.

---

## Задание 3 (*). Создание компонента (DI)

Давайте проверим, как работает внедрение зависимостей (DI).

1. В папке `src/main/java/ru/example/backendapp/` создайте пакет `service`.
2. Внутри создайте класс `GreetingService.java`:

~~~java
package ru.example.backendapp.service;

import org.springframework.stereotype.Service;

@Service
public class GreetingService {
    
    public String getGreeting() {
        return "Привет из Spring Boot!";
    }
}
~~~

3. В том же пакете создайте класс `AppRunner.java` (или добавьте его в главный пакет):

~~~java
package ru.example.backendapp.service;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class AppRunner implements CommandLineRunner {
    private final GreetingService greetingService;

    // Spring автоматически внедрит GreetingService сюда (DI)
    public AppRunner(GreetingService greetingService) {
        this.greetingService = greetingService;
    }

    @Override
    public void run(String... args) throws Exception {
        // Этот код выполнится сразу после запуска приложения
        System.out.println(greetingService.getGreeting());
    }
}
~~~

4. Снова запустите главный класс `BackendAppApplication`.
5. В консоли, среди логов Spring, вы должны найти строку `Привет из Spring Boot!`.

**Что произошло?**
Spring увидел, что `AppRunner` требует `GreetingService`. Он сам создал объект `GreetingService` (потому что над ним стоит `@Service`) и передал его в конструктор `AppRunner`. Вам не пришлось писать `new GreetingService()`.