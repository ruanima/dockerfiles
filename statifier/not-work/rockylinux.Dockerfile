# NOT WOKR!!!
# /usr/lib/statifier/64/non_pt_load: warning: can't find segment with v_addr=0x0
# /usr/lib/statifier/64/non_pt_load: warning: can't find segment with v_addr=0x211000

FROM rockylinux:8 as builder
WORKDIR /workdir

RUN yum -y group install "Development Tools"
# RUN git clone https://github.com/prebuilder/statifier.git
RUN git clone https://gitlab.com/my-git-mirrors/statifier.git
RUN yum -y install libgcc.i686 glibc-devel.i686 coreutils-common && \
    cd statifier && make

FROM rockylinux:8 as prod
WORKDIR /workdir
COPY --from=0 /workdir/ .

RUN yum -y install make && yum -y clean all  && rm -rf /var/cache && \
    cd /workdir/statifier && make install && rm -rf /workdir/statifier

ENTRYPOINT [ "/bin/bash" ]
