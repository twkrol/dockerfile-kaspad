# create builder image
FROM golang:latest as builder

RUN mkdir /app
WORKDIR /app

# get latest source version
RUN git clone https://github.com/kaspanet/kaspad

# get specific source version
#RUN git clone --depth 1 --branch v0.11.11 https://github.com/kaspanet/kaspad

WORKDIR /app/kaspad
RUN go install -ldflags '-linkmode external -w -extldflags "-static"' . ./cmd/...

# create final image
FROM alpine:latest

#copy artefacts from builder image
COPY --from=builder /go/bin /

EXPOSE 16110
EXPOSE 16111
EXPOSE 8082

CMD ["/app/kaspad", "--utxoindex"]
