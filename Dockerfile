FROM golang:alpine as builder

WORKDIR /go/src/chat-api-reverse
COPY . .

RUN go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && go env -w CGO_ENABLED=0 \
    && go env \
    && go mod tidy \
    && go build -o server .

FROM alpine:latest

LABEL MAINTAINER="dalefengs@gmail.com"

WORKDIR /go/src/chat-api-reverse

COPY --from=0 /go/src/chat-api-reverse/server ./
COPY --from=0 /go/src/chat-api-reverse/server/config.docker.yaml ./

EXPOSE 8888
ENTRYPOINT ./server -c config.docker.yaml
