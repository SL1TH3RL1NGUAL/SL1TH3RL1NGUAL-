#!/data/data/com.termux/files/usr/bin/bash

VAULT=~/capsule/reserve/vault/incoming
PROCESSED=~/capsule/reserve/vault/processed
REJECTED=~/capsule/reserve/vault/rejected
POLICY=~/capsule/reserve/policy/reserve-policy.yaml

while true; do
    for file in "$VAULT"/*.json; do
        [ -e "$file" ] || continue

        echo "[watchdog] Found intel: $file"

        # 1) Signature verification
        ~/capsule/reserve/engines/signature-verify.sh "$file"
        if [ $? -ne 0 ]; then
            echo "[watchdog] Signature check failed, moving to rejected"
            mv "$file" "$REJECTED"/
            continue
        fi

        # 2) Host seal verification
        ~/capsule/reserve/engines/seal-verify.sh "$file"
        if [ $? -ne 0 ]; then
            echo "[watchdog] Seal check failed, moving to rejected"
            mv "$file" "$REJECTED"/
            continue
        fi

        # 3) Policy & execution
        ~/capsule/reserve/engines/reserve-engine.sh "$file" "$POLICY"
        if [ $? -ne 0 ]; then
            echo "[watchdog] Policy/engine execution failed, moving to rejected"
            mv "$file" "$REJECTED"/
            continue
        fi

        echo "[watchdog] Intel processed successfully, moving to processed"
        mv "$file" "$PROCESSED"/
    done

    sleep 2
done
