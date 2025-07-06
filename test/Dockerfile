# Use Ubuntu as the base image to mimic the target environment
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=testuser
ENV HOME=/home/$USER

# Install basic dependencies
RUN apt-get update && \
  apt-get install -y \
  sudo \
  curl \
  wget \
  git \
  build-essential \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  apt-transport-https \
  vim \
  nano \
  htop \
  systemd \
  systemd-sysv \
  libfuse2 \
  && rm -rf /var/lib/apt/lists/*

# Create a non-root user for testing
RUN useradd -m -s /bin/bash $USER && \
  echo "$USER:$USER" | chpasswd && \
  adduser $USER sudo && \
  echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create necessary directories
RUN mkdir -p $HOME/.local/bin && \
  mkdir -p $HOME/.local/share && \
  chown -R $USER:$USER $HOME

# Switch to the test user
USER $USER
WORKDIR $HOME

# Copy test scripts
COPY --chown=$USER:$USER test-scripts/ ./test-scripts/

# Make test scripts executable
RUN chmod +x ./test-scripts/*.sh

# Set up shell environment
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile

# Default command
CMD ["/bin/bash"]