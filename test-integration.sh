#!/bin/bash

# BirdSpy Integration Test
# Tests that the bird-analyzer works with docker-compose

set -e

echo "🧪 BirdSpy Integration Test"
echo "============================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ docker-compose not found${NC}"
    exit 1
fi

echo -e "${YELLOW}1. Starting services...${NC}"
docker-compose up -d

echo ""
echo -e "${YELLOW}2. Waiting for backend to be ready...${NC}"
sleep 10

# Test backend health
echo ""
echo -e "${YELLOW}3. Testing backend health endpoint...${NC}"
if curl -f http://localhost:8080/health &> /dev/null; then
    echo -e "${GREEN}✓ Backend is healthy${NC}"
else
    echo -e "${RED}❌ Backend health check failed${NC}"
    echo ""
    echo "Backend logs:"
    docker-compose logs backend
    exit 1
fi

# Test frontend
echo ""
echo -e "${YELLOW}4. Testing frontend...${NC}"
if curl -f http://localhost:3000 &> /dev/null; then
    echo -e "${GREEN}✓ Frontend is responding${NC}"
else
    echo -e "${RED}❌ Frontend is not responding${NC}"
    echo ""
    echo "Frontend logs:"
    docker-compose logs frontend
    exit 1
fi

echo ""
echo -e "${GREEN}✅ All tests passed!${NC}"
echo ""
echo "Services running:"
echo "  - Frontend: http://localhost:3000"
echo "  - Backend:  http://localhost:8080"
echo ""
echo "To stop services: docker-compose down"
echo "To view logs: docker-compose logs -f"
