FROM node:18
RUN apt update 
RUN apt install nginx -y
WORKDIR /app
COPY package.json .
RUN npm i
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY . . 
RUN chmod +x entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]