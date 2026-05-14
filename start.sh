#!/bin/bash
set -e

# Source the hermes env
source /root/.local/bin/env 2>/dev/null || true

# Create config.yaml with env vars (no fallback to avoid rate limits)
cat > /app/data/config.yaml << 'CONFIGEOF'
model:
  provider: groq
  default: groq/llama-3.3-70b-versatile

providers:
  groq:
    api_key: "${GROQ_API_KEY}"

nvidia:
  api_key: "${NVIDIA_API_KEY}"

telegram:
  enabled: true
CONFIGEOF

# Replace env var placeholders with actual values
sed -i "s/\${GROQ_API_KEY}/$GROQ_API_KEY/g" /app/data/config.yaml
sed -i "s/\${NVIDIA_API_KEY}/$NVIDIA_API_KEY/g" /app/data/config.yaml

echo "Config created at /app/data/config.yaml:"
cat /app/data/config.yaml

# Run hermes gateway
exec hermes gateway run