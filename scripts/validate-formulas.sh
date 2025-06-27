#!/bin/bash

# Homebrew Formula Validation Script
# This script validates all formulas in the Formula/ directory for syntax errors
# and common issues before they are committed to the repository.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FORMULA_DIR="Formula"
CASK_DIR="Casks"
ERRORS=0
WARNINGS=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_status "$RED" "❌ ERROR: $1"
    ((ERRORS++))
}

print_warning() {
    print_status "$YELLOW" "⚠️  WARNING: $1"
    ((WARNINGS++))
}

print_success() {
    print_status "$GREEN" "✅ $1"
}

print_info() {
    print_status "$BLUE" "ℹ️  $1"
}

# Function to validate Ruby syntax
validate_ruby_syntax() {
    local file=$1

    # Check if Ruby is available
    if ! command -v ruby >/dev/null 2>&1; then
        print_warning "Ruby not available, skipping syntax validation for $file"
        return 0
    fi

    if ! ruby -c "$file" >/dev/null 2>&1; then
        print_error "Ruby syntax error in $file"
        ruby -c "$file"
        return 1
    fi
    return 0
}

# Function to validate formula structure
validate_formula_structure() {
    local file=$1
    local basename=$(basename "$file" .rb)

    # Skip validation for template files
    if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
        print_info "Skipping structure validation for template file $file"
        return 0
    fi

    # Check if class name matches filename
    local class_name=$(grep -E "^class [A-Za-z0-9_]+ < Formula" "$file" | sed 's/class \([A-Za-z0-9_]*\) < Formula/\1/')
    local expected_class_name=$(echo "$basename" | sed 's/-\([a-z]\)/\U\1/g' | sed 's/^\([a-z]\)/\U\1/')

    if [[ "$class_name" != "$expected_class_name" ]]; then
        print_error "Class name '$class_name' doesn't match expected '$expected_class_name' for file $file"
    fi

    # Check for required fields (skip for template files)
    if ! grep -q "desc " "$file"; then
        if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
            print_info "Template file $file contains placeholder desc field"
        else
            print_error "Missing 'desc' field in $file"
        fi
    fi

    if ! grep -q "homepage " "$file"; then
        if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
            print_info "Template file $file contains placeholder homepage field"
        else
            print_error "Missing 'homepage' field in $file"
        fi
    fi

    if ! grep -q "url " "$file"; then
        if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
            print_info "Template file $file contains placeholder url field"
        else
            print_error "Missing 'url' field in $file"
        fi
    fi

    if ! grep -q "sha256 " "$file"; then
        if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
            print_info "Template file $file contains placeholder sha256 field"
        else
            print_error "Missing 'sha256' field in $file"
        fi
    fi

    if ! grep -q "license " "$file"; then
        if [[ "$basename" == "TEMPLATE" || "$basename" == "template" ]]; then
            print_info "Template file $file contains placeholder license field"
        else
            print_warning "Missing 'license' field in $file (recommended)"
        fi
    fi

    # Check for install method
    if ! grep -q "def install" "$file"; then
        print_error "Missing 'install' method in $file"
    fi

    # Check for test method
    if ! grep -q "test do" "$file"; then
        print_warning "Missing 'test' method in $file (recommended)"
    fi
}

# Function to validate URLs
validate_urls() {
    local file=$1

    # Extract URLs from the formula
    local urls=$(grep -E "(homepage|url) " "$file" | sed 's/.*"\(https\?:\/\/[^"]*\)".*/\1/')

    for url in $urls; do
        if command -v curl >/dev/null 2>&1; then
            if ! curl -s --head "$url" >/dev/null 2>&1; then
                print_warning "URL might be unreachable: $url in $file"
            fi
        else
            print_info "curl not available, skipping URL validation for $file"
            break
        fi
    done
}

# Function to check for common issues
check_common_issues() {
    local file=$1

    # Check for hardcoded paths
    if grep -q "/usr/local" "$file"; then
        print_warning "Found hardcoded /usr/local path in $file - consider using Homebrew variables"
    fi

    # Check for version in URL
    if grep -q "url.*version" "$file"; then
        print_info "Using version variable in URL for $file - good practice"
    fi

    # Check for development dependencies
    if grep -q "=> :build" "$file"; then
        print_info "Found build dependencies in $file - good practice"
    fi

    # Check for system calls without proper error handling
    if grep -q 'system "' "$file" && ! grep -q 'system ".*".*||' "$file"; then
        print_warning "Found system calls in $file - consider adding error handling"
    fi

    # Check for deprecated methods
    if grep -q "def caveats" "$file"; then
        print_warning "Found 'caveats' method in $file - consider if still necessary"
    fi
}

