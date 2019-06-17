################################################################################
# Golang build image - golang:alpine
################################################################################
FROM golang@sha256:cee6f4b901543e8e3f20da3a4f7caac6ea643fd5a46201c3c2387183a332d989 as builder

################################################################################
# Git is required for fetching the dependencies
# Curl is required to download protoc
# Ca-certificates is required to call HTTPS endpoints
################################################################################
RUN set -ex && apk update && apk add --no-cache \
    git \
    curl \
    make \
    ca-certificates \
    && update-ca-certificates

################################################################################
# Working Dir
################################################################################
WORKDIR /wd

################################################################################
# Download and unzip Protoc compiler
################################################################################
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.8.0/protoc-3.8.0-linux-x86_64.zip
RUN mkdir protoc && unzip -o protoc-3.8.0-linux-x86_64.zip -d protoc

################################################################################
# Enable go mod so we can version our go components
################################################################################
ENV GO111MODULE=on

################################################################################
# Go GRPC package
################################################################################
RUN go get -u google.golang.org/grpc@v1.21.1

################################################################################
# Go support for Protocol Buffers v1.3.1
################################################################################
RUN go get github.com/golang/protobuf/protoc-gen-go@v1.3.1

################################################################################
# GoGo Proto v1.2.1
################################################################################
RUN go get github.com/gogo/protobuf/proto@v1.2.1
RUN go get github.com/gogo/protobuf/gogoproto@v1.2.1
RUN go get github.com/gogo/protobuf/protoc-gen-gogofast@v1.2.1
RUN go get github.com/gogo/protobuf/protoc-gen-gogofaster@v1.2.1
RUN go get github.com/gogo/protobuf/protoc-gen-gogoslick@v1.2.1

################################################################################
# GRPC Gateway v1.9.1
################################################################################
RUN go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@v1.9.1
RUN go get github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@v1.9.1

################################################################################
# Protolock v0.13.0
################################################################################
RUN go get github.com/nilslice/protolock/cmd/protolock@v0.13.0

################################################################################
# Prototool v1.8.0
################################################################################
RUN go get github.com/uber/prototool/cmd/prototool@v1.8.0

#------------------------------------------------------------------------------#

################################################################################
# Proto build image
################################################################################
FROM alpine

################################################################################
# curl is required to download glibc
# libstdc++ is required for protoc
# Ca-certificates is required to call HTTPS endpoints
################################################################################
RUN set -ex && apk --update --no-cache add \
    curl \
    libstdc++ \
    ca-certificates \
    && update-ca-certificates

################################################################################
# Add glibc
################################################################################
RUN curl -L -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && curl -OL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk \
    && apk add glibc-2.29-r0.apk

################################################################################
# Copy bins
################################################################################
COPY --from=builder /wd/protoc/bin/* /usr/local/bin
COPY --from=builder /wd/protoc/include/* /usr/local/include
COPY --from=builder /go/bin/* /usr/local/bin/