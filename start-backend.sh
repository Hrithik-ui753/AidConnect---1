#!/bin/bash

# AidConnect Backend Startup Script
# This script sets up and starts the complete backend system

set -e

echo "🚀 AidConnect Backend Startup"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}🔄 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "Please run this script from the AidConnect root directory"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_status "Checking system requirements..."

# Check if ports are available
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        print_warning "Port $1 is already in use. This might cause issues."
    else
        print_success "Port $1 is available"
    fi
}

check_port 27017  # MongoDB
check_port 6379   # Redis
check_port 5000   # Backend API
check_port 5001   # ML Service
check_port 5173   # Frontend

print_status "Starting AidConnect services..."

# Create necessary directories
mkdir -p backend/logs
mkdir -p backend/uploads
mkdir -p ml/models
mkdir -p ml/logs

# Start services with Docker Compose
print_status "Starting Docker containers..."
docker-compose up -d

# Wait for services to be ready
print_status "Waiting for services to start..."

# Function to wait for a service to be ready
wait_for_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:$port/health > /dev/null 2>&1; then
            print_success "$service_name is ready"
            return 0
        fi
        
        print_status "Waiting for $service_name... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_error "$service_name failed to start within timeout"
    return 1
}

# Wait for backend API
if wait_for_service "Backend API" 5000; then
    print_success "Backend API is running at http://localhost:5000"
else
    print_error "Backend API failed to start"
    docker-compose logs backend
    exit 1
fi

# Wait for ML service
if wait_for_service "ML Service" 5001; then
    print_success "ML Service is running at http://localhost:5001"
else
    print_warning "ML Service failed to start (this is optional)"
fi

# Check MongoDB connection
print_status "Checking MongoDB connection..."
if docker-compose exec -T mongodb mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    print_success "MongoDB is running and accessible"
else
    print_warning "MongoDB connection check failed"
fi

# Check Redis connection
print_status "Checking Redis connection..."
if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
    print_success "Redis is running and accessible"
else
    print_warning "Redis connection check failed"
fi

# Show service status
print_status "Service Status:"
echo "=================="
docker-compose ps

echo ""
print_success "AidConnect Backend is now running!"
echo ""
echo "🌐 Services:"
echo "  - Backend API: http://localhost:5000"
echo "  - ML Service:  http://localhost:5001"
echo "  - MongoDB:     localhost:27017"
echo "  - Redis:       localhost:6379"
echo "  - Frontend:    http://localhost:5173"
echo ""
echo "📚 API Documentation:"
echo "  - Health Check: http://localhost:5000/health"
echo "  - API Endpoints: See backend/README.md"
echo ""
echo "🔧 Management Commands:"
echo "  - View logs:    docker-compose logs -f [service]"
echo "  - Stop all:     docker-compose down"
echo "  - Restart:      docker-compose restart [service]"
echo "  - Shell access: docker-compose exec [service] bash"
echo ""

# Check if frontend is also running
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    print_success "Frontend is also running at http://localhost:5173"
    echo ""
    echo "🎉 Complete AidConnect system is ready!"
    echo "   Open http://localhost:5173 in your browser to start using the application."
else
    print_warning "Frontend is not running. Start it separately with: npm run dev"
fi

echo ""
print_success "Setup complete! Happy coding! 🚀"
