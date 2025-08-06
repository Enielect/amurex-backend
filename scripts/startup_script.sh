#!/bin/bash

if [ "$1" = "start" ]; then
    echo "Starting services..."
    supabase start
    docker-compose start ollama
elif [ "$1" = "stop" ]; then
    echo "Stopping services..."
    supabase stop
    docker-compose stop ollama
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi
