#!/data/data/com.termux/files/usr/bin/bash

FILE=$1

SEAL=$(jq -r '.host_seal.seal' "$FILE")
HOST_ID=$(jq -r '.host_seal.host_id' "$FILE")
ASSIGNMENT=$(jq -r '.host_seal.assignment' "$FILE")

if [ -z "$SEAL" ] || [ "$SEAL" = "null" ]; then
    echo "[seal-verify] Missing host seal"
    exit 1
fi

if [ -z "$HOST_ID" ] || [ "$HOST_ID" = "null" ]; then
    echo "[seal-verify] Missing host_id"
    exit 1
fi

if [ -z "$ASSIGNMENT" ] || [ "$ASSIGNMENT" = "null" ]; then
    echo "[seal-verify] Missing assignment"
    exit 1
fi

echo "[seal-verify] Host seal OK for $FILE"
exit 
