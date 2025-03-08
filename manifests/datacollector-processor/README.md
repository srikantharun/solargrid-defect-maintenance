# Solar Panel Data Collection and Analytics

This document provides an overview of the data collection and analytics component of the Solar Panel Defect Detection system.

## Overview

The Data Collection and Processing module collects, aggregates, and persists all sensor data from the solar panel farm. It serves as the central data repository and provides APIs for accessing both real-time and historical data.

## Architecture

The data processing pipeline consists of several interconnected components:

1. **Data Collection API**: RESTful endpoints to receive sensor data
2. **Short-term Storage**: Redis for caching recent readings and fast lookups
3. **Long-term Storage**: MongoDB for persistent storage and historical analysis
4. **Optional Stream Processing**: Kafka support for real-time data processing

## Supported Sensor Types

The system collects data from multiple sensor types:

- **Irradiance Sensors**: Measure light intensity (W/m²)
- **Temperature Sensors**: Monitor panel temperature (°C)
- **Humidity Sensors**: Track environmental moisture (%)
- **Wind Speed Sensors**: Measure air velocity (m/s)
- **Thermal Imaging Sensors**: Capture temperature distribution across panels

## Data Storage Structure

### MongoDB Schema

Sensor data is stored in MongoDB with the following structure:

```json
{
  "sensor_id": "string",
  "sensor_type": "string",
  "location_code": "string",
  "panel_id": "string (optional)",
  "timestamp": "ISO date string",
  "value": "number (for simple sensors)",
  "unit": "string",
  "metadata": {
    "sensor-specific metadata"
  },
  "thermal_data": {
    "min_temperature": "number",
    "max_temperature": "number",
    "avg_temperature": "number",
    "temperature_difference": "number"
  },
  "defect_detected": "boolean (for thermal sensors)",
  "defect_info": {
    "type": "string",
    "location": "object",
    "severity": "string"
  }
}
```

### Redis Data Structure

For fast access, Redis stores:

- Latest readings by sensor ID
- Detected defects by panel ID
- Recent defect history

## API Endpoints

The Data Collector exposes several RESTful endpoints:

### Data Ingestion
- `POST /sensor-data`: Submit new sensor data

### Data Retrieval
- `GET /latest/{sensor_type}`: Get the latest readings for a specific sensor type
- `GET /latest/location/{location_code}`: Get the latest data for a specific location
- `GET /panel/{panel_id}`: Get all sensor data for a specific panel
- `GET /defects/recent`: Get recently detected defects
- `GET /history/{sensor_type}/{sensor_id}`: Get historical data for a specific sensor

## Data Retention

The system implements a data retention policy to manage storage requirements:

- MongoDB data is automatically purged after a configurable retention period (default: 30 days)
- Redis data expires after 24 hours
- Raw thermal images are stored only temporarily

## Integration Points

The Data Collector integrates with:

- Sensor pods (data sources)
- Microcontroller Interface (for physical hardware)
- AI Processor (for data analysis)
- API Server (for external access)

## Performance Considerations

- Multi-threaded processing for high throughput
- Indexed database collections for efficient queries
- Caching layer for frequent access patterns
- Background data cleanup for storage management

## Monitoring

The Data Collector's performance can be monitored through:

- Request rates and processing times
- Storage utilization
- Data throughput
- Query performance

## Implementation Details

The Data Collector is implemented using:

- Flask for the RESTful API
- PyMongo for MongoDB interaction
- Redis-py for Redis interaction
- Kafka-python for optional stream processing
