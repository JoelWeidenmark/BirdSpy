# BirdSpy - Real-time Bird Monitoring System

## Project Vision

BirdSpy is a comprehensive bird monitoring system designed to run on a Raspberry Pi in Docker containers. The system continuously captures audio, analyzes bird calls in real-time using BirdNET, and presents findings through a modern web interface.

## MVP (Minimum Viable Product) - Phase 0 🚀

**See [MVP_PLAN.md](MVP_PLAN.md) for detailed implementation plan**

**Goal**: File upload bird analyzer - users can upload WAV files and get beautiful species identification results

### Quick MVP Summary
- **Core Feature**: Drag & drop WAV file → BirdNET analysis → Species results with audio playback
- **Technology**: Existing Next.js frontend + Python backend, enhanced with file upload
- **No Real-time Components**: Focus on perfecting the core analysis experience first
- **Success Metric**: Complete file → analysis → results flow in under 30 seconds

## End Goals

### 🎯 Primary Objectives

1. **Real-time Bird Detection**: Continuous audio monitoring with instant species identification
2. **Raspberry Pi Deployment**: Optimized for ARM architecture and resource constraints
3. **Modern Web Interface**: Intuitive dashboard for live monitoring and historical analysis
4. **Docker Containerization**: Easy deployment and maintenance through containers
5. **Data Persistence**: Historical tracking of bird activity and patterns

## System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Audio Input   │───▶│   Processing    │───▶│   Frontend      │
│   (Microphone)  │    │   Backend       │    │   Dashboard     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Audio Capture   │    │ BirdNET Analysis│    │ Real-time UI    │
│ Service         │    │ + WebSocket     │    │ + Audio Player  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Component Specifications

### 1. Audio Capture Service 🎤
**Status**: To Be Implemented

**Purpose**: Continuous audio input processing
- **Technology**: Python with `pyaudio` or `sounddevice`
- **Features**:
  - Continuous 3-second audio chunks (BirdNET standard)
  - Audio preprocessing (noise reduction, normalization)
  - Circular buffer management for storage efficiency
  - Queue system for analysis pipeline
  - Weather-resistant USB microphone support
- **Docker Integration**: Dedicated container with audio device access
- **Output**: Timestamped audio files in shared volume

### 2. Enhanced Backend Service 🧠
**Status**: Existing (Requires Enhancement)

**Current State**: BirdNET analyzer with HTTP server on port 5000
**Required Enhancements**:
- **Real-time Processing**: File watcher for new audio chunks
- **WebSocket Support**: Live updates to frontend clients
- **Database Integration**: Detection history and metadata storage
- **Enhanced API Endpoints**:
  - `GET /detections/live` - WebSocket stream of current detections
  - `GET /detections/history` - Historical detection data with filtering
  - `GET /audio/{id}` - Serve recorded audio files
  - `GET /stats` - System health and detection statistics
  - `GET /species` - Available species information
- **Caching Layer**: Redis for recent detections and performance
- **Model Optimization**: BirdNET Lite for Raspberry Pi efficiency

### 3. Frontend Dashboard 🌐
**Status**: Existing (Requires Major Enhancement)

**Current State**: Next.js application with Tailwind CSS on port 3000
**Required Features**:

#### Real-time Dashboard
- Live detection feed with timestamps and confidence scores
- Audio waveform visualization during analysis
- Species identification cards with photos and information
- Interactive audio playback of detected calls
- Real-time system status indicators

#### Historical Analysis
- Daily/weekly/monthly detection summaries
- Species trend charts and migration patterns
- Audio archive browser with search capabilities
- Detection confidence analytics
- Export functionality for research data

#### System Monitoring
- Raspberry Pi health metrics (CPU, memory, temperature)
- Microphone status and audio quality indicators
- Detection pipeline performance metrics
- Storage usage and cleanup status

**Technology Stack**:
- Next.js 15 with TypeScript
- Tailwind CSS for styling
- WebSocket client for real-time updates
- WaveSurfer.js for audio visualization
- Recharts for data visualization
- React Query for data management

