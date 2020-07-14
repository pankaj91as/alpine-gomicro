FROM alpine:latest
ARG GOLANG_VERSION=1.14.3
#we need the go version installed from apk to bootstrap the custom version built from source
RUN apk update && apk add go gcc bash musl-dev openssl-dev wget libstdc++ libprotobuf-lite protoc protobuf make ca-certificates && update-ca-certificates
RUN wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash
ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin
RUN rm go$GOLANG_VERSION.src.tar.gz
#we delete the apk installed version to avoid conflict
RUN apk del go
ENV GOBIN=/root/go/bin
ENV GO111MODULE=on
RUN go env
RUN echo ${PATH}
RUN go get github.com/micro/micro/v2
RUN go get -u github.com/golang/protobuf/proto
RUN go get -u github.com/golang/protobuf/protoc-gen-go
RUN go get github.com/micro/micro/v2/cmd/protoc-gen-micro
# RUN micro server