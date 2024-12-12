# syntax=docker/dockerfile:1
FROM bitnami/minideb:bookworm

ARG JB_VERSION=v0.6.0
ARG TK_VERSION=v0.30.2
ARG HELM_VERSION=v3.16.3
ARG KUBECTL_VERSION=v1.30.4

RUN install_packages git curl ca-certificates
ADD --chmod=755 https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/${JB_VERSION}/jb-linux-amd64 /usr/local/bin/jb
ADD --chmod=755 https://github.com/grafana/tanka/releases/download/${TK_VERSION}/tk-linux-amd64 /usr/local/bin/tk
ADD https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz /tmp/helm.tar.gz
RUN tar zxvf /tmp/helm.tar.gz --strip-components 1 -C /usr/local/bin/ linux-amd64/helm \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY --chmod=555 scripts /plugin

CMD ["/var/run/argocd/argocd-cmp-server"]
