FROM ghcr.io/gmto/gmt-base-os:latest

### EtherCAT
RUN printf "[gmt]\nname=GMT \$releasever - \$basearch\nbaseurl=http://52.52.46.32/srv/gmt/yum/stable/\$releasever/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/gmt.repo
RUN printf "[gmt-updates] \nname=GMT \$releasever - \$basearch - Updates\nbaseurl=http://52.52.46.32/srv/gmt/yum/updates/\$releasever/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/gmt-updates.repo
RUN dnf install -y --nogpgcheck kernel-3.14.73-rt78.x86_64 ethercat-devel && dnf clean all

COPY ./ /module/
