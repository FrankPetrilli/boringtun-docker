FROM rust:slim AS builder

WORKDIR /src
COPY boringtun .
RUN cargo build --release \
    && strip ./target/release/boringtun

FROM debian:testing-slim

WORKDIR /app
COPY --from=builder /src/target/release/boringtun /app

ENV WG_LOG_LEVEL=info \
    WG_THREADS=4

RUN apt-get update && apt-get install -y --no-install-suggests wireguard-tools iproute2 iptables tcpdump
CMD ["wg-quick", "up", "$1"]
