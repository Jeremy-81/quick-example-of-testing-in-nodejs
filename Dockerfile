FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y docker.io

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g npm

USER jenkins