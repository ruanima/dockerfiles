FROM debian:testing as builder
WORKDIR /workdir
COPY ./debian-sources.list.txt /etc/apt/sources.list

RUN apt-get update && apt-get -y install build-essential gcc-multilib git
# RUN git clone https://github.com/prebuilder/statifier.git
RUN git clone https://gitlab.com/my-git-mirrors/statifier.git
RUN cd statifier && make

FROM debian:testing as prod
WORKDIR /workdir
COPY --from=0 /etc/apt/sources.list /etc/apt/sources.list
COPY --from=0 /workdir .

RUN apt-get update && apt-get -y install make && \
    cd /workdir/statifier && make install && rm -rf /workdir/statifier

ENTRYPOINT [ "/bin/bash" ]