# Function to validate formula with brew
validate_with_brew() {
    local file=$1
    local basename=$(basename "$file" .rb)

    # Skip brew validation for template and example files
    if [[ "$basename" == "TEMPLATE" || "$basename" == "template" || "$basename" == "example-tool" ]]; then
        print_info "Skipping brew audit for template/example file $file"
        return 0
    fi

    if command -v brew >/dev/null 2>&1; then
        print_info "Validating $file with brew audit..."
        if brew audit --strict --online "$file" 2>/dev/null; then
            print_success "brew audit passed for $file"
        else
            print_error "brew audit failed for $file"
            brew audit --strict --online "$file" || true
        fi
    else
        print_warning "brew command not available, skipping brew audit"
    fi
}

# Function to validate a single formula file
validate_formula() {
    local file=$1
    print_info "Validating formula: $file"

    # Ruby syntax validation
    if validate_ruby_syntax "$file"; then
        print_success "Ruby syntax valid for $file"
    fi

    # Structure validation
    validate_formula_structure "$file"

    # URL validation
    validate_urls "$file"

    # Common issues check
    check_common_issues "$file"

    # Brew validation (if available)
    validate_with_brew "$file"

    echo ""
}

# Function to validate all formulas
validate_all_formulas() {
    print_info "Starting formula validation..."
    echo ""

    # Check if Formula directory exists
    if [[ ! -d "$FORMULA_DIR" ]]; then
        print_error "Formula directory '$FORMULA_DIR' not found"
        return 1
    fi

    # Find all .rb files in Formula directory
    local formula_files=$(find "$FORMULA_DIR" -name "*.rb" -type f)

    if [[ -z "$formula_files" ]]; then
        print_warning "No formula files found in $FORMULA_DIR"
        return 0
    fi

    # Validate each formula
    for file in $formula_files; do
        validate_formula "$file"
    done
}

# Function to validate casks (if any)
validate_casks() {
    if [[ -d "$CASK_DIR" ]]; then
        print_info "Validating casks..."
        local cask_files=$(find "$CASK_DIR" -name "*.rb" -type f)

        for file in $cask_files; do
            print_info "Validating cask: $file"
            validate_ruby_syntax "$file"
        done
    fi
}

# Function to check repository structure
validate_repo_structure() {
    print_info "Validating repository structure..."

    # Check required directories
    if [[ ! -d "$FORMULA_DIR" ]]; then
        print_error "Missing Formula directory"
    fi

    # Check for README
    if [[ ! -f "README.md" ]]; then
        print_warning "Missing README.md file"
    fi

    # Check for .gitignore
    if [[ ! -f ".gitignore" ]]; then
        print_warning "Missing .gitignore file"
    fi

    echo ""
}

# Main execution
main() {
    print_info "🍺 Homebrew Tap Formula Validator"
    print_info "================================="
    echo ""

    # Change to script directory
    cd "$(dirname "$0")/.."

    # Validate repository structure
    validate_repo_structure

    # Validate all formulas
    validate_all_formulas

    # Validate casks
    validate_casks

    # Print summary
    echo ""
    print_info "Validation Summary:"
    print_info "==================="

    if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
        print_success "All validations passed! 🎉"
        exit 0
    elif [[ $ERRORS -eq 0 ]]; then
        print_status "$YELLOW" "Validation completed with $WARNINGS warning(s) ⚠️"
        exit 0
    else
        print_error "Validation failed with $ERRORS error(s) and $WARNINGS warning(s)"
        exit 1
    fi
}

# Show help
show_help() {
    echo "Homebrew Formula Validation Script"
    echo ""
    echo "Usage: $0 [OPTIONS] [FORMULA_FILE]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help     Show this help message"
    echo "  -f, --file     Validate specific formula file"
    echo "  -q, --quiet    Suppress info messages"
    echo ""
    echo "Examples:"
    echo "  $0                           # Validate all formulas"
    echo "  $0 -f Formula/example.rb     # Validate specific formula"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -f|--file)
            if [[ -n "$2" && -f "$2" ]]; then
                validate_formula "$2"
                exit $?
            else
                print_error "File not found: $2"
                exit 1
            fi
            ;;
        -q|--quiet)
            # Redirect info messages to /dev/null
            exec 3>&1
            print_info() { :; }
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Run main function if no specific file was provided
main
