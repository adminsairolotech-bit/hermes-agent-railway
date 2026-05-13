#!/bin/bash
set -e

# Source the hermes env
source /root/.local/bin/env 2>/dev/null || true

# Create config.yaml with env vars
cat > /app/data/config.yaml << 'CONFIGEOF'
model:
  provider: openrouter
  default: anthropic/claude-sonnet-4.6

providers:
  openrouter:
    api_key: "${OPENROUTER_API_KEY}"

fallback_model:
  provider: google
  model: gemini-2.5-flash

google:
  api_key: "${GEMINI_API_KEY}"

nvidia:
  api_key: "${NVIDIA_API_KEY}"

telegram:
  enabled: true
CONFIGEOF

# Replace env var placeholders with actual values
sed -i "s/\${OPENROUTER_API_KEY}/$OPENROUTER_API_KEY/g" /app/data/config.yaml
sed -i "s/\${GEMINI_API_KEY}/$GEMINI_API_KEY/g" /app/data/config.yaml
sed -i "s/\${NVIDIA_API_KEY}/$NVIDIA_API_KEY/g" /app/data/config.yaml

echo "Config created at /app/data/config.yaml:"
cat /app/data/config.yaml

# Run hermes gateway
exec hermes gateway run