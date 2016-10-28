FROM christiangda/golang

MAINTAINER Christian González <christiangda@gmail.com>

LABEL Description="Heapster enables Container Cluster Monitoring and Performance Analysis. docker image" Vendor="Christian González" Version="1.0.0"
LABEL Build docker build --no-cache --rm --tag christiangda/heapster:1.0.0 --tag christiangda/heapster:latest --tag christiangda/heapster:canary .

ENV container docker

# Update and install base packages
#RUN dnf update -y --setopt=tsflags=nodocs --setopt=deltarpm=0 && \
RUN dnf install -y --setopt=tsflags=nodocs --setopt=deltarpm=0 \
    which \
    glibc-headers \
    gcc \
    make \
    redhat-rpm-config

# Clone the Heapster Project
RUN git clone https://github.com/kubernetes/heapster.git /go/src/k8s.io/heapster

# Compile Heapster Project
ENV GOPATH "/go"
RUN cd /go/src/k8s.io/heapster && make && mv heapster /heapster && mv eventer /eventer

# Clean the disaster!
RUN dnf -y remove \
     glibc-devel \
     glibc-headers \
     gcc \
     make \
     redhat-rpm-config && \
  dnf clean all && \
  rm -rf /tmp/* /var/tmp/* /var/cache/dnf/* /var/log/anaconda/* /var/log/dnf.*

ENTRYPOINT ["/heapster"]
