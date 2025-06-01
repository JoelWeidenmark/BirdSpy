# Build from Python slim
FROM python:3.11

# Install required packages while keeping the image small
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy the current directory (bird-analyzer) into the container
COPY . /app/bird-analyzer

# Set working directory to the bird-analyzer folder
WORKDIR /app/bird-analyzer

# Install required Python packages
RUN pip3 install --no-cache-dir .

# Add entry point to run the script
ENTRYPOINT [ "python3" ]
CMD [ "-m", "birdnet_analyzer.analyze" ]
