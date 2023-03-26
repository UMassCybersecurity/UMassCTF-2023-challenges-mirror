FROM ubuntu:20.04


RUN apt-get update -y
RUN apt-get install -y python3-pip python3-dev build-essential

RUN useradd -d /home/ctf/ -m -p ctf -s /bin/bash ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf

COPY . .

RUN chown -R root:root /home/ctf
RUN chmod +x /home/ctf/ynetd

USER ctf
EXPOSE 2207
CMD ./ynetd -p 2207 "python3 blackjack.py"
