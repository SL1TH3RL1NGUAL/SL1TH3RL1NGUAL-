#!/data/data/com.termux/files/usr/bin/bash

FILE=$1

SIG=$(jq -r '.signature' "$FILE")
HASH=$(jq -r '.payload_hash' "$FILE")
CAPSULE_ID=$(jq -r '.capsule_id' "$FILE")
TIMESTAMP=$(jq -r '.timestamp' "$FILE")
NONCE=$(jq -r '.nonce' "$FILE")
ORIGIN=$(jq -r '.origin' "$FILE")

# Basic presence checks
if [ -z "$SIG" ] || [ "$SIG" = "null" ]; then
    echo "[signature-verify] Missing signature"
    exit 1
fi

if [ -z "$HASH" ] || [ "$HASH" = "null" ]; then
    echo "[signature-verify] Missing payload_hash"
    exit 1
fi

if [ -z "$CAPSULE_ID" ] || [ "$CAPSULE_ID" = "null" ]; then
    echo "[signature-verify] Missing capsule_id"
    exit 1
fi

if [ -z "$TIMESTAMP" ] || [ "$TIMESTAMP" = "null" ]; then
    echo "[signature-verify] Missing timestamp"
    exit 1
fi

if [ -z "$NONCE" ] || [ "$NONCE" = "null" ]; then
    echo "[signature-verify] Missing nonce"
    exit 1
fi

if [ -z "$ORIGIN" ] || [ "$ORIGIN" = "null" ]; then
    echo "[signature-verify] Missing origin"
    exit 1
fi

echo "[signature-verify] Structure OK for $FILE"
exit 0
