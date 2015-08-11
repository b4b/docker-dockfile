FROM ubuntu:trusty
MAINTAINER Tyrik Zhao <t@tyrik.io>

ENTRYPOINT echo "Welcome!"

ADD app/ /app/

RUN apt-get install -y curl software-properties-common zip unzip && apt-get update
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
ENTRYPOINT node -v && npm -v
RUN cd /app/
RUN curl -L https://ghost.org/zip/ghost-latest.zip -o ghost.zip
RUN unzip ghost.zip
RUN sed 's/127.0.0.1/0.0.0.0/' /ghost/config.example.js > /ghost/config.js && \
RUN npm install --production
RUN npm install -g pm2 
RUN NODE_ENV=production pm2 start index.js --name "ghost"

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD config/default.conf /etc/nginx/default.conf


EXPOSE 2368
EXPOSE 80
EXPOSE 443

# Define default command.
CMD ["/usr/sbin/nginx"]
CMD ["app", "/app"]

