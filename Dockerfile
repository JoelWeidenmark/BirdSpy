# Build from Python slim
FROM python:3.11

# Install required packages while keeping the image small
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy the bird-analyzer folder into the container
COPY ./bird-analyzer /app/bird-analyzer

# Set working directory to the bird-analyzer folder
WORKDIR /app/bird-analyzer

# Install required Python packages
RUN pip3 install --no-cache-dir .

# Add entry point to run the script
ENTRYPOINT [ "python3" ]
CMD [ "-m", "birdnet_analyzer.analyze" ]
