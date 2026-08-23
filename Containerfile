FROM fedora:44

LABEL org.opencontainers.image.source="https://github.com/jkhaak/devc-base"
LABEL org.opencontainers.image.description="Base layer for devcontainer development"

# Install common system packages
RUN dnf install -y \
    ca-certificates \
    curl \
    file \
    gcc \
    git \
    jq \
    make \
    perl \
    procps-ng \
    && dnf clean all

# Create non-root user with UID 1000
RUN useradd -m -u 1000 -s /bin/bash dev

# Create entrypoint.d and workspace
RUN mkdir -p /entrypoint.d && \
    chown dev:dev /entrypoint.d && \
    mkdir -p /workspace && \
    chown dev:dev /workspace

# Copy the entrypoint script
COPY --chown=dev:dev --chmod=755 entrypoint.sh /entrypoint.sh

# Install Homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    chown -R dev:dev /home/linuxbrew

# Create the base shell environment script
COPY --chown=dev:dev --chmod=755 entrypoint.base.sh /entrypoint.d/00-base.sh

# Set default user
USER dev

ENV PATH=/home/dev/.local/bin:$PATH

# Make brew available for all subsequent RUN steps
ENV HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
ENV HOME=/home/dev
ENV HOMEBREW_CELLAR=/home/linuxbrew/.linuxbrew/Cellar
ENV HOMEBREW_REPOSITORY=/home/linuxbrew/.linuxbrew/Homebrew
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH

# Set workdir, entrypoint and default command
VOLUME ["/workspace"]
WORKDIR /workspace
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
