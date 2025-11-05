# AidConnect - Quick Start Guide

## 🚀 **Get AidConnect Running in 5 Minutes**

### Prerequisites
- Docker & Docker Compose
- Git

### Step 1: Clone and Setup
```bash
git clone <repository-url>
cd AidConnect

# Copy environment files
cp .env.example .env
cp docker-compose.yml docker-compose.local.yml
```

### Step 2: Start All Services
```bash
# Start complete stack
docker-compose -f docker-compose.local.yml up -d

# Or start individual services
docker-compose up -d mongodb redis backend frontend ml-service
```

### Step 3: Verify Services
```bash
# Check all services are running
docker-compose ps

# View logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs ml-service
```

### Step 4: Run Demo
```bash
# Make demo script executable
chmod +x scripts/demo_end_to_end.sh

# Run complete demo
./scripts/demo_end_to_end.sh
```

## 🎯 **Alternative: Local Development**

### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt

# Start MongoDB & Redis
docker-compose up -d mongodb redis

# Start Flask app
python app.py
```

### Frontend Setup
```bash
# Install dependencies
npm install

# Start dev server
npm run dev
```

### ML Service Setup
```bash
cd ml
pip install -r requirements.txt

# Train model (optional)
python train_hotspot_model.py

# Start ML service
python api.py
```

## 📊 **Available Services**

| Service | URL | Purpose |
|---------|-----|---------|
| **Frontend** | http://localhost:5173 | React PWA |
| **Backend API** | http://localhost:5000 | Flask REST API |
| **ML Service** | http://localhost:5001 | Hotspot Prediction |
| **MongoDB** | localhost:27017 | Database |
| **Redis** | localhost:6379 | Cache & Queue |

## 🔗 **Key Demo URLs**

- **Homepage**: http://localhost:5173
- **Donor Dashboard**: http://localhost:5173/donor
- **Volunteer PWA**: http://localhost:5173/volunteer
- **Proof Verification**: http://localhost:5173/proof/:donationId
- **Hotspot Prediction**: http://localhost:5173/hotspots
- **API Health**: http://localhost:5000/health
- **ML Health**: http://localhost:5001/health

## 🎬 **Demo Flow**

1. **Create ₹500 Donation** → Allocate to 3 Water Kits
2. **Volunteer Delivery** → Photo + GPS + Signature Verification
3. **Merkle Tree Building** → Cryptographic Proof Generation
4. **External Anchoring** → Tamper-Evident Verification
5. **ML Hotspot Prediction** → AI-Powered Demand Forecasting
6. **Complete Proof Package** → Downloadable Verification Chain

## 🛠️ **Troubleshooting**

### Common Issues

**Port Conflicts**:
```bash
# Check ports in use
netstat -tulpn | grep -E ':(5000|5001|5173|27017|6379)'

# Stop conflicting services
sudo fuser -k 5000/tcp
```

**Docker Issues**:
```bash
# Clean restart
docker-compose down
docker system prune -f
docker-compose up --build
```

**Permission Issues**:
```bash
# Fix script permissions
chmod +x scripts/*.sh
chmod +x scripts/demo_end_to_end.sh
```

### Environment Variables

```bash
# Core Configuration
VITE_API_BASE_URL=http://localhost:5000
MONGO_URI=mongodb://localhost:27017/aidconnect
REDIS_URL=redis://localhost:6379/0

# Firebase Configuration (Already Configured)
VITE_FIREBASE_PROJECT_ID=aidconnect-7a599
VITE_FIREBASE_AUTH_DOMAIN=aidconnect-7a599.firebaseapp.com

# Security
JWT_SECRET_KEY=your_jwt_secret_key
ANCHOR_PROVIDER=simulated  # simulated|opentimestamp|bitcoin_testnet
```

## 📱 **Mobile Testing**

### Progressive Web App
- Visit http://localhost:5173 on mobile
- Tap "Add to Home Screen"
- Test offline functionality

### Volunteer App Features
- QR Code Scanning
- Photo Capture
- GPS Location
- Offline Queue
- Signature Capture

## 🔧 **Development Tools**

### Useful Commands
```bash
# View all logs
docker-compose logs -f

# Restart specific service
docker-compose restart backend

# Access MongoDB
docker-compose exec mongodb mongosh

# Access Redis
docker-compose exec redis redis-cli

# Run tests
cd backend && pytest
cd ../frontend && npm test

# Build for production
docker-compose -f docker-compose.prod.yml up
```

### Hot Reload Development
```bash
# Frontend hot reload enabled
npm run dev

# Backend development mode
export FLASK_ENV=development
python app.py

# ML service development
export FLASK_ENV=development  
python ml/api.py
```

## 📈 **Performance Monitoring**

### Health Checks
- **Backend**: http://localhost:5000/health
- **ML Service**: http://localhost:5001/health
- **MongoDB**: `docker-compose exec mongodb mongosh --eval "db.runCommand('ping')"`
- **Redis**: `docker-compose exec redis redis-cli ping`

### Metrics Endpoints
- **Donation Metrics**: GET /dashboard/metrics
- **ML Model Performance**: GET /api/model/info
- **Merkle Tree Status**: GET /api/merkle/status

## 🌐 **Production Deployment**

### AWS Deployment
```bash
# Using Terraform (see infra/terraform/)
cd infra/terraform
terraform init
terraform plan
terraform apply
```

### Manual Cloud Deployment
```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy to cloud provider
docker-compose -f docker-compose.prod.yml up -d
```

## ✅ **Verification Checklist**

After setup, verify these core features:

- [ ] **Homepage loads**: http://localhost:5173
- [ ] **Authentication works**: Google sign-in
- [ ] **Donation creation**: ₹500 → 3 Water Kits
- [ ] **Delivery verification**: Photo + GPS + Signature
- [ ] **Merkle proof**: Cryptographic verification
- [ ] **ML predictions**: Hotspot forecasting
- [ ] **Proof download**: JSON package generation
- [ ] **Mobile PWA**: Install on device

## 🆘 **Support**

### Getting Help
1. Check logs: `docker-compose logs`
2. Verify health: Visit `/health` endpoints
3. Read configuration: Check `.env` file
4. Test demo script: `./scripts/demo_end_to_end.sh`

### Reset Everything
```bash
# Nuclear option
docker-compose down -v
docker system prune -af
docker volume prune -f
./scripts/demo_end_to_end.sh
```

---

**🎉 You're ready to explore AidConnect! Start with the demo script to see everything in action.**
