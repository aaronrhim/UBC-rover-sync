# syntax=docker/dockerfile:1

# Default to an interactive shell; run setup scripts manually inside the container.
# Example:
#   docker build -t roverflake2:dev .
#   docker run --rm -it --net=host \
#     -e DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#     roverflake2:dev
# Then inside the container:
#   bash setup_scripts/setup_everything_common.sh
# Then to commit the image: docker commit rover-setup <your username>/roverflake2:
# <anything you want to name the image as>

# Base Ubuntu matching ROS 2 Humble target (Jammy 22.04)
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Core tools needed for the setup scripts (which use sudo, locales, curl, etc.)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo locales tzdata ca-certificates bash git curl \
       software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Configure locale to match what the scripts expect
RUN locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Place the repository where the scripts reference it: $HOME/RoverFlake2
WORKDIR /root/RoverFlake2
COPY . .

CMD ["bash"]

