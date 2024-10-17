#!/bin/bash

set -e  

# Define variables
NETWORK_NAME="data-modeling-network"
CONTAINER_NAME="data-modeling"  
IMAGE_NAME="your-docker-image:latest"  

# Create the network if it doesn't exist
docker network inspect "$NETWORK_NAME" >/dev/null 2>&1 || docker network create "$NETWORK_NAME"

# Build the Docker image (if using a local Dockerfile)
docker build -t "$IMAGE_NAME" .

# Remove the existing container if it exists
docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

# Run the container
docker run -d \
  --name "$CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -p 8080:8080 \  
  -v "$(pwd)/../secrets:/secrets" \  
  -e GOOGLE_APPLICATION_CREDENTIALS="/secrets/model-containerization.json" \  
  -e GCP_PROJECT="ac215-privasee" \ 
  -e GCP_ZONE="us-central1-a" \  
  "$IMAGE_NAME"