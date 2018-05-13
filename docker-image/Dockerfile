# Pull base image.
FROM phusion/baseimage:0.10.1
MAINTAINER Anmol Nagpal <ianmolnagpal@gmail.com>

#####################################
ENV LANG C.UTF-8
ENV LC_ALL en_US.UTF-8

ENV PHP_MAJOR 7.2
ENV PACKER_MAJOR 1.2
ENV TERRAFORM_MAJOR 0.11
ENV ANSIBLE_MAJOR 2.5
ENV LINT_VERSION 3.5.0rc1
ENV REVIEW_VERSION 0.13.4
###
ENV PHP_VERSION 7.2.5
ENV PACKER_VERSION 1.2.3
ENV TERRAFORM_VERSION 0.11.7
ENV ANSIBLE_VERSION 2.5.2
ENV DEBIAN_FRONTEND noninteractive
####################################

#password less ssh
ADD ./etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
ADD ./etc/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub

#User
RUN useradd ubuntu
RUN passwd -d ubuntu
RUN passwd -d root
RUN chmod 600 /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
RUN chsh -s `which bash` ubuntu
RUN usermod -d /home/ubuntu ubuntu
RUN mkdir -p /home/ubuntu
RUN mkdir -p /home/ubuntu/.ssh
RUN chmod 755 /home/ubuntu/.ssh
RUN chown -R ubuntu:ubuntu /home/ubuntu
RUN chmod 755 /home/ubuntu
ENV BOOT2DOCKER_ID 501
ENV BOOT2DOCKER_GID 20
# Tweaks to give write permissions to the app
RUN usermod -u ${BOOT2DOCKER_ID} ubuntu && \
    usermod -G staff ubuntu
RUN groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && groupmod -g ${BOOT2DOCKER_GID} staff


#General
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y      \
	curl                   \
	git                    \
	zip                    \
	unzip                  \
	vim                    \
	ruby-full              \
	openssh-server         \
	zsh                    \
	figlet                 \
	sysvbanner             \
	htop                   \
	python-pip             \
	python3-pip            \
	wget                   \
	ca-certificates        \
	openssl                \
	yamllint               \
	inetutils-ping         \
	telnet                 \
	libssl-dev

# ZSH
ADD ./etc/install-zsh.sh /root/install-zsh.sh
ADD ./etc/install-zsh.sh /home/ubuntu/install-zsh.sh
RUN chmod +x /root/install-zsh.sh
RUN chmod +x /home/ubuntu/install-zsh.sh
RUN sh /root/install-zsh.sh
RUN su - ubuntu -c "sh /home/ubuntu/install-zsh.sh"
RUN rm /root/.zshrc && chsh -s `which zsh` && chsh -s `which zsh` ubuntu && chmod -R 755 /usr/local/share/zsh*

#PHP
RUN add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y          \
    php7.2                      \
    php7.2-common               \
    php7.2-cli                  \
    php7.2-curl                 \
    php7.2-json                 \
    php7.2-bz2                  \
    php7.2-xml                  \
    php7.2-zip                  \
    pkg-config

RUN phpenmod curl

#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

##Python with Packages
RUN pip3 install ansible==${ANSIBLE_VERSION} \
                 ansible-lint==${LINT_VERSION} \
                 ansible-review==${REVIEW_VERSION} \
                 awscli \
                 mongotail \
                 bumpversion \
                 pip \
                 yamllint

#Terraform
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

#Packer
RUN cd /tmp && \
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ /var/cache/apk/**
WORKDIR /var/www

# Define default command.
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
