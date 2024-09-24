# Build stage
FROM golang:1.22 as builder
WORKDIR /go/src/github.com/rancher/rancher

# Clone Rancher repository
RUN git clone https://github.com/rancher/rancher.git .

# Modify Rancher code to disable self-healing
RUN sed -i 's/selfHealingEnabled := true/selfHealingEnabled := false/' pkg/controllers/management/cluster/clustercontroller.go

# Build the binary
RUN go build -o rancher

# Final stage
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Download k3s binary
RUN curl -L https://github.com/k3s-io/k3s/releases/download/v1.27.3%2Bk3s1/k3s -o /usr/local/bin/k3s && \
    chmod +x /usr/local/bin/k3s

COPY --from=builder /go/src/github.com/rancher/rancher/rancher /usr/bin/

ENV CATTLE_UI_PATH /usr/share/rancher/ui
ENV CATTLE_UI_VERSION 2.5.2
ENV CATTLE_CLI_VERSION v2.4.11
RUN mkdir -p /var/lib/rancher/management-state/etcd /var/lib/rancher/management-state/etc
VOLUME /var/lib/rancher
WORKDIR /var/lib/rancher

ENV CATTLE_AGENT_IMAGE rancher/rancher-agent:v2.5.11
ENV CATTLE_SERVER_IMAGE rancher/rancher
ENV CATTLE_ETCD_VERSION v3.4.3-rancher1
ENV LOGLEVEL_VERSION v0.1.3
ENV TINI_VERSION v0.18.0

# Create a startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'mkdir -p /var/lib/rancher/k3s/server/tls' >> /start.sh && \
    echo 'k3s certificate generate-ca' >> /start.sh && \
    echo 'k3s server --disable-agent --cluster-cidr=10.42.0.0/16 --service-cidr=10.43.0.0/16 --cluster-domain=cluster.local --disable-network-policy --disable=traefik &' >> /start.sh && \
    echo 'while ! k3s kubectl get nodes --server=https://127.0.0.1:6443 --kubeconfig /etc/rancher/k3s/k3s.yaml; do sleep 1; done' >> /start.sh && \
    echo 'rancher --http-listen-port=80 --https-listen-port=443 --k8s-mode=embedded' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

