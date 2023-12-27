#!/bin/bash
set -e

cd $(dirname "$0")
if [ ! -e ".env" ]; then
  echo '{{ Background "#ff0000" ".env file does not exist" }}' | gum format -t template
  exit 1
fi

source .env

if [ ! -n "$CLAIR_URL" ]; then
  echo '{{ Background "#ff0000" "JWT_TOKEN is empty" }}' | gum format -t template
  exit 1
fi
if [ ! -n "$JWT_TOKEN" ]; then
  echo '{{ Background "#ff0000" "JWT_TOKEN is empty" }}' | gum format -t template
  exit 1
fi

if [ -z $1 ]; then
  id=$(gum input --placeholder "notification id")
else
  id=$1
fi

set -u

json=$(curl -X GET -s \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d '{"iss": "quay"}' \
  https://clair.homelab.build.my/notifier/api/v1/notification/$1)

if test $? != 0 ; then 
  echo '{{ Background "#ff0000" "failed to fetch json" }}' | gum format -t template
  exit 1
fi

output=jsons/$1.json
echo $json | jq . > $output
printf 'success: {{ Foreground "10" "%s" }}\n' $output | gum format -t template