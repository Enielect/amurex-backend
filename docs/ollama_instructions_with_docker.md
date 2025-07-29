# Ollama Docker Setup

This setup provides a complete Ollama environment with Docker Compose.

## Services Included
- **Ollama**: The main Ollama service
- **Open WebUI**: Web interface for interacting with models

## Quick Start

1. **Start services:**
   ```bash
   docker-compose up -d
   ```

2. **Download models:**
   ```bash
   ./download-models.sh
   ```

3. **Access the services:**
   - Ollama API: http://localhost:11434
   - Web UI: http://localhost:3000

## Using Ollama CLI

Use the wrapper script to run Ollama commands:

```bash
# List available models
./ollama-cli.sh list

# Run a model interactively
./ollama-cli.sh run llama3.1:8b

# Show model information
./ollama-cli.sh show llama3.1:8b
```

## Direct API Usage

```bash
# Test the API
curl http://localhost:11434/api/tags

# Generate text
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1:8b",
  "prompt": "Why is the sky blue?",
  "stream": false
}'
```

## Management Commands

```bash
# View logs
docker-compose logs -f ollama

# Stop services
docker-compose down

# Remove everything (including data)
docker-compose down -v

# Update images
docker-compose pull
docker-compose up -d
```

## GPU Support (Linux/Windows with NVIDIA)

If you have an NVIDIA GPU, uncomment the GPU section in docker-compose.yml and ensure you have:
- NVIDIA Docker runtime installed
- nvidia-container-toolkit

## Troubleshooting

- **Port conflicts**: Change ports in docker-compose.yml if 11434 or 3000 are in use
- **Permission issues**: Ensure Docker daemon is running and you have permissions
- **Mac GPU**: GPU acceleration is not available on Mac through Docker