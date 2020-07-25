FROM alpine:latest

RUN apk add --update git gcc make libc-dev bash curl
RUN git clone https://github.com/janet-lang/janet /usr/src/janet && cd /usr/src/janet && make && make install
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin

ENTRYPOINT ["/bin/bash"]
