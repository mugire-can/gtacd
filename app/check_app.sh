#!/bin/bash
# Simple simulated check script for the app
echo "=== Starting application checks ==="

if [ -f "app/index.html" ]; then
  echo "OK: index.html found."
  echo "=== Checks completed successfully ==="
  exit 0
else
  echo "ERROR: index.html not found!"
  echo "=== Checks completed with failure ==="
  exit 1
fi