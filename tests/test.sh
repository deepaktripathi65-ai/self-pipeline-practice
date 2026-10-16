
#!/bin/bash

set -e

URL="${1:?Please provide application URL}"

echo "Testing application: $URL"

RESPONSE=$(curl -fsS "$URL")

echo "$RESPONSE" | grep -q "IT Service Portal"
echo "$RESPONSE" | grep -q "running successfully"

echo "All tests passed successfully!"
