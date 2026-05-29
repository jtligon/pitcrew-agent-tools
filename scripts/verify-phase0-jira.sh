#!/usr/bin/env bash
# Phase 0 JIRA audit via jira CLI (not Atlassian MCP).
set -euo pipefail

if [[ -f "${HOME}/.config/jira/auth.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.config/jira/auth.sh"
fi
# Red Hat Atlassian API tokens use basic auth (email:token), not bearer.
unset JIRA_AUTH_TYPE

echo "== jira me =="
jira me

echo
echo "== boards (PITCREW) =="
jira board list --project PITCREW

echo
echo "== sample issues =="
jira issue list -q 'project = PITCREW' --plain --columns key,issuetype,status | head -10

echo
echo "== statuses in use =="
jira issue list -q 'project = PITCREW' --plain --columns key,status \
  | tail -n +2 | awk -F'\t' '{print $2}' | sort -u

echo
echo "== components (REST) =="
login="$(jira me 2>/dev/null || true)"
if [[ -n "${login}" && -n "${JIRA_API_TOKEN:-}" ]]; then
  curl -s -u "${login}:${JIRA_API_TOKEN}" \
    -H "Accept: application/json" \
    "https://redhat.atlassian.net/rest/api/3/project/PITCREW/components" \
    | jq -r '.[].name' 2>/dev/null || echo "(install jq or check token)"
else
  echo "(skipped — set JIRA_API_TOKEN in ~/.config/jira/auth.sh)"
fi

echo
echo "== custom fields on latest issue =="
key="$(jira issue list -q 'project = PITCREW' --plain --columns key | sed -n '2p')"
jira issue view "${key}" --raw | jq '{
  key,
  storyPoints: .fields.customfield_10028,
  sprint: (.fields.customfield_10020 | if type == "array" then .[0].name else . end),
  epic: .fields.customfield_10014
}'

echo
echo "Phase 0 JIRA checks complete."
