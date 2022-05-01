FROM rust:1.60-alpine3.15 AS builder
WORKDIR /src
COPY boringtun .
RUN apk update && apk add g++ && cargo build --release \
    && strip ./target/release/boringtun

FROM alpine:3.15
WORKDIR /app
COPY --from=builder /src/target/release/boringtun /app
ENV WG_LOG_LEVEL=info \
    WG_THREADS=4
RUN apk update && apk add wireguard-tools
CMD ["wg-quick", "up", "$1"]
