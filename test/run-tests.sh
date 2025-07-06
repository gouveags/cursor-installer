#!/bin/bash

# Test runner for cursor-installer
# This script provides an easy way to run tests in different environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_header() {
    echo -e "${BLUE}$1${NC}"
}

# Show usage information
show_usage() {
    cat << EOF
Cursor Installer Test Runner

Usage: $0 [OPTIONS] [COMMAND]

Commands:
  build                    Build all test containers
  test [ENVIRONMENT]       Run tests (default: all environments)
  shell [ENVIRONMENT]      Open shell in test environment
  clean                    Clean up test containers and volumes
  logs [ENVIRONMENT]       Show logs from test environment

Environments:
  ubuntu-22               Ubuntu 22.04 LTS
  ubuntu-20               Ubuntu 20.04 LTS
  debian-12               Debian 12
  all                     All environments (default)

Options:
  -h, --help              Show this help message
  -v, --verbose           Verbose output
  --no-cache              Build without cache
  --pull                  Pull latest base images

Examples:
  $0 build                # Build all test containers
  $0 test ubuntu-22       # Test on Ubuntu 22.04
  $0 shell debian-12      # Open shell in Debian 12 container
  $0 clean                # Clean up everything

EOF
}

# Check if Docker is available
check_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi

    if ! docker info >/dev/null 2>&1; then
        print_error "Docker daemon is not running or accessible"
        exit 1
    fi

    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose is not installed"
        exit 1
    fi
}

# Build test containers
build_containers() {
    local no_cache_flag=""
    local pull_flag=""

    if [[ "$USE_NO_CACHE" == "true" ]]; then
        no_cache_flag="--no-cache"
    fi

    if [[ "$PULL_IMAGES" == "true" ]]; then
        pull_flag="--pull"
    fi

    print_status "Building test containers..."

    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose build $no_cache_flag $pull_flag
    else
        docker compose build $no_cache_flag $pull_flag
    fi

    print_status "Build completed successfully!"
}

# Run tests in specific environment
run_test_environment() {
    local env="$1"

    print_header "Running tests in $env environment..."

    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose run --rm "$env" ./test-scripts/test-installation.sh
    else
        docker compose run --rm "$env" ./test-scripts/test-installation.sh
    fi
}

# Run tests in all environments
run_all_tests() {
    local environments=("ubuntu-22" "ubuntu-20" "debian-12")
    local failed_environments=()

    for env in "${environments[@]}"; do
        print_header "Testing environment: $env"
        if run_test_environment "$env"; then
            print_status "✓ Tests passed in $env"
        else
            print_error "✗ Tests failed in $env"
            failed_environments+=("$env")
        fi
        echo
    done

    # Summary
    if [ ${#failed_environments[@]} -eq 0 ]; then
        print_status "🎉 All tests passed in all environments!"
        return 0
    else
        print_error "Tests failed in environments: ${failed_environments[*]}"
        return 1
    fi
}

# Open shell in test environment
open_shell() {
    local env="$1"

    print_status "Opening shell in $env environment..."
    print_status "The project is mounted at /workspace"
    print_status "Use 'exit' to close the shell"
    echo

    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose run --rm "$env" /bin/bash
    else
        docker compose run --rm "$env" /bin/bash
    fi
}

# Clean up containers and volumes
clean_up() {
    print_status "Cleaning up test containers and volumes..."

    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose down -v --remove-orphans
        docker-compose rm -f
    else
        docker compose down -v --remove-orphans
        docker compose rm -f
    fi

    # Remove dangling images
    if docker images -f "dangling=true" -q | grep -q .; then
        print_status "Removing dangling images..."
        docker rmi $(docker images -f "dangling=true" -q) 2>/dev/null || true
    fi

    print_status "Cleanup completed!"
}

# Show logs from environment
show_logs() {
    local env="$1"

    if command -v docker-compose >/dev/null 2>&1; then
        docker-compose logs "$env"
    else
        docker compose logs "$env"
    fi
}

# Main function
main() {
    # Change to test directory
    cd "$(dirname "$0")"

    # Check Docker availability
    check_docker

    # Parse command line arguments
    local command=""
    local environment=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                set -x
                shift
                ;;
            --no-cache)
                USE_NO_CACHE="true"
                shift
                ;;
            --pull)
                PULL_IMAGES="true"
                shift
                ;;
            build|test|shell|clean|logs)
                command="$1"
                shift
                ;;
            ubuntu-22|ubuntu-20|debian-12|all)
                environment="$1"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Default command is test
    if [[ -z "$command" ]]; then
        command="test"
    fi

    # Default environment is all
    if [[ -z "$environment" ]]; then
        environment="all"
    fi

    # Execute command
    case "$command" in
        build)
            build_containers
            ;;
        test)
            if [[ "$environment" == "all" ]]; then
                run_all_tests
            else
                run_test_environment "$environment"
            fi
            ;;
        shell)
            if [[ "$environment" == "all" ]]; then
                print_error "Please specify a specific environment for shell access"
                exit 1
            fi
            open_shell "$environment"
            ;;
        clean)
            clean_up
            ;;
        logs)
            if [[ "$environment" == "all" ]]; then
                print_error "Please specify a specific environment for logs"
                exit 1
            fi
            show_logs "$environment"
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"