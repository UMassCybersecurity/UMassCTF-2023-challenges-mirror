# Stolen from https://github.com/LiveOverflow/pwn_docker_example/blob/master/challenge/Dockerfile

# sudo docker build -t pwn01_baby_overflow_i .
# sudo docker run -d -p 1024:1024 --rm -it pwn01_baby_overflow_i

FROM ubuntu:20.04


RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential
RUN pip install -U pip setuptools wheel
RUN pip install -U spacy
RUN python3 -m spacy download en_core_web_md

RUN useradd -d /home/ctf/ -m -p ctf -s /bin/bash ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf

COPY . .

RUN chown -R root:root /home/ctf
RUN chmod +x /home/ctf/ynetd

USER ctf
EXPOSE 1116
CMD ./ynetd -p 1116 "python3 jeopardy.py"
