# Start with the official Nordic toolchain (compilers, python, west)
FROM ghcr.io/nrfconnect/sdk-nrf-toolchain:v3.2.3

# Install Node.js so Gitea's standard Actions (like actions/checkout) work!
RUN apt-get update && apt-get install -y nodejs git && rm -rf /var/lib/apt/lists/*

# Create a permanent folder for the SDK inside the container
WORKDIR /opt/ncs

# Download the nRF Connect SDK source code directly into the container
RUN west init -m https://github.com/nrfconnect/sdk-nrf --mr v3.2.3 . && \
    west update --narrow -o=--depth=1

# Set the environment variables permanently so west ALWAYS knows where Zephyr is.
# This eliminates the need to run 'source zephyr-env.sh' in your CI pipeline!
ENV ZEPHYR_BASE=/opt/ncs/zephyr
ENV PATH="/opt/ncs/zephyr/scripts:${PATH}"

# Set the default working directory back to where Gitea checks out your code
WORKDIR /workspace
