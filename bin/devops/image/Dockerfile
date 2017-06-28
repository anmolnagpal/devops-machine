# Pull base image.
FROM phusion/baseimage:0.9.22
MAINTAINER Anmol Nagpal <ianmolnagpal@gmail.com>

#####################################
ENV PHP_MAJOR 7.1
ENV PACKER_MAJOR 1.0
ENV TERRAFORM_MAJOR 0.9

ENV PHP_VERSION 7.1.6
ENV PACKER_VERSION 1.0.2
ENV TERRAFORM_VERSION 0.9.9
ENV DEBIAN_FRONTEND noninteractive
####################################

#General
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y      \
	curl                    \
	git                     \
	zip                     \
	unzip                   \
	vim                     \
	ruby-full               \
	openssh-server          \
	zsh                     \
	figlet                  \
	sysvbanner              \
	htop                    \
	python-pip              \
	wget                    \
	sudo                    \
	inetutils-ping          \
	telnet

ENV BOOT2DOCKER_ID 501
ENV BOOT2DOCKER_GID 20
# Tweaks to give write permissions to the app
RUN usermod -u ${BOOT2DOCKER_ID} ubuntu && \
    usermod -G staff ubuntu
    
# ZSH
ADD ./etc/install-zsh.sh /root/install-zsh.sh
ADD ./etc/install-zsh.sh /home/ubuntu/install-zsh.sh
RUN chmod +x /root/install-zsh.sh
RUN chmod +x /home/ubuntu/install-zsh.sh
RUN sh /root/install-zsh.sh
RUN su - ubuntu -c sh /home/ubuntu/install-zsh.sh"
RUN rm /root/.zshrc && chsh -s `which zsh` && chsh -s `which zsh` ubuntu && chmod -R 755 /usr/local/share/zsh*


#PHP
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8
RUN add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y          \
    php7.1                      \
    php7.1-fpm                  \
    php7.1-common               \
    php7.1-cli                  \
    php7.1-curl                 \
    php7.1-gd                   \
    php7.1-gmp                  \
    php7.1-imap                 \
    php7.1-intl                 \
    php7.1-mcrypt               \
    php7.1-json                 \
    php7.1-mysql                \
    php7.1-opcache              \
    php7.1-bz2                  \
    php7.1-bcmath               \
    php7.1-mbstring             \
    php7.1-soap                 \
    php7.1-xml                  \
    php7.1-zip                  \
    php7.1-mongodb              \
    php-amqp                    \
    php-redis                   \
    pkg-config                  \
    libssl-dev                  \
    libsslcommon2-dev

RUN phpenmod mongodb mcrypt soap curl amqp

#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#Python with Packages
RUN pip install --upgrade bumpversion pip   ansible awscli mongotail

#Terraform
RUN apt-get update && \
    apt-get install bash ca-certificates git openssl unzip wget -y && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

#Packer
RUN cd /tmp && \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/apk/**
WORKDIR /var/www