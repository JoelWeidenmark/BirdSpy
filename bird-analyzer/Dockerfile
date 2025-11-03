# Build from Python slim
FROM python:3.11

# Set working directory
WORKDIR /app

# Install required packages while keeping the image small
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg  && rm -rf /var/lib/apt/lists/*

# Import all scripts
COPY . /app/

# Install required Python packages (including server dependencies)
RUN pip3 install --no-cache-dir -e /app[server]

# Download BirdNET model during build
RUN python3 -c "from birdnet_analyzer.utils import ensure_model_exists; ensure_model_exists()"

# Default command (can be overridden in docker-compose)
CMD ["birdnet-server", "--host", "0.0.0.0", "--port", "8080"]
