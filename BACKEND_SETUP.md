# AidConnect Backend Setup Guide

This guide will help you set up the complete backend system for AidConnect with database, API, and all services.

## 🚀 Quick Start

### Option 1: Docker (Recommended)

1. **Start all services**:
   ```bash
   ./start-backend.sh
   ```

2. **Or manually with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

### Option 2: Manual Setup

1. **Install dependencies**:
   ```bash
   cd backend
   python setup.py
   ```

2. **Start services individually**:
   ```bash
   # Terminal 1: MongoDB
   mongod --dbpath /path/to/data

   # Terminal 2: Redis
   redis-server

   # Terminal 3: Backend API
   cd backend
   python run.py

   # Terminal 4: ML Service (optional)
   cd ml
   python api.py
   ```

## 📋 Prerequisites

### Required Software

- **Python 3.8+**
- **MongoDB 7.0+**
- **Redis 7.2+**
- **Docker & Docker Compose** (for containerized setup)

### System Requirements

- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 10GB free space
- **Network**: Internet connection for package downloads

## 🗄️ Database Setup

### MongoDB Configuration

1. **Install MongoDB**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install mongodb

   # macOS
   brew install mongodb-community

   # Windows
   # Download from https://www.mongodb.com/try/download/community
   ```

2. **Start MongoDB**:
   ```bash
   # Linux/macOS
   sudo systemctl start mongod
   # or
   mongod --dbpath /var/lib/mongodb

   # Windows
   net start MongoDB
   ```

3. **Create database and user**:
   ```bash
   mongosh
   use aidconnect
   db.createUser({
     user: "aidconnect_admin",
     pwd: "aidconnect_password_2024",
     roles: ["readWrite"]
   })
   ```

### Redis Configuration

1. **Install Redis**:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install redis-server

   # macOS
   brew install redis

   # Windows
   # Download from https://github.com/microsoftarchive/redis/releases
   ```

2. **Start Redis**:
   ```bash
   # Linux/macOS
   sudo systemctl start redis
   # or
   redis-server

   # Windows
   redis-server.exe
   ```

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the `backend` directory:

```bash
# Flask Configuration
FLASK_ENV=development
SECRET_KEY=your-secret-key-here

# Database
MONGO_URI=mongodb://localhost:27017/aidconnect
REDIS_URL=redis://localhost:6379/0

# JWT
JWT_SECRET_KEY=your-jwt-secret-key

# Payment Gateway (Razorpay)
RAZORPAY_KEY_ID=your-razorpay-key-id
RAZORPAY_KEY_SECRET=your-razorpay-key-secret

# ML Service
ML_SERVICE_URL=http://localhost:5001

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
```

### Firebase Configuration

Update your Firebase config in the frontend:

```javascript
// src/config/firebase.ts
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-app-id"
};
```

## 🏗️ Project Structure

```
backend/
├── app.py                 # Main Flask application
├── run.py                 # Application runner
├── config.py              # Configuration management
├── database.py            # Database connection
├── setup.py               # Setup script
├── models/                # MongoDB models
│   ├── __init__.py
│   ├── user.py
│   ├── donation.py
│   ├── campaign.py
│   ├── delivery.py
│   ├── merkle.py
│   └── inventory.py
├── services/              # Business logic
│   ├── __init__.py
│   ├── user_service.py
│   ├── donation_service.py
│   ├── campaign_service.py
│   ├── merkle_service.py
│   ├── ml_service.py
│   └── inventory_service.py
├── routes/                # API endpoints
│   ├── __init__.py
│   ├── auth.py
│   ├── donations.py
│   ├── campaigns.py
│   ├── delivery.py
│   ├── merkle.py
│   ├── ml.py
│   ├── users.py
│   └── inventory.py
├── workers/               # Background tasks
│   ├── celery_worker.py
│   ├── merkle_tasks.py
│   └── donation_tasks.py
├── scripts/               # Utility scripts
│   └── mongo-init.js
└── tests/                 # Test files
```

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile

### Donations
- `POST /api/donations` - Create donation
- `GET /api/donations/{id}` - Get donation details
- `GET /api/donations/{id}/proof` - Get proof package
- `PATCH /api/donations/{id}/allocate` - Allocate donation

### Campaigns
- `GET /api/campaigns` - List campaigns
- `POST /api/campaigns` - Create campaign
- `GET /api/campaigns/{id}` - Get campaign details
- `PUT /api/campaigns/{id}` - Update campaign

### Delivery
- `POST /api/delivery/events` - Create delivery event
- `GET /api/delivery/events/{id}` - Get delivery details
- `POST /api/delivery/verify` - Verify delivery

