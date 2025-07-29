#!/bin/bash

# This script sets up Ollama with Docker Compose and downloads llama3.1:8b

set -e  # Exit on any error

echo "Starting Ollama Docker Setup..."

echo "Checking system requirements..."

# Check available RAM (at least 10GB recommended for llama3.1:8b)
if command -v free &> /dev/null; then
    # Linux
    TOTAL_RAM_KB=$(free | grep '^Mem:' | awk '{print $2}')
    TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac
    TOTAL_RAM_BYTES=$(sysctl -n hw.memsize)
    TOTAL_RAM_GB=$((TOTAL_RAM_BYTES / 1024 / 1024 / 1024))
else
    # Windows - try different methods
    if command -v wmic &> /dev/null; then
        # Windows with wmic (Command Prompt/PowerShell available)
        TOTAL_RAM_BYTES=$(wmic computersystem get TotalPhysicalMemory /value | grep -o '[0-9]*' | head -1)
        TOTAL_RAM_GB=$((TOTAL_RAM_BYTES / 1024 / 1024 / 1024))
    elif command -v powershell.exe &> /dev/null; then
        # WSL or Git Bash with PowerShell access
        TOTAL_RAM_BYTES=$(powershell.exe -Command "(Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory" | tr -d '\r')
        TOTAL_RAM_GB=$((TOTAL_RAM_BYTES / 1024 / 1024 / 1024))
    else
        # Fallback - cannot detect
        TOTAL_RAM_GB=8
        echo "  Cannot detect RAM on this system - assuming 8GB minimum"
    fi
fi

if [ $TOTAL_RAM_GB -lt 10 ]; then
    echo "  WARNING: You have ${TOTAL_RAM_GB}GB RAM. llama3.1:8b needs ~8GB+ RAM to run properly."
    echo "    Consider using a smaller model like llama3.1:1b or phi3:mini"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 1
    fi
fi

# Check available disk space (at least 8GB for llama3.1:8b model)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac
    AVAILABLE_SPACE_KB=$(df . | tail -1 | awk '{print $4}')
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    AVAILABLE_SPACE_KB=$(df . | tail -1 | awk '{print $4}')
else
    # Windows/Git Bash - use PowerShell if available
    if command -v powershell.exe &> /dev/null; then
        AVAILABLE_SPACE_BYTES=$(powershell.exe -Command "(Get-PSDrive C).Free" | tr -d '\r')
        AVAILABLE_SPACE_KB=$((AVAILABLE_SPACE_BYTES / 1024))
    else
        echo "Cannot detect disk space on this system"
        exit 1
    fi
fi
AVAILABLE_SPACE_GB=$((AVAILABLE_SPACE_KB / 1024 / 1024))


echo " System requirements check passed (RAM: ${TOTAL_RAM_GB}GB, Disk: ${AVAILABLE_SPACE_GB}GB)"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

#Detect operating system
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Windows;;
    MINGW*)     MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "Detected OS: $MACHINE"


# Create docker-compose.yml file

# Create .env file for environment variables

# Create model download script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$SCRIPT_DIR/../ollama-docker-setup/download-models.sh"

# Create utility scripts

chmod +x "$SCRIPT_DIR/../ollama-docker-setup/ollama-cli.sh"

# Create README (for running ollama in a docker container)



# Start the services
echo "Starting Docker services..."
docker-compose up -d

echo "Waiting for services to start..."
sleep 10

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo "Services are running!"
    
    # Prompt to download model
    read -p "Would you like to download the llama3.1:8b model now? This may take several minutes. (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./download-models.sh
    else
        echo "You can download the model later by running: ./download-models.sh"
    fi
    
    echo ""
    echo "Setup complete!"
    echo "Access points:"
    echo "   - Ollama API: http://localhost:11434"
    echo ""
    echo "Next steps:"
    echo "   - Use './ollama-cli.sh run llama3.1:8b' to chat with the model"
    echo "   - Check README.md for more information"
else
    echo "Something went wrong. Check the logs with: docker-compose logs"
fi