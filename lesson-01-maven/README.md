# Урок 1. Maven и структура проекта

## Цель урока
Понять, зачем нужны сборщики проектов, установить Maven, разобраться в стандартной структуре Java-проекта и научиться управлять зависимостями.

---

## Теория

### 1. Зачем нужен сборщик?
До этого мы запускали код прямо в IntelliJ IDEA. Для маленьких учебных файлов это удобно. Но реальные проекты состоят из десятков и сотен файлов.
Чтобы скомпилировать их в один `.jar` файл, подключить сторонние библиотеки (зависимости) и запустить тесты, используется **сборщик проектов**.

Два самых популярных сборщика в Java — это **Maven** и **Gradle**. Мы будем изучать Maven, так как он до сих пор занимает огромную долю корпоративного рынка.

### 2. Установка Maven
В Linux (Fedora) Maven устанавливается через пакетный менеджер:

~~~bash
sudo dnf install maven
~~~

Проверить установку можно командой:
~~~bash
mvn -version
~~~

*(В Windows и macOS Maven устанавливается аналогично через скачивание архива или менеджеры пакетов, например `brew install maven`).*

### 3. Файл pom.xml
Сердце любого Maven-проекта — это файл `pom.xml` (Project Object Model). В нем описывается:
* Название проекта и версия.
* Версия Java.
* **Зависимости** (библиотеки, которые использует проект).
* Плагины для сборки.

Пример простого `pom.xml`:

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>ru.example</groupId>
    <artifactId>java-backend-course</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>25</maven.compiler.source>
        <maven.compiler.target>25</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
</project>
~~~

### 4. Стандартная структура проекта
Maven навязывает строгую структуру папок. Если файлы лежат не там, Maven их не увидит.
* `src/main/java` — здесь лежит основной код.
* `src/main/resources` — здесь лежат ресурсы (картинки, конфигурационные файлы).
* `src/test/java` — здесь лежат тесты.

### 5. Добавление зависимостей
Зависимости прописываются в блоке `<dependencies>`. 
Например, чтобы добавить библиотеку для работы с JSON (Gson), мы добавим:

~~~xml
<dependencies>
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.10.1</version>
    </dependency>
</dependencies>
~~~

Maven сам скачает эту библиотеку из интернета и подключит к проекту. Больше не нужно вручную искать `.jar` файлы.

---

## Практика
В этом уроке мы создадим минимальный Maven-проект.
Переходите к [Заданиям](TASKS.md).

---

## Чек-лист
- [ ] Понимаю, зачем нужен сборщик проектов.
- [ ] Умею проверять версию Maven в терминале.
- [ ] Знаю, что такое `pom.xml`.
- [ ] Понимаю стандартную структуру папок (`src/main/java`).
- [ ] Умею добавлять зависимости в `pom.xml`.

---

## Что дальше
На следующем уроке разберем **логирование (SLF4J и Logback)** вместо использования `System.out.println`.