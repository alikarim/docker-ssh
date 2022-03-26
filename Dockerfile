FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# Prevents interaction while installing or upgrading the system via apt. Accepts the default answer for all questions. 
ARG DEBIAN_FRONTEND=noninteractive
ARG $port

RUN apt update -y && \
    apt install -y \
        nano \
        openssh-client \
        openssh-server

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

ADD ssh/id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa.pub

RUN touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN sed -ie 's/.*Port 22$/Port 2200/g' /etc/ssh/sshd_config
RUN sed -ie 's/.*PasswordAuthentication yes$/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ie 's/.*UsePAM yes$/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ie 's/.*ChallengeResponseAuthentication yes$/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config

ADD ssh/whitelist.txt /tmp/whitelist.txt
RUN echo 'sshd: ALL' >> /etc/hosts.deny
RUN cat /tmp/whitelist.txt >> /etc/hosts.allow

EXPOSE $port

ENTRYPOINT service ssh restart && bash