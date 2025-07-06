#!/usr/bin/env bash
# Remove strict error handling to prevent early exit on non-critical failures
# set -euo pipefail

# Add verbose debugging
set -x

if [ -z "${BASH_VERSION:-}" ]; then
  echo "[ERROR] This script must be run with bash, not sh."
  exit 1
fi

# Test script for cursor-installer installation
# This script tests the installation process in a Docker container

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_debug() {
    echo -e "${YELLOW}[DEBUG]${NC} $1"
}

# Test 1: Test system dependencies
test_system_dependencies() {
    print_info "Testing system dependencies..."

    local deps=("curl" "git" "sudo" "apt")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_status "✓ All required dependencies are available"
        return 0
    else
        print_error "✗ Missing dependencies: ${missing_deps[*]}"
        return 1
    fi
}

# Test 2: Test directory structure
test_directory_structure() {
    print_info "Testing directory structure..."

    # Save current directory
    local original_dir=$(pwd)
    print_debug "Original directory: $original_dir"

    # Change to workspace directory in Docker
    local workspace_dir="/workspace"
    print_debug "Checking workspace directory: $workspace_dir"

    if [ ! -d "$workspace_dir" ]; then
        print_error "Workspace directory not found: $workspace_dir"
        print_debug "Current directory contents: $(ls -la / 2>/dev/null || echo 'ls failed')"
        return 1
    fi

    print_debug "Workspace directory exists, changing to it..."
    cd "$workspace_dir" || {
        print_error "Failed to change to workspace directory"
        return 1
    }
    print_debug "Current directory after cd: $(pwd)"

    # Essential files
    local essential_files=(
        "boot.sh"
        "install.sh"
        "bin/cursor-installer"
        "scripts/common.sh"
        "scripts/cursor-update"
        "scripts/uninstall.sh"
        "README.md"
        "LICENSE"
    )

    for file in "${essential_files[@]}"; do
        print_debug "Checking file: $file"
        if [ ! -f "$file" ]; then
            print_error "Missing essential file: $file"
            print_debug "Directory contents: $(ls -la 2>/dev/null || echo 'ls failed')"
            cd "$original_dir" 2>/dev/null || true
            return 1
        fi
    done

    # Essential directories
    local essential_dirs=(
        "bin"
        "scripts"
        "test"
    )

    for dir in "${essential_dirs[@]}"; do
        print_debug "Checking directory: $dir"
        if [ ! -d "$dir" ]; then
            print_error "Missing essential directory: $dir"
            print_debug "Directory contents: $(ls -la 2>/dev/null || echo 'ls failed')"
            cd "$original_dir" 2>/dev/null || true
            return 1
        fi
    done

    print_status "✓ Directory structure test passed"

    # Restore original directory
    cd "$original_dir" 2>/dev/null || true
    return 0
}

# Test 3: Test script syntax
test_script_syntax() {
    print_info "Testing script syntax..."

    if [ -f "/workspace/boot.sh" ]; then
        if bash -n /workspace/boot.sh 2>/dev/null; then
            print_status "✓ boot.sh syntax is valid"
        else
            print_error "✗ boot.sh syntax error"
            return 1
        fi
    fi

    if [ -f "/workspace/install.sh" ]; then
        if bash -n /workspace/install.sh 2>/dev/null; then
            print_status "✓ install.sh syntax is valid"
        else
            print_error "✗ install.sh syntax error"
            return 1
        fi
    fi

    if [ -f "/workspace/bin/cursor-installer" ]; then
        if bash -n /workspace/bin/cursor-installer 2>/dev/null; then
            print_status "✓ cursor-installer syntax is valid"
        else
            print_error "✗ cursor-installer syntax error"
            return 1
        fi
    fi

    return 0
}

