#!/usr/bin/env bash
# Dry-run triage-upstream: report matches only; never add labels.
set -euo pipefail
export GH_FORCE_TTY=0

if [[ -f "${HOME}/.config/jira/auth.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.config/jira/auth.sh"
fi
unset JIRA_AUTH_TYPE

LIMIT="${LIMIT:-20}"

search_jira() {
  local component="$1" num="$2"
  local line

  line=$(jira issue list -q "project = PITCREW AND component = \"${component}\" AND text ~ \"issues/${num}\"" \
    --plain --columns key,summary 2>/dev/null | sed -n '2p' || true)
  if [[ -n "${line}" ]]; then
    echo "${line}"
    return 0
  fi

  line=$(jira issue list -q "project = PITCREW AND component = \"${component}\" AND summary ~ \"#${num}\"" \
    --plain --columns key,summary 2>/dev/null | sed -n '2p' || true)
  if [[ -n "${line}" ]]; then
    echo "${line}"
    return 0
  fi

  return 1
}

process_repo() {
  local repo="$1" component="$2"
  local count=0 matched=0 unmatched=0

  echo ""
  echo "### ${repo}"
  echo ""
  printf "| GitHub | Title | PITCREW match | Would apply |\n"
  printf "|--------|-------|---------------|-------------|\n"

  while IFS= read -r row; do
    [[ -z "${row}" ]] && continue
    local num title match key
    num=$(echo "${row}" | jq -r '.number')
    title=$(echo "${row}" | jq -r '.title' | head -c 60)
    count=$((count + 1))
    if match=$(search_jira "${component}" "${num}"); then
      key=$(echo "${match}" | awk '{print $1}')
      printf "| %s#%s | %s… | **%s** | JIRA \`upstream\` + GitHub \`jira\` |\n" "${repo}" "${num}" "${title}" "${key}"
      matched=$((matched + 1))
    else
      printf "| %s#%s | %s… | — | *(none — manual triage)* |\n" "${repo}" "${num}" "${title}"
      unmatched=$((unmatched + 1))
    fi
    [[ "${count}" -ge "${LIMIT}" ]] && break
  done < <(
    gh api "repos/${repo}/issues?state=open&per_page=100" -q . 2>/dev/null \
      | jq -c --argjson lim "${LIMIT}" \
          '[.[] | select(.pull_request == null) | select([.labels[].name] | index("jira") | not) | {number, title}] | .[:$lim][]'
  )

  echo ""
  echo "_Scanned up to ${LIMIT} unlabeled issues (no \`jira\` label). Matched: ${matched}, unmatched: ${unmatched}_"
}

echo "# triage-upstream dry run"
echo ""
echo "**No labels were applied.**"
echo ""

process_repo "jumpstarter-dev/jumpstarter" "Jumpstarter"
process_repo "centos-automotive-suite/automotive-dev-operator" "Automotive-dev-operator"

echo ""
echo "---"
echo "To apply labels after review, use \`go/skills/triage-upstream/SKILL.md\` section 3."
