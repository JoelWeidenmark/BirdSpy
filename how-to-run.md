# Build
docker build -t birdnet-analyzer .

# Command
docker run --rm -v "$(pwd)":/app birdnet-analyzer -m birdnet_analyzer.analyze /app/burd.wav -o .




