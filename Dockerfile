FROM ubuntu:14.04

MAINTAINER Anmol Nagpal <ianmolnagpal@gmail.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install software-properties-common python-software-properties -y
# Nginx
RUN add-apt-repository ppa:nginx/stable

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install python-software-properties pwgen python-setuptools curl git unzip vim \
            openssl git git-core htop rsyslog zip vim-common multitail sysvbanner figlet python-pip zsh wget telnet libpcre3 libpcre3-dev ssh

RUN apt-get install -y openssh-server

RUN pip install awscli

RUN mkdir -p /var/run/sshd

RUN sudo useradd ubuntu
RUN passwd -d ubuntu
RUN passwd -d root
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
RUN chsh -s `which bash` ubuntu
RUN usermod -d /home/ubuntu ubuntu
RUN mkdir -p /home/ubuntu
RUN ssh-keygen -t rsa1 -f /etc/ssh/ssh_host_rsa_key -y
RUN ssh-keygen -t dsa  -f /etc/ssh/ssh_host_dsa_key -y
RUN mkdir -p /home/ubuntu/.ssh
RUN chmod 755 /home/ubuntu/.ssh
ADD ./id_rsa /home/ubuntu/.ssh/authorized_keys
RUN chmod 600 /home/ubuntu/.ssh/authorized_keys
RUN chown -R ubuntu:ubuntu /home/ubuntu
RUN chmod 755 /home/ubuntu
# Install zsh
ADD ./files/install-zsh.sh /root/install-zsh.sh
ADD ./files/install-zsh.sh /home/ubuntu/install-zsh.sh

RUN chmod +x /root/install-zsh.sh
RUN chmod +x /home/ubuntu/install-zsh.sh
RUN sh /root/install-zsh.sh

RUN su - ubuntu -c "sh /home/ubuntu/install-zsh.sh"

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN rm  /root/.zshrc
ADD ./files/zshrc /root/.zshrc
ADD ./files/zshrc /home/ubuntu/.zshrc

RUN chsh -s `which zsh` ubuntu
RUN chsh -s `which zsh`

RUN chmod -R 755 /usr/local/share/zsh/site-functions

# Java
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
# automatically accept oracle license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 8 oracle jdk
RUN apt-get -y install oracle-java8-installer && apt-get clean
RUN update-alternatives --display java
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#Ansible
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get install ansible -y



#PHP
RUN export LANG=C.UTF-8 && sudo add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get -y install \
        php7.0-fpm   \
        php7.0   \
        php7.0-common   \
        php7.0-cli   \
        php7.0-curl   \
        php7.0-gd   \
        php7.0-gmp   \
        php7.0-imap   \
        php7.0-interbase   \
        php7.0-intl   \
        php7.0-mcrypt   \
        php7.0-readline   \
        php7.0-tidy   \
        php7.0-xmlrpc   \
        php7.0-xsl   \
        php7.0-json   \
        php7.0-mysql   \
        php7.0-opcache   \
        php-apcu   \
        php-redis    \
        php-apcu-bc   \
        php-amqp   \
        php7.0-bz2   \
        php7.0-bcmath    \
        php7.0-mbstring    \
        php7.0-soap   \
        php7.0-xml   \
        php7.0-zip   \
        php-pear   \
        php-mongodb \
        php7.0-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer self-update

# Terraform
ENV PATH $PATH:/usr/local/bin
ENV TERRAFORM_VER 0.8.2
ENV TERRAFORM_ZIP terraform_${TERRAFORM_VER}_linux_amd64.zip

RUN apt-get update && apt-get -y install wget unzip openssh-client
RUN set -ex \
       && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/${TERRAFORM_ZIP} -O /tmp/$TERRAFORM_ZIP
RUN unzip /tmp/$TERRAFORM_ZIP -d /usr/local/bin
RUN chmod 775 /usr/local/bin/terra*
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Define default command.
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]