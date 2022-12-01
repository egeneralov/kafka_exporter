FROM golang:1.18.3-alpine

RUN apk add --no-cache ca-certificates git

ENV \
  GO111MODULE=on \
  CGO_ENABLED=0 \
  GOOS=linux

WORKDIR /go/src/github.com/rancher/kafka_exporter

ADD . .
RUN go build -v -installsuffix cgo -ldflags="-w -s" -o /go/bin/kafka_exporter .


FROM alpine:3.16
RUN apk add --no-cache ca-certificates
COPY --from=0 /go/bin /go/bin
ENV PATH='/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENTRYPOINT ["/go/bin/kafka_exporter"]
