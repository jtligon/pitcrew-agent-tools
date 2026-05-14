# PITCREW Agent Tools - Justfile
# Quick commands for building and running the container

# Default recipe - show available commands
default:
    @just --list

# Build the container
build:
    podman build -t pitcrew-agent .

# Run interactive bash shell with JIRA tools
shell:
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -v $(pwd):/workspace \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      -e GH_TOKEN="${GH_TOKEN}" \
      pitcrew-agent

# First-time setup - configure jira CLI
setup:
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -v $(pwd):/workspace \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      pitcrew-agent bash -c "jira init && bash"

# Test jira connection
test-jira:
    podman run -it --rm \
      -v pitcrew-config:/home/agent/.config \
      -e JIRA_API_TOKEN="${JIRA_API_TOKEN}" \
      pitcrew-agent jira issue list --project PITCREW

# Clean up volumes
clean:
    podman volume rm pitcrew-config