### Merkle Trees
- `POST /api/merkle/build` - Build Merkle tree
- `POST /api/merkle/anchor` - Anchor root hash
- `GET /api/merkle/root/{date}` - Get root hash
- `POST /api/merkle/verify` - Verify proof

### ML Hotspots
- `GET /api/ml/hotspots` - Get hotspot predictions
- `POST /api/ml/hotspots/evaluate` - Evaluate model

## 🧪 Testing

### Run Tests
```bash
cd backend
pytest

# With coverage
pytest --cov=.

# Specific test file
pytest tests/test_donations.py
```

### Test API Endpoints
```bash
# Health check
curl http://localhost:5000/health

# Register user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User","role":"donor"}'

# List campaigns
curl http://localhost:5000/api/campaigns
```

## 🐳 Docker Setup

### Using Docker Compose

1. **Start all services**:
   ```bash
   docker-compose up -d
   ```

2. **View logs**:
   ```bash
   docker-compose logs -f backend
   ```

3. **Stop services**:
   ```bash
   docker-compose down
   ```

### Individual Services

```bash
# MongoDB
docker run -d --name mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=aidconnect_admin \
  -e MONGO_INITDB_ROOT_PASSWORD=aidconnect_password_2024 \
  mongo:7.0

# Redis
docker run -d --name redis \
  -p 6379:6379 \
  redis:7.2-alpine

# Backend API
docker build -t aidconnect-backend ./backend
docker run -d --name backend \
  -p 5000:5000 \
  --link mongodb:mongodb \
  --link redis:redis \
  aidconnect-backend
```

## 📊 Monitoring

### Health Checks

- **Backend API**: `GET http://localhost:5000/health`
- **ML Service**: `GET http://localhost:5001/health`
- **MongoDB**: `mongosh --eval "db.adminCommand('ping')"`
- **Redis**: `redis-cli ping`

### Logs

```bash
# Docker logs
docker-compose logs -f backend
docker-compose logs -f mongodb
docker-compose logs -f redis

# Application logs
tail -f backend/logs/app.log
```

### Metrics

- **Database**: MongoDB Compass or Studio 3T
- **Cache**: RedisInsight
- **API**: Built-in health endpoints

## 🔒 Security

### Authentication
- Firebase Authentication for user management
- JWT tokens for API access
- Role-based access control (RBAC)

### Data Protection
- Input validation with Pydantic
- SQL injection prevention (NoSQL)
- Rate limiting with Redis
- CORS configuration

### Production Security
- Environment variable management
- HTTPS/TLS encryption
- Database access controls
- Regular security updates

## 🚀 Deployment

### Production Setup

1. **Environment Configuration**:
   ```bash
   export FLASK_ENV=production
   export MONGO_URI=mongodb://prod-server:27017/aidconnect
   export REDIS_URL=redis://prod-server:6379/0
   ```

2. **Using Gunicorn**:
   ```bash
   gunicorn --bind 0.0.0.0:5000 --workers 4 app:app
   ```

3. **Using Docker**:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Scaling

- **Horizontal Scaling**: Multiple backend instances
- **Database**: MongoDB replica sets
- **Cache**: Redis cluster
- **Load Balancing**: Nginx or HAProxy

## 🆘 Troubleshooting

### Common Issues

1. **MongoDB Connection Failed**:
   ```bash
   # Check if MongoDB is running
   sudo systemctl status mongod
   
   # Check connection
   mongosh --eval "db.adminCommand('ping')"
   ```

2. **Redis Connection Failed**:
   ```bash
   # Check if Redis is running
   sudo systemctl status redis
   
   # Check connection
   redis-cli ping
   ```

3. **Port Already in Use**:
   ```bash
   # Find process using port
   lsof -i :5000
   
   # Kill process
   kill -9 <PID>
   ```

4. **Permission Denied**:
   ```bash
   # Make scripts executable
   chmod +x start-backend.sh
   
   # Check file permissions
   ls -la backend/
   ```

### Getting Help

1. **Check logs**:
   ```bash
   docker-compose logs -f backend
   ```

2. **Verify configuration**:
   ```bash
   python -c "from config import get_config; print(get_config())"
   ```

3. **Test database connection**:
   ```bash
   python -c "from database import init_database; init_database('mongodb://localhost:27017/aidconnect', 'aidconnect')"
   ```

## 📚 Additional Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)
- [Docker Documentation](https://docs.docker.com/)
- [Firebase Documentation](https://firebase.google.com/docs)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
