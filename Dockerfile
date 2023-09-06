# Build stage
FROM rust:latest AS build

# Install dependencies
RUN apt-get update && \
    apt-get install -y clang cmake git

# Clone and build Electrs
RUN git clone https://github.com/blockstream/electrs && \
    cd electrs && \
    git checkout new-index

RUN cd electrs && cargo build --release

# Production stage
FROM debian:11-slim

# Install Electrs dependencies
RUN apt-get update && \
    apt-get install -y libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy Electrs binary from build stage
COPY --from=build /electrs/target/release/electrs /usr/local/bin/electrs

WORKDIR /root

# Run Electrs
CMD ["electrs", "--help"]