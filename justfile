# PITCREW Agent Tools - Justfile
# Quick commands for building and running the container

# Default recipe - show available commands
default:
    @just --list

# Build the container
build:
    podman build -t pitcrew-agent .

# Run interactive bash shell with JIRA tools (sources ~/.config/jira/auth.sh if it exists)
shell:
    #!/usr/bin/env bash
    [ -f ~/.config/jira/auth.sh ] && source ~/.config/jira/auth.sh
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -v $(pwd):/workspace \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      -e JIRA_AUTH_TYPE="bearer" \
      -e GH_TOKEN="${GH_TOKEN}" \
      pitcrew-agent

# First-time setup - configure jira CLI (sources ~/.config/jira/auth.sh if it exists)
setup:
    #!/usr/bin/env bash
    [ -f ~/.config/jira/auth.sh ] && source ~/.config/jira/auth.sh
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -v $(pwd):/workspace \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      -e JIRA_AUTH_TYPE="bearer" \
      pitcrew-agent bash -c "jira init && bash"

# Test jira connection (sources ~/.config/jira/auth.sh if it exists)
test-jira:
    #!/usr/bin/env bash
    [ -f ~/.config/jira/auth.sh ] && source ~/.config/jira/auth.sh
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      -e JIRA_AUTH_TYPE="bearer" \
      pitcrew-agent jira issue list --project PITCREW

# Clean up volumes
clean:
    podman volume rm pitcrew-config
