#!/usr/bin/env bash

# Variables
NTFY_SERVER=$1
NTFY_USERNAME=$2
NTFY_PASSWORD=$3

NTFY_TOPICS=()
for ((i = 4; i <= $#; i++)); do
    NTFY_TOPICS+=("${!i}")
done

# Create account, verify response is 200
response_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$NTFY_SERVER/v1/account" -H "Content-Type: application/json" -d "{\"username\":\"$NTFY_USERNAME\",\"password\":\"$NTFY_PASSWORD\"}")
echo "Response code: $response_code"
if [ "$response_code" -ne 200 ]; then
    echo "Failed to create account"
    exit 1
fi

echo "Account created successfully"

# Subscribe to topics
for topic in "${NTFY_TOPICS[@]}"; do
    response_code=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$NTFY_SERVER/$topic/json" -u "$NTFY_USERNAME:$NTFY_PASSWORD" -H "Content-Type: application/json")
    if [ "$response_code" -ne 200 ]; then
        echo "Failed to subscribe to topic $topic"
        exit 1
    fi

    echo "Subscribed to topic $topic"
done

echo "Subscribed to topics successfully"
