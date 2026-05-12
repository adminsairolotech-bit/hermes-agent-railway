FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
ENV HERMES_HOME=/app/data

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ripgrep \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Hermes Agent
RUN curl -LsSf https://hermes-agent.nousresearch.com/install.sh | UV_NO_CONFIG=1 bash -s -- --install-dir /app/hermes

ENV PATH="/app/hermes:${PATH}"

# Create data directory
RUN mkdir -p /app/data

WORKDIR /app

# Default command - start Hermes Agent
CMD ["hermes", "agent", "start"]
