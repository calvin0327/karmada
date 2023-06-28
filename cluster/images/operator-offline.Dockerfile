FROM alpine:3.18.2

ARG BINARY

RUN apk add --no-cache ca-certificates

RUN wget https://github.com/karmada-io/karmada/releases/download/v1.4.0/crds.tar.gz \
     && mkdir -p /var/lib/karmada/1.4.0 && mv crds.tar.gz /var/lib/karmada/1.4.0 \
     && wget https://github.com/karmada-io/karmada/releases/download/v1.5.0/crds.tar.gz \
     && mkdir -p /var/lib/karmada/1.5.0 && mv crds.tar.gz /var/lib/karmada/1.5.0 \
     && wget https://github.com/karmada-io/karmada/releases/download/v1.6.0/crds.tar.gz \
     && mkdir -p /var/lib/karmada/1.6.0 && mv crds.tar.gz /var/lib/karmada/1.6.0

COPY _output/bin/linux/amd64/karmada-operator /bin/karmada-operator
