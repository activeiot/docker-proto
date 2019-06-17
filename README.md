# docker-proto
Docker image to compile proto files

## Components

| Package | Version |
|-----------|---------|
| protoc | v3.8.0  |
| google.golang.org/grpc | v1.21.1 |
| github.com/golang/protobuf/protoc-gen-go | v1.3.1 |
| github.com/gogo/protobuf/proto | v1.2.1 |
| github.com/gogo/protobuf/gogoproto | v1.2.1 |
| github.com/gogo/protobuf/protoc-gen-gogofast | v1.2.1 |
| github.com/gogo/protobuf/protoc-gen-gogofaster | v1.2.1 |
| github.com/gogo/protobuf/protoc-gen-gogoslick | v1.2.1 |
| github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway | v1.9.1 |
| github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger | v1.9.1 |
| github.com/uber/prototool/cmd/prototool | v1.8.0 |

## Usage

```docker
############################################################
# Proto image
############################################################
FROM active-iot/docker-proto AS proto

############################################################
# Copy proto files to docker image
############################################################
WORKDIR /myapp
COPY . .

############################################################
# Run prototool, or execute protoc commands
############################################################
RUN prototool all

#----------------------------------------------------------#

############################################################
# Final image
############################################################
FROM golang AS final

############################################################
# Copy compiled files
############################################################
COPY --from=proto /myapp $GOPATH/src/github.com/mypkg/myapp

...

```