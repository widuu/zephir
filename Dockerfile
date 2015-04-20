# zephir lang Dockerfile
FROM ubuntu:14.04
# 签名啦
MAINTAINER widuu "admin@widuu.com"
# 变换阿里云镜像源
RUN  sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup
ADD ./sources.list /etc/apt/sources.list
# 更新镜像源 
RUN apt-get update
# 安装开发环境
RUN apt-get  install gcc make re2c libpcre3 libpcre3-dev php5 php5-dev php5-json -y
# 安装ssh server
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/ss
# 安装git
RUN apt-get install git -y
# clone zephir 并安装
RUN cd /root && \
        git clone https://github.com/phalcon/zephir && \
        cd zephir && \
        ./install-json && \
        ./install -c

# 设置root ssh远程登录密码为docker
RUN echo 'root:docker' | chpasswd

EXPOSE 22

EXPOSE 80

EXPOSE 443

# SSH终端服务器作为后台运行
CMD ["/usr/sbin/sshd", "-D"]
