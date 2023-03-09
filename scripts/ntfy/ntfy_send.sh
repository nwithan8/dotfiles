#!/usr/bin/env bash

# Send a notification using ntfy

# Parse arguments
SERVER="$1"
TOPIC="$2"
MESSAGE="$3"
HEADERS_STRING=""

# Parse headers
# From 4TH argument to end
for i in "${@:4:$#}"; do
  # Append to headers string
  HEADERS_STRING="$HEADERS_STRING -H \"$i\""
done
# Trim leading and trailing whitespace
HEADERS_STRING="$(echo -e "${HEADERS_STRING}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

URL="$SERVER/$TOPIC"

# No, we can't quote $HEADERS_STRING, it will mess up the headers passed to curl
curl -X POST $HEADERS_STRING -d "$MESSAGE" "$URL"
