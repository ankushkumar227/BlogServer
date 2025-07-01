FROM ubuntu:20.04

# Avoid interactive prompts (e.g. timezone)
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt update && apt install -y \
    curl \
    bash \
    coreutils \
    acl \
    mysql-client \
    && rm -rf /var/lib/apt/lists/* 
# ladt line removes unnessary metadata from mage to reduce its size

# Install latest yq (Go-based v4.x)
RUN curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/bin/yq \
    && chmod +x /usr/bin/yq


