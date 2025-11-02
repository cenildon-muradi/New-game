#!/bin/bash
# Install git hooks for this repository
# Run this once after cloning: ./install-hooks.sh

echo "Installing git hooks..."

# Copy pre-commit hook
cp hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hook installed successfully!"
echo "   - version.txt will be auto-updated on every commit"