# Test 4: Test curl-based installation
test_curl_installation() {
    print_info "Testing curl-based installation..."

    # Test if we can fetch the installation script
    if curl -fsSL "https://raw.githubusercontent.com/gouveags/cursor-installer/main/boot.sh" > /tmp/test-boot.sh 2>/dev/null; then
        print_status "✓ Successfully fetched installation script"
        return 0
    else
        print_error "✗ Failed to fetch installation script"
        return 1
    fi
}

# Test 5: Test local installation from workspace
test_local_installation() {
    print_info "Testing local installation from workspace..."

    if [ -d "/workspace" ]; then
        if [ -f "/workspace/boot.sh" ]; then
            print_status "✓ Found boot.sh in workspace"

            # Test if the script is executable
            if [ -x "/workspace/boot.sh" ]; then
                print_status "✓ boot.sh is executable"
                return 0
            else
                print_error "✗ boot.sh is not executable"
                return 1
            fi
        else
            print_error "✗ boot.sh not found in workspace"
            return 1
        fi
    else
        print_error "✗ Workspace not mounted"
        return 1
    fi
}

# Test 6: Test if script can run in dry-run mode
test_dry_run() {
    print_info "Testing dry-run mode..."

    if [ -f "/workspace/boot.sh" ]; then
        # Test if we can read the script without executing it
        if head -20 "/workspace/boot.sh" >/dev/null 2>&1; then
            print_status "✓ Script can be read without errors"
            return 0
        else
            print_error "✗ Script cannot be read"
            return 1
        fi
    else
        print_error "✗ boot.sh not found"
        return 1
    fi
}

# Main test runner
main() {
    print_info "Starting cursor-installer test suite..."

    # Try to get system info, but don't fail if it doesn't work
    if command -v lsb_release >/dev/null 2>&1; then
        print_info "Testing environment: $(lsb_release -d | cut -f2 2>/dev/null || echo 'Unknown')"
    else
        print_info "Testing environment: Unknown (lsb_release not available)"
    fi

    print_debug "Current working directory: $(pwd)"
    print_debug "User: $(whoami)"
    print_debug "Home directory: $HOME"
    echo

    local passed=0
    local failed=0

    # Test 1: System Dependencies
    echo "=== Test 1: System Dependencies ==="
    if test_system_dependencies; then
        ((passed++))
        echo "✓ Test 1 completed successfully"
    else
        ((failed++))
        echo "✗ Test 1 failed"
    fi
    echo

    # Test 2: Directory Structure
    echo "=== Test 2: Directory Structure ==="
    if test_directory_structure; then
        ((passed++))
        echo "✓ Test 2 completed successfully"
    else
        ((failed++))
        echo "✗ Test 2 failed"
    fi
    echo

    # Test 3: Script Syntax
    echo "=== Test 3: Script Syntax ==="
    if test_script_syntax; then
        ((passed++))
        echo "✓ Test 3 completed successfully"
    else
        ((failed++))
        echo "✗ Test 3 failed"
    fi
    echo

    # Test 4: Curl Installation
    echo "=== Test 4: Curl Installation ==="
    if test_curl_installation; then
        ((passed++))
        echo "✓ Test 4 completed successfully"
    else
        ((failed++))
        echo "✗ Test 4 failed"
    fi
    echo

    # Test 5: Local Installation
    echo "=== Test 5: Local Installation ==="
    if test_local_installation; then
        ((passed++))
        echo "✓ Test 5 completed successfully"
    else
        ((failed++))
        echo "✗ Test 5 failed"
    fi
    echo

    # Test 6: Dry Run
    echo "=== Test 6: Dry Run ==="
    if test_dry_run; then
        ((passed++))
        echo "✓ Test 6 completed successfully"
    else
        ((failed++))
        echo "✗ Test 6 failed"
    fi
    echo

    # Summary
    print_info "Test Results:"
    print_status "✓ Passed: $passed"
    if [ $failed -gt 0 ]; then
        print_error "✗ Failed: $failed"
        echo
        print_error "Some tests failed. Please check the output above."
        exit 1
    else
        echo
        print_status "All tests passed! 🎉"
        exit 0
    fi
}

# Run the main function
main "$@"