FROM ubuntu

MAINTAINER Serdyukov Roman

RUN     apt-get update && \
        apt install -y --force-yes openssh-server && \
        apt-get install -y git \
        jq \
        python3 \
        curl && \
        apt-get autoclean

RUN     echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config && \
        echo 'AuthorizedKeysFile        .ssh/authorized_keys    .ssh/authorized_keys2' >> /etc/ssh/sshd_config
RUN     service ssh start

RUN     adduser --disabled-password --gecos '' git

# Копируем SSH key 
COPY    /[ssh key] /[ssh key в контейнере]

RUN     su git && \
        cd /home/git && \
        mkdir .ssh && chmod 700 .ssh && \
        touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys

RUN     cat /[ssh key в контейнере] >> /home/git/.ssh/authorized_keys && \
        chown -R git:git /home/git/.ssh

RUN     mkdir /home/git/[название проекта].git && \
        cd /home/git/[название проекта].git && \
        git init --bare

# Копируем скрипт для создания задачи в битрикс из git
COPY    ./post-commit /home/git/[название проекта].git/hooks/post-receive
RUN     chmod ugo+x /home/git/[название проекта].git/hooks/post-receive && \
        chown -R git:git /home/git/[название проекта].git

CMD ["/usr/sbin/sshd","-D"]