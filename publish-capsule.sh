#!/data/data/com.termux/files/usr/bin/bash

# === CONFIG ===
KEY_NAME="erik-capsule"
DOMAIN="capsule.blackcorp.me"  # Replace with your actual domain
FILE_NAME="myfile.txt"
CONTENT="Erik's first capsule spell"

# === STEP 1: Create the file ===
echo "$CONTENT" > $FILE_NAME
echo "📄 Created file: $FILE_NAME"

# === STEP 2: Add to IPFS ===
CID=$(ipfs add -q $FILE_NAME)
echo "📦 Added to IPFS with CID: $CID"

# === STEP 3: Pin the content ===
ipfs pin add $CID
echo "📌 Pinned CID locally."

# === STEP 4: Generate IPNS key if missing ===
if ! ipfs key list -l | grep -q "$KEY_NAME"; then
  ipfs key gen --type=rsa --size=2048 $KEY_NAME
  echo "🔑 Generated IPNS key: $KEY_NAME"
fi

# === STEP 5: Publish to IPNS ===
IPNS_ID=$(ipfs key list -l | grep "$KEY_NAME" | awk '{print $1}')
ipfs name publish --key=$KEY_NAME /ipfs/$CID
echo "🌐 Published to IPNS: /ipns/$IPNS_ID"

# === STEP 6: Output DNSLink TXT record ===
echo ""
echo "🧭 To link this capsule to your domain via DNSLink:"
echo "Add the following TXT record to your DNS zone for $DOMAIN:"
echo ""
echo "_dnslink.$DOMAIN. IN TXT \"dnslink=/ipns/$IPNS_ID\""
echo ""
echo "Once propagated, your capsule will be accessible at:"
echo "https://$DOMAIN.ipns.dweb.link"
