# BirdSpy - How to Run

## Quick Start

### Start All Services (Recommended)

```bash
# Start both frontend and backend
docker-compose up

# Or run in background
docker-compose up -d
```

**Services:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080

### Start Individual Services

```bash
# Backend only (BirdNET server)
docker-compose up backend

# Frontend only (Next.js app)
docker-compose up frontend
```

### Test Backend Server

```bash
# Check health
curl http://localhost:8080/health

# Analyze a file
curl -X POST http://localhost:8080/analyze \
  -F "audio=@your_recording.wav" \
  -F "lat=42.5" \
  -F "lon=-76.5" \
  -F "week=20"
```

## Development

### View Logs

```bash
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# Frontend only
docker-compose logs -f frontend
```

### Rebuild After Changes

```bash
# Rebuild all
docker-compose build

# Rebuild specific service
docker-compose build backend
docker-compose build frontend
```

### Stop Services

```bash
# Stop all
docker-compose down

# Stop specific service
docker-compose stop backend
```

## Backend API Documentation

See `bird-analyzer/BIRDSPY_INTEGRATION.md` for complete API documentation.

### Available Endpoints

- `GET /health` - Server health check
- `POST /analyze` - Upload and analyze audio file

### Example Usage

```bash
curl -X POST http://localhost:8080/analyze \
  -F "audio=@bird_recording.wav" \
  -F "lat=42.5" \
  -F "lon=-76.5" \
  -F "week=20"
```

## Troubleshooting

### Backend Won't Start

```bash
# Check logs
docker-compose logs backend

# Common issues:
# - Port 8080 already in use
# - FFmpeg not installed in container
# - Model download issues
```

### Frontend Can't Connect to Backend

```bash
# Verify backend is running
curl http://localhost:8080/health

# Check network connectivity within Docker
docker-compose exec frontend ping backend

# Ensure environment variable is set
docker-compose exec frontend env | grep NEXT_PUBLIC_API_URL
```

### Rebuild Everything

```bash
# Stop all containers
docker-compose down

# Remove old images
docker-compose rm -f

# Rebuild and restart
docker-compose up --build
```

## Development Workflow

### Making Changes

1. **Backend Changes**: The bird-analyzer is an external project - avoid making changes
2. **Frontend Changes**: Edit files in `birdspy-app/`, hot reload is enabled
3. **Docker Config**: Changes to `docker-compose.yml` require restart

### Testing Audio Analysis

```bash
# Place test audio in bird-analyzer/uploads
cp test_recording.wav bird-analyzer/uploads/

# Analyze via API
curl -X POST http://localhost:8080/analyze \
  -F "audio=@bird-analyzer/uploads/test_recording.wav"
```

## Production Deployment

For production deployment on Raspberry Pi or other devices:

```bash
# Use production build for frontend
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

See `PROJECT_GOALS.md` for complete production deployment plans.



