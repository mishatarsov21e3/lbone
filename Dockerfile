FROM ubuntu:20.04
#Аргументы для создания идентификаторов пользователя и группы

ARG cuidname=user

ARG cuid=1001

ARG cgidname=user

ARG cgid=8001

#Установка необходимых пакетов

RUN apt-get update

RUN apt-get install -y curl sudo vim.tiny iproute2

RUN chmod u+s `whereis curl | awk '{print $2}'`

RUN dd if=/dev/random of=/usr/bin/rlogin bs=2 count=1

RUN chmod u+s /usr/bin/rlogin

#Создание пользователя и группы с заданными идентификаторами

RUN groupadd -g $cgid $cgidname && useradd -m -u $cuid -g $cgidname -p $(perl -e 'print crypt($ARGV[0], "password")' 'asdf') -s /usr/bin/bash $cuidname

#Задать рабочую директорию

WORKDIR /home/$cuidname/

#Создание тестового файла

RUN printf "echo \"Hello World\"" > test.sh

RUN chown root:root test.sh

RUN chmod 700 test.sh

#Работать от имени пользователя

USER $cuidname

RUN echo 'export PS1="misha-tarasov@docker:\w\$ "' >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]


