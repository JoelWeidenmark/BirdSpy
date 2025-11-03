# BirdSpy Quick Start Guide

## First Time Setup

### 1. Download BirdNET Model

The BirdNET model needs to be downloaded before the backend can analyze audio. Run this once:

```bash
cd bird-analyzer
python3 -c "from birdnet_analyzer.utils import ensure_model_exists; ensure_model_exists()"
cd ..
```

This downloads ~224MB of model files. It takes about 1 minute.

## Running BirdSpy

### Start All Services

```bash
docker-compose up -d
```

This starts:
- **Backend** (BirdNET analyzer) on port 8080
- **Frontend** (Next.js app) on port 3000

The first time will take a few minutes to build both Docker images.

### Wait for Services to Start

The backend needs to load the BirdNET model, which takes about 10-15 seconds. Watch the logs:

```bash
docker-compose logs -f backend
```

When you see `UP AND RUNNING! LISTENING ON 0.0.0.0:8080`, the backend is ready.

Press `Ctrl+C` to stop following logs.

### Check Services are Running

```bash
docker ps | grep birdnet
```

You should see both `birdnet-backend` and `birdnet-frontend` running.

## Testing the System

### Test Backend Analysis

Analyze the included test file `burd.wav`:

```bash
curl -X POST http://localhost:8080/analyze \
  -F 'audio=@bird-analyzer/burd.wav' \
  -F 'meta={}' | python3 -m json.tool
```

**Expected output:**
```json
{
    "msg": "success",
    "results": [
        ["Eleoscytalopus indigoticus_White-breasted Tapaculo", 0.18954],
        ["Streptopelia decaocto_Eurasian Collared-Dove", 0.18562],
        ...
    ]
}
```

### Test Frontend

Visit the frontend in your browser:

```bash
open http://localhost:3000
```

Or test with curl:

```bash
curl -s http://localhost:3000 | head -5
```

You should see HTML output from the Next.js app.

## Stopping Services

```bash
docker-compose down
```

This stops and removes the containers (but preserves the images for faster restart).

## Troubleshooting

### Backend Won't Start - Missing Model

**Symptom:** Logs show `Missing BirdNET_GLOBAL_6K_V2.4_Model/...`

**Solution:** Download the model manually (see "First Time Setup" above).

### Port Already in Use

**Symptom:** Error about port 8080 or 3000 already allocated

**Solution:** Stop other containers or services using those ports:
```bash
# Check what's using the port
lsof -i :8080
lsof -i :3000

# Stop any old BirdNET containers
docker ps -a | grep birdnet
docker stop <container-id>
```

### Backend Container Keeps Restarting

**Symptom:** `docker ps` shows backend restarting repeatedly

**Solution:** Check logs for errors:
```bash
docker-compose logs backend
```

Common issues:
- Model files not downloaded (see above)
- Insufficient memory (BirdNET needs ~1GB RAM)

### Rebuild Everything

If things aren't working, rebuild from scratch:

```bash
# Stop and remove containers
docker-compose down

# Remove old images
docker-compose rm -f

# Rebuild and start
docker-compose up --build -d
```

## Common Commands

### View Logs

```bash
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# Frontend only
docker-compose logs -f frontend
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart backend only
docker-compose restart backend
```

### Check Service Status

```bash
docker-compose ps
```

## What's Next?

Once everything is running, you can:

1. **Build the frontend UI** - File upload component (see `MVP_PLAN.md`)
2. **Test with your own audio** - Place `.wav` files in `bird-analyzer/uploads/`
3. **Integrate with the API** - Frontend connects to backend at `http://backend:8080`

## Quick Reference

| Service  | URL                     | Purpose                    |
|----------|-------------------------|----------------------------|
| Frontend | http://localhost:3000   | Web interface              |
| Backend  | http://localhost:8080   | BirdNET API                |

### API Endpoints

- `POST /analyze` - Analyze audio file
- `GET /health` - Check server status

See `bird-analyzer/BIRDSPY_INTEGRATION.md` for complete API documentation.
