# MongoDB Compass Setup for AidConnect

This guide will help you set up MongoDB Compass to work with the AidConnect application.

## Installation

1. Download MongoDB Compass from the [official website](https://www.mongodb.com/try/download/compass)
2. Install MongoDB Compass following the installation wizard instructions

## Connection Setup

1. Open MongoDB Compass
2. Use the following connection string:
   ```
   mongodb://localhost:27017/aidconnect
   ```
3. Click "Connect"

## Database Structure

AidConnect uses the following collections:

- `users` - User accounts and profiles
- `campaigns` - Aid campaigns information
- `donations` - Donation records
- `hotspots` - Disaster hotspot locations
- `deliveries` - Aid delivery tracking
- `beneficiaries` - Beneficiary verification data
- `hotspotPredictions` - ML predictions for disaster hotspots

## Development Configuration

For local development:

1. Ensure MongoDB is running locally:
   ```
   mongod --dbpath=/data/db
   ```

2. The application will automatically connect to the local MongoDB instance

## Production Configuration

For production deployment:

1. Update the MongoDB connection string in your environment variables:
   ```
   MONGODB_URI=mongodb+srv://<username>:<password>@<cluster>.mongodb.net/aidconnect
   ```

2. Ensure proper authentication and network security settings are configured

## Data Import/Export

To import sample data for development:

1. Use the "Import Data" feature in MongoDB Compass
2. Navigate to the sample data files in the `scripts/sample_data` directory
3. Select the appropriate collection for each data file

## Troubleshooting

If you encounter connection issues:

1. Verify MongoDB is running
2. Check firewall settings
3. Ensure correct credentials are being used
4. Verify network connectivity to the database server

For additional help, refer to the [MongoDB Compass documentation](https://docs.mongodb.com/compass/current/).