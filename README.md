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
