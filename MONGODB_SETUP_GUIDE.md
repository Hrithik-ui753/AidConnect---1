# MongoDB Setup Guide for AidConnect

This guide will help you set up MongoDB with real credentials and connect it to your AidConnect backend.

## 🚀 Quick Setup Options

### Option 1: MongoDB Atlas (Cloud - Recommended)

MongoDB Atlas is the easiest way to get started with a real MongoDB database.

#### Step 1: Create MongoDB Atlas Account
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Click "Try Free" and create an account
3. Choose the free tier (M0 Sandbox)

#### Step 2: Create a Cluster
1. Click "Build a Database"
2. Choose "FREE" tier
3. Select a cloud provider (AWS, Google Cloud, or Azure)
4. Choose a region close to you
5. Click "Create Cluster"

#### Step 3: Create Database User
1. Go to "Database Access" in the left sidebar
2. Click "Add New Database User"
3. Choose "Password" authentication
4. Create a username and password (save these!)
5. Set privileges to "Read and write to any database"
6. Click "Add User"

#### Step 4: Whitelist Your IP
1. Go to "Network Access" in the left sidebar
2. Click "Add IP Address"
3. Click "Allow Access from Anywhere" (0.0.0.0/0) for development
4. Click "Confirm"

#### Step 5: Get Connection String
1. Go to "Clusters" in the left sidebar
2. Click "Connect" on your cluster
3. Choose "Connect your application"
4. Select "Python" and version "3.6 or later"
5. Copy the connection string

Your connection string will look like:
```
mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/?retryWrites=true&w=majority
```

### Option 2: Local MongoDB Installation

