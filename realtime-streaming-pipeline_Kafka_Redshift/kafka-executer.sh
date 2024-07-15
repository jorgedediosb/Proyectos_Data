#! /bin/bash

# Create or clean the 'run_logs' directory
if [-d "run_logs"]; then
    rm -r run_logs/*
else
    mkdir run_logs
fi

# Stop containers
docker-compose down > run_logs/docker-compose-down.log 2>&1

# Wait for the containers to stop
sleep 10

# Start containers
docker-compose up -d > run_logs/docker-compose-up.log 2>&1

# Wait for Kafka Connect to start
sleep 45

# Star the subscriber and redirect output to a file
python3 subscriber.py > run_logs/subscriber.log 2>&1

# Wait for subscriber to start and then start publisher
sleep 10
python3 publisher.py > run_logs/publisher.log 2>&1

# Print the current topics output
sleep 15
kcat -C -b localhost:9092 -t client -o begining -e -K, > run_logs/kcat.log 2>&1