#!/bin/bash
set -e
set -u

fail=false
gum=true
if ! which gum > /dev/null 2>&1; then
  echo "gum not installed: https://github.com/charmbracelet/gum"
  fail=true
  gum=false
fi

if ! which jq > /dev/null 2>&1; then
  # https://jqlang.github.io/jq/
  message="jq command is not installed: https://jqlang.github.io/jq/download/"
  if [ "$gum" = "true" ]; then
    printf '{{ Background "#ff0000" "%s" }}\n' "$message" | gum format -t template
  else 
    echo $message
  fi
  fail=true
fi

if ! which curl > /dev/null 2>&1; then
  if [ "$gum" = "true" ]; then
    echo '{{ Background "#ff0000" "curl is not installed" }}' | gum format -t template
  else
    echo "curl is not installed"
  fi
  fail=true
fi

if [ "$fail" = "true" ]; then
  if [ "$gum" = "true" ]; then
    echo '{{ Background "#ff0000" "check failed" }}' | gum format -t template
  else
    echo "check failed"
  fi
  exit 1
fi

echo '{{ Foreground "10" "check success" }}' | gum format -t template