### 4. Database Layer 💾
**Status**: To Be Implemented

**Purpose**: Persistent storage for detections and system data
- **Technology**: PostgreSQL (scalable) or SQLite (Pi-optimized)
- **Schema Design**:
  ```sql
  -- Core detection data
  CREATE TABLE detections (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    species VARCHAR(255) NOT NULL,
    common_name VARCHAR(255),
    confidence DECIMAL(5,4) NOT NULL,
    audio_file_id INTEGER REFERENCES audio_files(id),
    location_lat DECIMAL(10,8),
    location_lng DECIMAL(11,8),
    weather_conditions JSONB,
    created_at TIMESTAMP DEFAULT NOW()
  );

  -- Audio file metadata
  CREATE TABLE audio_files (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) UNIQUE NOT NULL,
    file_path TEXT NOT NULL,
    duration_seconds DECIMAL(8,3),
    sample_rate INTEGER,
    file_size_bytes BIGINT,
    created_at TIMESTAMP DEFAULT NOW(),
    processed_at TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending'
  );

  -- System health monitoring
  CREATE TABLE system_stats (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    cpu_usage DECIMAL(5,2),
    memory_usage DECIMAL(5,2),
    temperature DECIMAL(5,2),
    disk_usage DECIMAL(5,2),
    active_processes INTEGER
  );

  -- Species information cache
  CREATE TABLE species_info (
    code VARCHAR(10) PRIMARY KEY,
    common_name VARCHAR(255),
    scientific_name VARCHAR(255),
    family VARCHAR(255),
    description TEXT,
    habitat TEXT,
    migration_pattern VARCHAR(100),
    conservation_status VARCHAR(50)
  );
  ```

### 5. Message Queue & Real-time Communication 📡
**Status**: To Be Implemented

**Purpose**: Handle real-time data flow between components
- **Technology**: Redis with pub/sub or dedicated WebSocket server
- **Communication Flows**:
  - Audio Capture → Analysis Queue
  - Analysis Results → Frontend WebSocket
  - System Events → Monitoring Dashboard
  - Error Notifications → Alert System

### 6. Reverse Proxy & Load Balancing 🔄
**Status**: To Be Implemented (Production)

**Purpose**: Production-ready request handling
- **Technology**: Nginx
- **Features**:
  - SSL termination
  - Static file serving
  - API rate limiting
  - Health check endpoints
  - Log aggregation

## Docker Compose Service Architecture

```yaml
version: '3.8'

services:
  # Enhanced existing services
  birdnet-backend:
    # Current backend + WebSocket + Database integration
    ports: ["5000:5000"]
    
  birdnet-frontend:
    # Current frontend + Real-time features
    ports: ["3000:3000"]
  
  # New services to implement
  audio-capture:
    # Microphone input handler
    devices: ["/dev/snd:/dev/snd"]
    volumes: ["./audio-data:/app/audio-data"]
    
  database:
    # PostgreSQL or SQLite
    volumes: ["./db-data:/var/lib/postgresql/data"]
    
  redis:
    # Message queue and cache
    volumes: ["./redis-data:/data"]
    
  nginx:
    # Reverse proxy (production only)
    ports: ["80:80", "443:443"]
```

## Development Roadmap

### Phase 0: MVP - File Upload Analyzer
**Goal**: Validate core functionality with simple file-based interface
- [ ] Create file upload component in frontend
- [ ] Add file upload endpoint to backend (`POST /analyze`)
- [ ] Implement audio player with waveform visualization
- [ ] Design clean results display for species detection
- [ ] Add basic error handling and file validation
- [ ] Test with sample WAV files
- [ ] Polish UI/UX for core user journey

**MVP Deliverables**:
- Working file upload → analysis → results flow
- Audio playback with visual waveform
- Species results with confidence scores
- Responsive, intuitive interface
- Docker containers running the complete stack

