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

FROM centos:centos7 as prod
WORKDIR /workdir
COPY --from=0 /workdir/ .

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.tuna.tsinghua.edu.cn|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-*.repo
RUN yum -y install make && yum -y clean all  && rm -rf /var/cache && \
    cd /workdir/statifier && make install && rm -rf /workdir/statifier

ENTRYPOINT [ "/bin/bash" ]
