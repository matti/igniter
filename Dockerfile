FROM ubuntu:20.04
ARG CNI_VERSION=v0.8.5
ARG VERSION=v0.8.0

RUN apt-get update && apt-get install -y --no-install-recommends \
  dmsetup openssh-client git binutils \
  containerd \
  && apt-get update && apt-get install -y \
  curl iptables

RUN export ARCH=$([ $(uname -m) = "x86_64" ] && echo amd64 || echo arm64) \
  && mkdir -p /opt/cni/bin \
  && curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | tar -xz -C /opt/cni/bin

RUN GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64") \
  && curl -sfLo /usr/local/bin/ignite https://github.com/weaveworks/ignite/releases/download/${VERSION}/ignite-${GOARCH} \
  && chmod +x /usr/local/bin/ignite \
  && curl -sfLo /usr/local/bin/ignited https://github.com/weaveworks/ignite/releases/download/${VERSION}/ignited-${GOARCH} \
  && chmod +x /usr/local/bin/ignited

WORKDIR /app
COPY app .

ENTRYPOINT [ "/app/entrypoint.sh" ]