### Phase 1: Enhanced Analysis
**Goal**: Improve analysis capabilities and user experience
- [ ] Add support for multiple audio formats (MP3, FLAC)
- [ ] Implement batch file processing
- [ ] Add species information lookup (descriptions, photos)
- [ ] Create analysis history (session-based storage)
- [ ] Add export functionality (CSV, JSON)
- [ ] Performance optimization for larger files

### Phase 2: Real-time Foundation
**Goal**: Begin transition to real-time capabilities
- [ ] Set up database schema and migrations
- [ ] Add WebSocket support to backend
- [ ] Create real-time components in frontend
- [ ] Implement detection persistence
- [ ] Add system monitoring basics

### Phase 3: Audio Pipeline
**Goal**: Add continuous audio processing
- [ ] Develop audio capture service
- [ ] Connect capture → analysis pipeline
- [ ] Test end-to-end detection flow
- [ ] Implement file management and cleanup

### Phase 4: Advanced Dashboard
**Goal**: Build comprehensive monitoring interface
- [ ] Build real-time dashboard
- [ ] Add historical analysis views
- [ ] Create system monitoring interface
- [ ] Implement data visualization components

### Phase 5: Production Deployment
**Goal**: Raspberry Pi optimization and deployment
- [ ] Optimize containers for ARM architecture
- [ ] Performance tuning for limited resources
- [ ] Create deployment scripts and documentation
- [ ] Implement monitoring and alerting

## Hardware Requirements

### Raspberry Pi Setup
- **Model**: Raspberry Pi 4B (4GB+ RAM recommended)
- **Storage**: High-speed SD card (64GB+) + USB SSD for audio storage
- **Audio**: USB microphone with weather protection
- **Cooling**: Active cooling solution for continuous operation
- **Power**: Reliable power supply with UPS backup option
- **Network**: Ethernet connection preferred for stability

### Audio Equipment
- Weather-resistant USB microphone
- Outdoor mounting hardware
- Cable management for outdoor installation
- Optional: Multiple microphones for coverage area expansion

## Performance Targets

### Real-time Processing
- **Detection Latency**: < 5 seconds from audio input to result
- **Analysis Throughput**: Process 3-second chunks continuously
- **System Uptime**: 99%+ availability with automatic recovery

### Resource Utilization
- **CPU Usage**: < 80% average on Raspberry Pi 4
- **Memory Usage**: < 3GB RAM utilization
- **Storage**: Automatic cleanup to maintain < 80% disk usage
- **Network**: Minimal bandwidth requirements for remote monitoring

### Detection Accuracy
- **Confidence Threshold**: Configurable (default 0.7)
- **False Positive Rate**: < 5% for common species
- **Species Coverage**: Support for regional bird populations

## Data Management

### Storage Strategy
- **Audio Retention**: 7-day rolling window with selective archiving
- **Detection History**: Permanent storage with monthly aggregation
- **System Logs**: 30-day retention with error highlighting
- **Backup**: Daily incremental backups to external storage

### Privacy & Security
- **Local Processing**: All analysis performed on-device
- **Optional Cloud Sync**: User-controlled data sharing
- **Access Control**: Local network access with optional authentication
- **Data Export**: Standard formats for research and analysis

## Success Metrics

### Technical Metrics
- System uptime > 99%
- Detection processing < 5 seconds
- Resource usage within Pi 4 limits
- Zero data loss incidents

### User Experience
- Intuitive dashboard requiring no training
- Real-time updates with < 2 second latency
- Historical data accessible within 1 second
- Mobile-responsive interface

### Scientific Value
- Accurate species identification for research
- Temporal pattern analysis capabilities
- Export compatibility with eBird and research platforms
- Contribution to citizen science initiatives

## Future Enhancements

### Advanced Features
- Multiple microphone array support
- Machine learning model customization
- Weather station integration
- Migration pattern analysis
- Community data sharing network

### Integration Possibilities
- eBird automatic submissions
- Research institution data sharing
- Smart home system integration
- Mobile app companion
- Social media sharing features

---

*This document serves as the north star for BirdSpy development. All implementation decisions should align with these end goals while maintaining flexibility for evolution based on user feedback and technical discoveries.*
