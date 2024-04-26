FROM --platform=linux/amd64 ghcr.io/gmto/gmt-os:latest

COPY install.sh /tmp/install.sh
RUN /tmp/install.sh && rm -rf /tmp/install.sh

WORKDIR /opt/gmt

ENTRYPOINT ["/bin/bash"]