#### Windows
1. Download MongoDB Community Server from [mongodb.com](https://www.mongodb.com/try/download/community)
2. Install with default settings
3. MongoDB will start automatically as a Windows service

#### macOS
```bash
# Using Homebrew
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb/brew/mongodb-community
```

#### Linux (Ubuntu/Debian)
```bash
# Import MongoDB public key
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -

# Create list file
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
```

## 🔧 Configuration Setup

### Step 1: Create Environment File

Create a `.env` file in the `backend` directory:

```bash
# For MongoDB Atlas (Cloud)
MONGO_URI=mongodb+srv://your_username:your_password@cluster0.xxxxx.mongodb.net/aidconnect?retryWrites=true&w=majority
MONGO_DB_NAME=aidconnect

# For Local MongoDB
# MONGO_URI=mongodb://localhost:27017/aidconnect
# MONGO_DB_NAME=aidconnect

# Other required settings
FLASK_ENV=development
SECRET_KEY=your-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key-here
REDIS_URL=redis://localhost:6379/0
CORS_ORIGINS=http://localhost:3000,http://localhost:5173
```

### Step 2: Update Docker Compose (if using Docker)

Edit `docker-compose.yml`:

```yaml
services:
  backend:
    environment:
      - MONGO_URI=mongodb+srv://your_username:your_password@cluster0.xxxxx.mongodb.net/aidconnect?retryWrites=true&w=majority
      - MONGO_DB_NAME=aidconnect
      # ... other environment variables
```

### Step 3: Test Connection

Create a test script to verify your connection:

```python
# test_mongodb_connection.py
import os
from pymongo import MongoClient
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_mongodb_connection():
    try:
        # Get connection string from environment
        mongo_uri = os.getenv('MONGO_URI', 'mongodb://localhost:27017/aidconnect')
        
        print(f"Connecting to: {mongo_uri.replace(mongo_uri.split('@')[0].split('//')[1], '***:***')}")
        
        # Create client
        client = MongoClient(mongo_uri, serverSelectionTimeoutMS=5000)
        
        # Test connection
        client.admin.command('ping')
        print("✅ MongoDB connection successful!")
        
        # Test database access
        db = client['aidconnect']
        collections = db.list_collection_names()
        print(f"✅ Database 'aidconnect' accessible")
        print(f"Collections: {collections}")
        
        return True
        
    except Exception as e:
        print(f"❌ MongoDB connection failed: {e}")
        return False

if __name__ == "__main__":
    test_mongodb_connection()
```

## 🔐 Security Best Practices

### 1. Environment Variables
Never hardcode credentials in your code. Always use environment variables:

```python
# ❌ Bad - hardcoded credentials
MONGO_URI = "mongodb+srv://user:password@cluster.mongodb.net/db"

# ✅ Good - environment variables
MONGO_URI = os.getenv('MONGO_URI')
```

### 2. MongoDB Atlas Security
- Use strong passwords
- Enable IP whitelisting
- Use database users with minimal privileges
- Enable encryption in transit
- Regular security updates

### 3. Local MongoDB Security
```bash
# Create admin user
mongosh
use admin
db.createUser({
  user: "admin",
  pwd: "strong_password",
  roles: ["userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"]
})

# Create application user
use aidconnect
db.createUser({
  user: "aidconnect_user",
  pwd: "app_password",
  roles: ["readWrite"]
})
```

## 🐳 Docker Setup with Real MongoDB

### Option 1: Use MongoDB Atlas with Docker
```yaml
# docker-compose.yml
version: '3.8'
services:
  backend:
    build: ./backend
    environment:
      - MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/aidconnect
      - MONGO_DB_NAME=aidconnect
    ports:
      - "5000:5000"
```

### Option 2: Local MongoDB in Docker
```yaml
# docker-compose.yml
version: '3.8'
services:
  mongodb:
    image: mongo:7.0
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin_password
      MONGO_INITDB_DATABASE: aidconnect
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
      - ./backend/scripts/mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro

  backend:
    build: ./backend
    environment:
      - MONGO_URI=mongodb://admin:admin_password@mongodb:27017/aidconnect?authSource=admin
      - MONGO_DB_NAME=aidconnect
    depends_on:
      - mongodb
    ports:
      - "5000:5000"

volumes:
  mongodb_data:
```

## 🧪 Testing Your Setup

### 1. Test Connection
```bash
cd AidConnect/backend
python test_mongodb_connection.py
```

### 2. Test Backend Setup
```bash
cd AidConnect/backend
python test_setup.py
```

### 3. Test API Endpoints
```bash
# Start backend
python run.py

# Test health endpoint
curl http://localhost:5000/health

# Test database connection
curl http://localhost:5000/api/health/database
```

## 🔍 Troubleshooting

### Common Issues

#### 1. Connection Timeout
```
Error: ServerSelectionTimeoutError
```
**Solution**: Check your internet connection and MongoDB Atlas cluster status.

#### 2. Authentication Failed
```
Error: Authentication failed
```
**Solution**: Verify username and password in connection string.

#### 3. IP Not Whitelisted
```
Error: IP not in whitelist
```
**Solution**: Add your IP address to MongoDB Atlas Network Access.

#### 4. SSL/TLS Issues
```
Error: SSL handshake failed
```
**Solution**: Ensure your connection string includes SSL parameters.

### Debug Connection String

```python
# debug_connection.py
import os
from pymongo import MongoClient
from urllib.parse import quote_plus

def debug_connection():
    username = "your_username"
    password = "your_password"
    cluster = "cluster0.xxxxx.mongodb.net"
    database = "aidconnect"
    
    # Properly encode credentials
    encoded_username = quote_plus(username)
    encoded_password = quote_plus(password)
    
    connection_string = f"mongodb+srv://{encoded_username}:{encoded_password}@{cluster}/{database}?retryWrites=true&w=majority"
    
    print(f"Connection string: {connection_string}")
    
    try:
        client = MongoClient(connection_string, serverSelectionTimeoutMS=5000)
        client.admin.command('ping')
        print("✅ Connection successful!")
    except Exception as e:
        print(f"❌ Connection failed: {e}")

if __name__ == "__main__":
    debug_connection()
```

## 📊 Monitoring Your Database

### MongoDB Atlas Monitoring
- Go to your cluster dashboard
- Check "Metrics" tab for performance
- Monitor "Alerts" for issues
- Use "Logs" for debugging

### Local MongoDB Monitoring
```bash
# Check MongoDB status
sudo systemctl status mongod

# View MongoDB logs
sudo tail -f /var/log/mongodb/mongod.log

# Connect to MongoDB shell
mongosh
```

## 🚀 Production Deployment

### Environment Variables for Production
```bash
# Production .env
MONGO_URI=mongodb+srv://prod_user:strong_password@prod-cluster.mongodb.net/aidconnect?retryWrites=true&w=majority
MONGO_DB_NAME=aidconnect
FLASK_ENV=production
SECRET_KEY=very-strong-secret-key
JWT_SECRET_KEY=very-strong-jwt-secret
```

### Security Checklist
- [ ] Strong passwords for all users
- [ ] IP whitelisting configured
- [ ] SSL/TLS encryption enabled
- [ ] Regular backups scheduled
- [ ] Monitoring and alerts set up
- [ ] Environment variables secured
- [ ] Database users with minimal privileges

## 📞 Getting Help

### MongoDB Atlas Support
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [MongoDB Community Forums](https://community.mongodb.com/)
- [MongoDB Support](https://support.mongodb.com/)

### Local MongoDB Support
- [MongoDB Manual](https://docs.mongodb.com/manual/)
- [MongoDB University](https://university.mongodb.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/mongodb)

## 🎯 Next Steps

1. **Choose your MongoDB setup** (Atlas recommended)
2. **Create your database and user**
3. **Update your .env file** with connection string
4. **Test the connection** with provided scripts
5. **Start your backend** and verify everything works
6. **Set up monitoring** and alerts

Your AidConnect backend will now be connected to a real MongoDB database! 🎉
