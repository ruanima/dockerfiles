FROM centos:centos7 as builder
WORKDIR /workdir
RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
RUN yum -y group install "Development Tools"
RUN git clone https://github.com/prebuilder/statifier.git
RUN yum -y install libgcc.i686 glibc-devel.i686 coreutils && \
    cd statifier && make

FROM fedora:latest as prod
WORKDIR /workdir
COPY --from=0 /workdir/ .

RUN sed -i -e 's|^metalink=|#metalink=|g' \
         -e 's|^#baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora|g' \
         /etc/yum.repos.d/fedora*.repo
        #  /etc/yum.repos.d/fedora.repo \
        #  /etc/yum.repos.d/fedora-modular.repo \
        #  /etc/yum.repos.d/fedora-updates.repo \
        #  /etc/yum.repos.d/fedora-updates-modular.repo \
        #  /etc/yum.repos.d/fedora-updates-testing.repo \
        #  /etc/yum.repos.d/fedora-updates-testing-modular.repo
RUN yum -y install --nogpgcheck https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN sed -i -e 's|^metalink=|#metalink=|g' \
         -e 's|^#baseurl=http://download1.rpmfusion.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn/rpmfusion|g' \
         /etc/yum.repos.d/rpmfusion-*.repo
        #  /etc/yum.repos.d/rpmfusion-free.repo \
        #  /etc/yum.repos.d/rpmfusion-free-updates.repo \
        #  /etc/yum.repos.d/rpmfusion-free-updates-testing.repo \
        #  /etc/yum.repos.d/rpmfusion-nonfree.repo \
        #  /etc/yum.repos.d/rpmfusion-nonfree-updates.repo \
        #  /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo
RUN yum makecache && yum -y install make && yum -y clean all  && rm -rf /var/cache && \
    cd /workdir/statifier && make install && rm -rf /workdir/statifier

ENTRYPOINT [ "/bin/bash" ]
