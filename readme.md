# Репозиторий для проекта "Автоматическое создание задачи в Битрикс при commit в git"

## Скрипт работает по следующей схеме:
1. Необходимо скопировать в следующий каталог:
- на клиент в .git/hook/post-commit - для автоматического выполнения после commit
- на сервер .git/hook/post-receive - для автоматического выполнения после push

2. Скрипт отправляет POST запрос через ссылку в битрикс. Базовая ссылка генерируется при создании Вебхука в битрикс и по сути состоит из адреса портала, id пользователя и секретного ключа для авторизации.

## Скрипт на данном этапе умеет:
-   создать задачу, если ранее она не была создана в текущем проекте
-   добавить комментарий, если задача уже была создана ранее
-   закрыть задачу, указав в commit 'task_close'
-   назначить исполнителя, указав его в commit

## Скрипт имеет следующие особенности:
-   Для работы необходимо установить jq
-   Commit на русском языке вызывает ошибку при создании задачи.

## DockerFile собирает образ для Git-репозитория на Ubuntu
-   Устанавливает git, jq, openssh-server, python3
-   Создает пользователя Git
-   Копирует публичный сертификат
-   Создает первый репозиторий Git
-   Раздает права пользователю Git