FROM python:3.9

# Author's information
LABEL maintainer="supports.maintenances@ngser.com"

# Git URL and branch
ARG URL=ssh://git@gitlab.ngser.com:9912/sms_gateway/api_sms_gateway.git 
ARG BRANCH=preprod

# Install dependences
RUN apt-get update && apt-get install -y git \
    zip \
    nano \
    libxml2-dev \
    libxmlsec1-dev \
    libpq-dev \
    gcc \
    ruby-full \
    curl \
    build-essential

# Download application source code into git
RUN mkdir /root/.ssh
ADD ./ssh-key /root/.ssh
RUN chmod 600 -R /root/.ssh/
ADD ./ssh-key /root/.ssh

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Current directory
WORKDIR /var/www/html
RUN git clone -b ${BRANCH} ${URL} .
RUN git log -3

#installation prerequis
RUN pip install --upgrade pip setuptools wheel
RUN pip install tzdata
RUN pip install backports.zoneinfo

#RUN curl https://pip.pypa.io/en/latest/topics/dependency-resolution/#dealing-with-dependency-conflicts
RUN pip install -r requirements.txt
#RUN pip install django_truncate
# Fichier de variable denvironnement
#ADD .env /var/www/html/

# Execution des migration
#RUN python manage.py makemigrations
#RUN python manage.py migrate

