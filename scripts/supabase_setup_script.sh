#!/bin/bash

set -e

echo "Detecting OS..."

OS=$(uname -s)
ARCH=$(uname -m)

echo "OS Detected: $OS ($ARCH)"

install_supabase_cli() {

  if command -v supabase &> /dev/null; then
    echo "Supabase CLI already installed: $(supabase --version)"
    return
  fi

  echo " Installing Supabase CLI..."
  case "$OS" in
    Linux)
      curl -sL https://github.com/supabase/cli/releases/latest/download/supabase-cli-linux-x64.tar.gz | tar -xz
      sudo mv supabase /usr/local/bin/
      ;;
    Darwin)
      if command -v brew &> /dev/null; then
        brew install supabase/tap/supabase
      else
        npm install supabase --save-dev
      fi
      ;;
    *)
     npm install supabase --save-dev
      ;;
  esac
}

setup_supabase_project() {
  echo "Setting up Supabase project..."

  if [ -d "./supabase" ]; then
    echo "Supabase project already initialized."
  elif command -v supabase &> /dev/null; then
    echo "Running: supabase init"
    supabase init
  elif command -v npx supabase init &> /dev/null; then
    echo "Running npx supabase init"
    npx supabase init
  else
    echo "Supabase CLI not found. Please install it first."
    exit 1
  fi

  if command -v supabase start &> /dev/null; then
    echo "Starting Supabase..."
    supabase start
  elif command -v npx supabase start &> /dev/null; then
    echo "Starting Supabase..."
    npx supabase start
  fi
}

# I should probably use pnpm for the solution to windows guys.

# Main execution
install_supabase_cli
setup_supabase_project
