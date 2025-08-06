#!/bin/bash


echo "Setting up Ollama in Docker..."

chmod +x ollama_set_up_script.sh

./ollama_set_up_script.sh

echo "Ollama setup complete, and is currently running in Docker."

echo "You can access the Ollama API at http://localhost:11434"

echo "Setting up Supabase..."

chmod +x supabase_setup_script.sh

./supabase_setup_script.sh

echo "Supabase setup complete, and is currently running."

echo "You can access the Supabase dashboard at http://localhost:54321"