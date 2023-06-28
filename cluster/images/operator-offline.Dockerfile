# Build the manager binary
FROM golang:1.19.10 as builder

WORKDIR /workspace

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY cmd/ cmd/
COPY pkg/ pkg/
COPY operator/ operator/

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$(go env GOARCH) && echo "Building GOARCH of $GOARCH.." \
     && go build -a -o karmada-operator operator/cmd/operator/operator.go

RUN curl -LO https://github.com/karmada-io/karmada/releases/download/v1.4.0/crds.tar.gz \
     && mkdir -p karmada/v1.4.0 && mv crds.tar.gz karmada/v1.4.0 \
     && curl -LO https://github.com/karmada-io/karmada/releases/download/v1.5.0/crds.tar.gz \
     && mkdir -p karmada/v1.5.0 && mv crds.tar.gz karmada/v1.5.0 \
     && curl -LO https://github.com/karmada-io/karmada/releases/download/v1.6.0/crds.tar.gz \
     && mkdir -p karmada/v1.6.0 && mv crds.tar.gz karmada/v1.6.0

FROM alpine:3.18.2

RUN apk add --no-cache ca-certificates
COPY --from=builder /workspace/karmada-operator /bin/karmada-operator
COPY --from=builder /workspace/karmada /var/lib/karmada
