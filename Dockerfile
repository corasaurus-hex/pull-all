FROM ubuntu:20.04

RUN apt-get update && apt-get -y install build-essential bash curl git
RUN git clone https://github.com/janet-lang/janet /usr/src/janet && cd /usr/src/janet && make && make install
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin

ENTRYPOINT ["/bin/bash"]
