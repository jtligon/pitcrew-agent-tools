# ============================================================================
# PITCREW Agent Tools Container
#
# A container with Claude Code and JIRA tools for PITCREW product owner workflows
#
# Build:
#   podman build -t pitcrew-agent .
#
# Run:
#   podman run -it --rm \
#     -v pitcrew-config:/home/agent/.config \
#     -v $(pwd):/workspace \
#     -e JIRA_API_TOKEN="your-jira-token" \
#     -e GH_TOKEN="your-github-token" \
#     pitcrew-agent
#
# ============================================================================

FROM registry.fedoraproject.org/fedora:41

ARG TARGETARCH=amd64

LABEL org.opencontainers.image.title="PITCREW Agent Tools"
LABEL org.opencontainers.image.description="Container with Claude Code and JIRA tools for PITCREW"
LABEL org.opencontainers.image.source="https://github.com/jtligon/pitcrew-agent-tools"

# Install system packages
RUN dnf install -y --setopt=install_weak_deps=False \
    jq \
    yq \
    gh \
    git \
    curl \
    tar \
    ripgrep \
    vim-common \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Download jira-cli binary (pre-built from GitHub releases)
RUN JIRA_ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "arm64") && \
    JIRA_VERSION=$(curl -fsSL "https://api.github.com/repos/ankitpokhrel/jira-cli/releases/latest" | jq -r '.tag_name' | sed 's/^v//') && \
    curl -fsSL "https://github.com/ankitpokhrel/jira-cli/releases/latest/download/jira_${JIRA_VERSION}_linux_${JIRA_ARCH}.tar.gz" \
      -o /tmp/jira.tar.gz && \
    tar -xzf /tmp/jira.tar.gz -C /tmp && \
    mv /tmp/jira_${JIRA_VERSION}_linux_${JIRA_ARCH}/bin/jira /usr/local/bin/jira && \
    chmod +x /usr/local/bin/jira && \
    rm -rf /tmp/jira.tar.gz /tmp/jira_*

# Create non-root user
RUN useradd -m -u 1000 -s /bin/bash agent

# Set up directories
RUN mkdir -p /home/agent/.config /home/agent/.local && \
    chown -R agent:agent /home/agent

# Copy skills to staging location (will be synced to ~/.config on startup)
COPY go/skills/ /opt/skills/

# Create init script to sync skills on every run
RUN printf '%s\n' \
    '#!/bin/bash' \
    '# Sync skills from image to volume' \
    'mkdir -p "$HOME/.claude/skills"' \
    'cp -r /opt/skills/* "$HOME/.claude/skills/"' \
    'exec "$@"' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Set up workspace
RUN mkdir -p /workspace && chown agent:agent /workspace
WORKDIR /workspace

# Switch to non-root user
USER agent

# Use entrypoint to sync skills, then run bash by default
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
