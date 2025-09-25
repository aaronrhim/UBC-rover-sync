# syntax=docker/dockerfile:1

# Minimal base for RoverFlake2 development (ROS 2 Humble on Ubuntu 22.04)
FROM ubuntu:22.04

# Noninteractive APT to avoid tzdata/locale prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install only the core tools our setup scripts rely on
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo locales tzdata ca-certificates bash git curl \
       software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Generate and export UTF-8 locale (expected by setup scripts)
RUN locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Put repo where scripts expect: $HOME/RoverFlake2 (root's HOME is /root)
WORKDIR /root/RoverFlake2

# Copy source so setup scripts are available inside the image
COPY . .

# Default to an interactive shell; run setup scripts manually inside
# Example:
#   docker build -t roverflake2:dev .
#   docker run --rm -it --net=host -e DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw roverflake2:dev
#   bash setup_scripts/setup_everything_common.sh
CMD ["bash"]