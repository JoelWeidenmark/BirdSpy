# BirdNET-Analyzer Integration for BirdSpy

## Overview

This directory contains the BirdNET-Analyzer project, which provides the core bird identification engine for BirdSpy. BirdNET-Analyzer is an external project developed by the K. Lisa Yang Center for Conservation Bioacoustics at Cornell Lab of Ornithology.

**⚠️ Important**: This is an external project. We make minimal changes to this codebase - only necessary configuration adjustments for BirdSpy integration.

## What It Does

BirdNET-Analyzer provides:
- **Species Identification**: Deep learning model that identifies 6512+ bird species from audio
- **Audio Analysis**: Processes WAV, MP3, and other audio formats
- **HTTP Server**: REST API for analyzing audio files (port 8080)
- **Confidence Scoring**: Returns probability scores for detected species
- **Temporal Detection**: Identifies when specific species were detected in the recording

## How It Works

### Core Components

1. **Network Server** (`birdnet_analyzer/network/server.py`)
   - Runs HTTP server on port 8080
   - Provides `/analyze` endpoint for file uploads
   - Returns JSON with detected species and metadata

2. **Analysis Engine** (`birdnet_analyzer/analyze/`)
   - Loads pre-trained BirdNET model
   - Processes 3-second audio chunks
   - Applies confidence threshold filtering

3. **Audio Processing** (`birdnet_analyzer/audio.py`)
   - Handles multiple audio formats (WAV, MP3, FLAC)
   - Converts and normalizes audio for analysis
   - Extracts spectrograms for the neural network

### Analysis Flow

```
Audio Upload → Format Conversion → 3-sec Chunking → Neural Network → Species Detection → JSON Response
```

## Docker Integration

### Dockerfile

The provided `Dockerfile` sets up the complete BirdNET environment:
- Base: Python 3.11 slim image
- Dependencies: FFmpeg for audio processing
- Installation: Installs BirdNET with server dependencies (`pip install -e .[server]`)
- Command: Runs `birdnet-server --host 0.0.0.0 --port 8080`

### Volumes

- **`/uploads`**: Directory for uploaded audio files to analyze
  - Mapped to `./bird-analyzer/uploads` on host
  - Files placed here can be analyzed by the server

### Environment Variables

- `TF_CPP_MIN_LOG_LEVEL=2`: Reduces TensorFlow logging verbosity
- `MPLBACKEND=Agg`: Sets matplotlib to non-interactive backend (headless mode)

## API Endpoints

### POST /analyze

**Purpose**: Analyze an audio file for bird species

**Request**:
```bash
curl -X POST http://localhost:8080/analyze \
  -F "audio=@path/to/bird_recording.wav" \
  -F "lat=42.5" \
  -F "lon=-76.5" \
  -F "week=20"
```

**Response**:
```json
{
  "species": [
    {
      "common_name": "American Robin",
      "scientific_name": "Turdus migratorius",
      "confidence": 0.89,
      "start_time": 5.2,
      "end_time": 8.1
    }
  ],
  "metadata": {
    "filename": "bird_recording.wav",
    "duration": 30.5,
    "analyzed_at": "2025-11-03T10:30:00Z"
  }
}
```

### GET /health

**Purpose**: Check if server is running

**Response**: `200 OK`

## Configuration

### Analysis Parameters

The server uses these default parameters (configurable via request):
- **Minimum Confidence**: 0.1 (returns detections with >10% confidence)
- **Sensitivity**: 1.0 (standard detection threshold)
- **Overlap**: 0.0 (no overlap between 3-second chunks)

### Location-based Filtering

BirdNET can filter results by:
- **Latitude/Longitude**: Focus on species present in the region
- **Week of Year**: Account for migration patterns

## Usage in BirdSpy

### From Docker Compose

The backend service is automatically started:
```bash
docker-compose up backend
```

Server runs at: `http://localhost:8080`

### From Frontend

The Next.js frontend connects via:
```typescript
const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/analyze`, {
  method: 'POST',
  body: formData
});
```

Where `NEXT_PUBLIC_API_URL=http://backend:8080` in Docker network.

## Development Notes

### ⚠️ Modification Guidelines

**DO**:
- Use the API as-is through HTTP endpoints
- Configure via environment variables when possible
- Report bugs to upstream BirdNET-Analyzer repo

**DON'T**:
- Modify internal BirdNET code or models
- Change core analysis algorithms
- Make structural changes to the analyzer

### Testing Locally

To test the bird-analyzer independently:
```bash
cd bird-analyzer
docker build -t birdnet-test .
docker run -p 8080:8080 -v $(pwd)/uploads:/uploads birdnet-test

# In another terminal:
curl -X POST http://localhost:8080/analyze \
  -F "audio=@test_recording.wav"
```

### Model Updates

BirdNET models are updated periodically. To get the latest model:
1. Check [BirdNET-Analyzer releases](https://github.com/birdnet-team/BirdNET-Analyzer/releases)
2. Update to latest version in `pyproject.toml` if needed
3. Rebuild Docker image

## Performance Considerations

### CPU Usage
- Analysis is CPU-intensive (no GPU acceleration in container)
- Expect ~5-10 seconds per minute of audio on modern hardware
- Raspberry Pi will be slower (~20-30 seconds per minute)

### Memory
- Model requires ~500MB RAM when loaded
- Additional memory needed for audio processing
- Total: ~1GB RAM recommended minimum

### Storage
- Model files: ~150MB
- Audio uploads: Varies based on usage
- Set up cleanup policy for uploads directory

## Troubleshooting

### Server Won't Start
```bash
# Check logs
docker logs birdnet-backend

# Common issues:
# - Port 8080 already in use
# - Insufficient memory
# - FFmpeg not installed
```

### Analysis Fails
```bash
# Verify audio format
file your_audio.wav

# BirdNET supports: WAV, MP3, FLAC, OGG, M4A
# Convert if needed:
ffmpeg -i input.mp3 -ar 48000 output.wav
```

### Low Confidence Results
- Check audio quality (clear bird calls, minimal background noise)
- Verify recording conditions (outdoor recordings work best)
- Consider location-based filtering for better accuracy

## Resources

- **Upstream Project**: https://github.com/birdnet-team/BirdNET-Analyzer
- **Documentation**: https://birdnet-team.github.io/BirdNET-Analyzer/
- **Model Details**: https://zenodo.org/records/15050749
- **Citation**: Kahl et al. (2021), Ecological Informatics

## License

BirdNET-Analyzer uses dual licensing:
- **Source Code**: MIT License
- **Models**: CC BY-NC-SA 4.0 (non-commercial use)

Educational and research purposes are considered non-commercial.
