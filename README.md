# lealni_infra
lealni Infra repository

## Home Work №3
## Знакомство с облачной инфраструктурой

Параметры подключения:
```
bastion_IP = 35.207.110.203
someinternalhost_IP = 10.156.0.3
```

Для подключения к серверу во внутренней сети в одну команду необходимо выполнить следующее:

1. Запустить ssh-agent
```exec ssh-agent bash``` (для CentOS)) если не запущен
2. Добавить приватный ключ в ssh агент
```ssh-add ~/.ssh/appuser```
3. Можно подлючаться
```ssh -A appuser@35.207.110.203 -t 'ssh 10.156.0.3'```

Подключение с локального АРМ к серверу во внутренеей сети:

1. Создать конфигурационый файл ssh
```touch ~/.ssh/config```
2. Внести в файл следующую информацию
```
Host bastion       
ForwardAgent yes
Hostname 35.207.110.203
User appuser

Host someinternalhost 
ProxyCommand ssh -q bastion nc -q0 10.156.0.3 22
```

## Home Work №4
## Основные сервисы GCP

Параметры подключения:
```
testapp_IP = 35.228.252.20
testapp_port = 9292
```
### Деплой приложения

1. Скрипт ```install_ruby.sh``` устанавливает Ruby
2. скрипт ```install_mongodb.sh``` устанавливает MongoDB
3. Скрипт ```deploy.sh``` устанавливает приложение

4. Для создание инстанса и его настройки необходимо выполнить скрипт ``` gcloud_deploy.sh ```

Команда для создания инстанса с приминением startup script

```
gcloud compute instances create reddit-app\
  --zone=europe-north1-a \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=./setup_script.sh
```

5. Для создания правила firewall использовать команду:

```
gcloud compute firewall-rules create default-puma-server\
  --allow tcp:9292
```

## Home Work №5
## Модели управления инфраструктурой


1. Шаблон создания базового образа ```packer/ubuntu16.json``` настройка осуществляется скриптами
    - ```packer/scripts/install_mongodb.sh```
    - ```packer/scripts/install_ruby.sh```

2. Переменные вынесены в файл ```variables.json```, пример заполнения приведен в файле ```variables.json.example```

3. Команда запуска создания базового образа в папке packer:
```packer build -var-file variables.json ubuntu16.json```

4. Шаблон создания образа с установленым приложением ```packer/immutable.json```:
    - Установка приложения осущесвляется скриптом ```packer/scripts/deploy.sh```
    - Unit-script автозапуска приложения расположен в ```packer/files/reddit.service```
    - Настройка автозапуска описана в скрипте ```startup_reddit.sh```

5. Команда запуска создания полного образа на основе базового в папке packer:
```packer build -var-file variables.json immutable.json```

6. Создание инстанса в GCP с запущенным приложением осуществляется скриптом ```config-scripts/create-reddit-vm.sh```
    1- Команда запуска
       ```./config-scripts/create-reddit-vm.sh project_id``` , где project_id - id проекта в google cloud
