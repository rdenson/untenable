#!/usr/local/bin/bash

access_using_exec() {
  cwrite "looking for pods..."
  pods=$(set_pods $namespace $application)
  pods_count=$(echo $pods |  jq '.items | length')
  cwrite "found $pods_count instances"
  printf "\n\u001b[36m"
  echo $pods | \
    jq -r '
      .items[] |
      {id: .metadata.name, status: .status.phase, created: .status.startTime} |
      "  \(.id)\t\(.status)\t\t\(.created)"
    '
  printf "\u001b[0m\n"
}

display_context
#if [ -z "$application" ]; then
  # ...
#fi

case $operation in
  "exec")
    access_using_exec
    ;;
  "forward")
    access_using_pf
    ;;
  "ssh")
    access_using_ssh
    ;;
esac
