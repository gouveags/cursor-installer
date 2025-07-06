#!/bin/bash

# Test script for cursor-installer installation
# This script tests the installation process in a Docker container

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TEST_DIR="$HOME/test-cursor-installer"
REPO_URL="https://github.com/gouveags/cursor-installer.git"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"

    print_info "Running test: $test_name"

    if eval "$test_command"; then
        print_status "✓ Test passed: $test_name"
        return 0
    else
        print_error "✗ Test failed: $test_name"
        return 1
    fi
}

# Test 1: Test curl-based installation
test_curl_installation() {
    print_info "Testing curl-based installation..."

    # Test if we can fetch the installation script
    if curl -fsSL "$REPO_URL/raw/main/boot.sh" > /tmp/test-boot.sh; then
        print_status "✓ Successfully fetched installation script"
        return 0
    else
        print_error "✗ Failed to fetch installation script"
        return 1
    fi
}

# Test 2: Test local installation from workspace
test_local_installation() {
    print_info "Testing local installation from workspace..."

    if [ -d "/workspace" ]; then
        cd /workspace
        if [ -f "boot.sh" ]; then
            print_status "✓ Found boot.sh in workspace"

            # Test if the script is executable
            if [ -x "boot.sh" ]; then
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

# Test 3: Test system dependencies
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

# Test 4: Test script syntax
test_script_syntax() {
    print_info "Testing script syntax..."

    if [ -f "/workspace/boot.sh" ]; then
        if bash -n /workspace/boot.sh; then
            print_status "✓ boot.sh syntax is valid"
        else
            print_error "✗ boot.sh syntax error"
            return 1
        fi
    fi

    if [ -f "/workspace/install.sh" ]; then
        if bash -n /workspace/install.sh; then
            print_status "✓ install.sh syntax is valid"
        else
            print_error "✗ install.sh syntax error"
            return 1
        fi
    fi

    if [ -f "/workspace/bin/cursor-installer" ]; then
        if bash -n /workspace/bin/cursor-installer; then
            print_status "✓ cursor-installer syntax is valid"
        else
            print_error "✗ cursor-installer syntax error"
            return 1
        fi
    fi

    return 0
}

# Test 5: Test directory structure
test_directory_structure() {
    echo "Testing directory structure..."

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
        if [ ! -f "$file" ]; then
            echo "ERROR: Missing essential file: $file"
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
        if [ ! -d "$dir" ]; then
            echo "ERROR: Missing essential directory: $dir"
            return 1
        fi
    done

    echo "✓ Directory structure test passed"
}

# Test 6: Test if script can run in dry-run mode
test_dry_run() {
    print_info "Testing dry-run mode..."

    if [ -f "/workspace/boot.sh" ]; then
        # Test if we can source the script without executing main
        if bash -c "source /workspace/boot.sh && echo 'Script loaded successfully'" >/dev/null 2>&1; then
            print_status "✓ Script can be sourced without errors"
            return 0
        else
            print_error "✗ Script cannot be sourced"
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
    print_info "Testing environment: $(lsb_release -d | cut -f2)"
    echo

    local tests=(
        "System Dependencies:test_system_dependencies"
        "Directory Structure:test_directory_structure"
        "Script Syntax:test_script_syntax"
        "Curl Installation:test_curl_installation"
        "Local Installation:test_local_installation"
        "Dry Run:test_dry_run"
    )

    local passed=0
    local failed=0

    for test in "${tests[@]}"; do
        local test_name="${test%:*}"
        local test_func="${test#*:}"

        if run_test "$test_name" "$test_func"; then
            ((passed++))
        else
            ((failed++))
        fi
        echo
    done

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