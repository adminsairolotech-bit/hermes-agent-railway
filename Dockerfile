FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV RAILWAY=1
ENV HERMES_IN_DOCKER=1
ENV HERMES_HOME=/app/data
ENV OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
ENV TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
ENV NVIDIA_API_KEY=${NVIDIA_API_KEY}
ENV GEMINI_API_KEY=${GEMINI_API_KEY}
ENV GATEWAY_ALLOW_ALL_USERS=true

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ripgrep \
    ffmpeg \
    libglib2.0-0 \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (required by Hermes Agent)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
ENV HERMES_INSTALL_DIR=/app/hermes
RUN curl -LsSf https://hermes-agent.nousresearch.com/install.sh | UV_NO_CONFIG=1 bash

ENV PATH="/root/.local/bin:/usr/local/lib/hermes-agent:${PATH}"

# Create data directory and configure Telegram
RUN mkdir -p /app/data && \
    /root/.local/bin/hermes gateway install || true

# Create full config file with model + platform settings
RUN echo 'model:' > /app/data/config.yaml && \
    echo '  provider: openrouter' >> /app/data/config.yaml && \
    echo '  default: anthropic/claude-sonnet-4.6' >> /app/data/config.yaml && \
    echo '' >> /app/data/config.yaml && \
    echo 'providers:' >> /app/data/config.yaml && \
    echo '  openrouter:' >> /app/data/config.yaml && \
    echo '    api_key: "'$OPENROUTER_API_KEY'"' >> /app/data/config.yaml && \
    echo '' >> /app/data/config.yaml && \
    echo 'fallback_model:' >> /app/data/config.yaml && \
    echo '  provider: google' >> /app/data/config.yaml && \
    echo '  model: gemini-2.5-flash' >> /app/data/config.yaml && \
    echo '' >> /app/data/config.yaml && \
    echo 'telegram:' >> /app/data/config.yaml && \
    echo '  enabled: true' >> /app/data/config.yaml

WORKDIR /app

# Default command - run Hermes Gateway
CMD ["/bin/bash", "-c", "source /root/.local/bin/env && hermes gateway run"]
