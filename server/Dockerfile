FROM centos:latest

RUN yum update -y
RUN yum install -y curl
RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
RUN yum install -y nodejs

COPY dist /app
COPY node_modules /app/node_modules

ENV MONGO_HOST 172.31.43.124
ENV NODE_ENV production
ENV JWT_PASSWORD testing

EXPOSE 8081

CMD ["node", "/app/server.js"]
