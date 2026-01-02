#!/data/data/com.termux/files/usr/bin/bash

FILE=$1
POLICY=$2

SCRIPT=$(jq -r '.script' "$FILE")
SOURCE=$(jq -r '.source' "$FILE")
TOPIC=$(jq -r '.topic' "$FILE")

grep -q "$SCRIPT" "$POLICY" || exit 1
grep -q "$SOURCE" "$POLICY" || exit 1
grep -q "$TOPIC" "$POLICY" || exit 1

case $SCRIPT in
    parse-telemetry)
        echo "[reserve-engine] Parsing telemetry from $SOURCE for topic $TOPIC"
        ;;
    summarize-state)
        echo "[reserve-engine] Summarizing state from $SOURCE for topic $TOPIC"
        ;;
    generate-insight)
        echo "[reserve-engine] Generating insight from $SOURCE for topic $TOPIC"
        ;;
    *)
        echo "[reserve-engine] Unknown script: $SCRIPT"
        exit 1
        ;;
esac

