FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV HERMES_HOME=/app/data
ENV OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
ENV TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}

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

ENV PATH="/usr/local/lib/hermes-agent:${PATH}"

# Create data directory
RUN mkdir -p /app/data

WORKDIR /app

# Default command - start Hermes Agent with Telegram
CMD ["hermes", "agent", "start", "--telegram"]
