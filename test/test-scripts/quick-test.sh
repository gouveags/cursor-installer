#!/usr/bin/env bash

echo "=== Quick Test Script ==="
echo "This script tests basic functionality without running the full test suite"
echo

# Test 1: Check if we're in the right environment
echo "Test 1: Environment check"
echo "Current directory: $(pwd)"
echo "User: $(whoami)"
echo "Home: $HOME"
echo "BASH_VERSION: $BASH_VERSION"
echo

# Test 2: Check if /workspace is mounted
echo "Test 2: Workspace mounting"
if [ -d "/workspace" ]; then
    echo "✓ /workspace directory exists"
    echo "Workspace contents:"
    ls -la /workspace | head -5
else
    echo "✗ /workspace directory not found"
    echo "This might indicate a Docker volume mounting issue"
fi
echo

# Test 3: Check essential files
echo "Test 3: Essential files"
if [ -f "/workspace/boot.sh" ]; then
    echo "✓ boot.sh exists"
else
    echo "✗ boot.sh missing"
fi

if [ -f "/workspace/install.sh" ]; then
    echo "✓ install.sh exists"
else
    echo "✗ install.sh missing"
fi

if [ -f "/workspace/bin/cursor-installer" ]; then
    echo "✓ cursor-installer exists"
else
    echo "✗ cursor-installer missing"
fi
echo

# Test 4: Check system dependencies
echo "Test 4: System dependencies"
deps=("curl" "git" "sudo" "apt")
for dep in "${deps[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "✓ $dep available"
    else
        echo "✗ $dep missing"
    fi
done
echo

# Test 5: Check if we can execute the main test script
echo "Test 5: Test script accessibility"
if [ -f "/home/testuser/test-scripts/test-installation.sh" ]; then
    echo "✓ test-installation.sh exists in home directory"
    if [ -x "/home/testuser/test-scripts/test-installation.sh" ]; then
        echo "✓ test-installation.sh is executable"
    else
        echo "✗ test-installation.sh is not executable"
    fi
else
    echo "✗ test-installation.sh not found in home directory"
fi
echo

echo "=== Quick test completed ==="
echo "If all tests show ✓, the environment should be ready for the full test suite."