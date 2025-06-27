#!/bin/bash

# New Formula Generator Script
# This script helps create new Homebrew formulas from the template

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_status "$RED" "❌ ERROR: $1"
}

print_success() {
    print_status "$GREEN" "✅ $1"
}

print_info() {
    print_status "$BLUE" "ℹ️  $1"
}

print_warning() {
    print_status "$YELLOW" "⚠️  $1"
}

# Function to show help
show_help() {
    echo "New Formula Generator for Homebrew Tap"
    echo ""
    echo "Usage: $0 [OPTIONS] FORMULA_NAME"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help           Show this help message"
    echo "  -u, --url URL        Source URL for the project"
    echo "  -d, --desc DESC      Description of the tool"
    echo "  -l, --license LIC    License (e.g., MIT, Apache-2.0)"
    echo "  --homepage URL       Homepage URL"
    echo "  --interactive        Interactive mode (prompts for all values)"
    echo ""
    echo "Examples:"
    echo "  $0 my-awesome-tool"
    echo "  $0 --interactive my-tool"
    echo "  $0 -u https://github.com/user/repo/archive/v1.0.0.tar.gz my-tool"
    echo ""
}

# Function to convert kebab-case to CamelCase
kebab_to_camel() {
    local input="$1"
    echo "$input" | sed 's/-\([a-z]\)/\U\1/g' | sed 's/^\([a-z]\)/\U\1/'
}

# Function to validate formula name
validate_formula_name() {
    local name="$1"

    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        print_error "Formula name must contain only lowercase letters, numbers, and hyphens"
        return 1
    fi

    if [[ "$name" =~ ^- ]] || [[ "$name" =~ -$ ]]; then
        print_error "Formula name cannot start or end with a hyphen"
        return 1
    fi

    if [[ ${#name} -lt 2 ]]; then
        print_error "Formula name must be at least 2 characters long"
        return 1
    fi

    return 0
}

# Function to prompt for user input
prompt_input() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    if [[ -n "$default" ]]; then
        read -p "$prompt [$default]: " value
        value="${value:-$default}"
    else
        read -p "$prompt: " value
    fi

    eval "$var_name='$value'"
}

# Function to calculate SHA256 from URL
calculate_sha256() {
    local url="$1"
    local temp_file=$(mktemp)

    print_info "Downloading source to calculate SHA256..."

    if command -v curl >/dev/null 2>&1; then
        if curl -L -o "$temp_file" "$url" 2>/dev/null; then
            local sha256=$(shasum -a 256 "$temp_file" | cut -d' ' -f1)
            rm -f "$temp_file"
            echo "$sha256"
            return 0
        fi
    elif command -v wget >/dev/null 2>&1; then
        if wget -O "$temp_file" "$url" 2>/dev/null; then
            local sha256=$(shasum -a 256 "$temp_file" | cut -d' ' -f1)
            rm -f "$temp_file"
            echo "$sha256"
            return 0
        fi
    fi

    rm -f "$temp_file"
    print_warning "Could not download source file to calculate SHA256"
    echo "TEMPLATE_SHA256_CHECKSUM"
}

# Function to detect project type from URL
detect_project_type() {
    local url="$1"
    local homepage="$2"

    # Check URL patterns
    if [[ "$url" =~ \.go$ ]] || [[ "$homepage" =~ golang ]] || [[ "$url" =~ /go/ ]]; then
        echo "go"
    elif [[ "$url" =~ \.py$ ]] || [[ "$homepage" =~ python ]] || [[ "$url" =~ /python/ ]]; then
        echo "python"
    elif [[ "$url" =~ \.js$ ]] || [[ "$homepage" =~ nodejs ]] || [[ "$url" =~ /node/ ]]; then
        echo "node"
    elif [[ "$url" =~ \.rs$ ]] || [[ "$homepage" =~ rust ]] || [[ "$url" =~ /rust/ ]]; then
        echo "rust"
    else
        echo "generic"
    fi
}

# Function to generate install method based on project type
generate_install_method() {
    local project_type="$1"

    case "$project_type" in
        "go")
            echo '    system "go", "build", *std_go_args(ldflags: "-s -w")'
            ;;
        "python")
            echo '    virtualenv_install_with_resources'
            ;;
        "node")
            echo '    system "npm", "install", *Language::Node.std_npm_install_args(libexec)'
            echo '    bin.install_symlink Dir["#{libexec}/bin/*"]'
            ;;
        "rust")
            echo '    system "cargo", "install", *std_cargo_args'
            ;;
        *)
            echo '    # Add your installation steps here'
            echo '    # bin.install "your-binary-name"'
            ;;
    esac
}

# Function to generate dependencies based on project type
generate_dependencies() {
    local project_type="$1"

    case "$project_type" in
        "go")
            echo '  depends_on "go" => :build'
            ;;
        "python")
            echo '  include Language::Python::Virtualenv'
            echo ''
            echo '  depends_on "python@3.11"'
            ;;
        "node")
            echo '  depends_on "node" => :build'
            ;;
        "rust")
            echo '  depends_on "rust" => :build'
            ;;
        *)
            echo '  # depends_on "dependency-name"'
            ;;
    esac
}

# Function to create the formula file
create_formula() {
    local formula_name="$1"
    local class_name="$2"
    local description="$3"
    local homepage="$4"
    local url="$5"
    local license="$6"
    local sha256="$7"
    local project_type="$8"

    local formula_file="Formula/${formula_name}.rb"

    # Check if file already exists
    if [[ -f "$formula_file" ]]; then
        print_error "Formula file $formula_file already exists"
        return 1
    fi

    # Extract version from URL if possible
    local version=$(echo "$url" | grep -oE 'v?[0-9]+\.[0-9]+(\.[0-9]+)?' | tail -1)

    cat > "$formula_file" << EOF
class $class_name < Formula$(if [[ "$project_type" == "python" ]]; then echo ""; echo "  include Language::Python::Virtualenv"; echo ""; fi)
  desc "$description"
  homepage "$homepage"
  url "$url"
  sha256 "$sha256"
  license "$license"

$(generate_dependencies "$project_type")

  def install
$(generate_install_method "$project_type")
  end

  test do
    # Test that the binary was installed and is executable
    assert_predicate bin/"$formula_name", :exist?
    assert_predicate bin/"$formula_name", :executable?

    # Test version output
    assert_match "$formula_name", shell_output("#{bin}/$formula_name --version")

    # Test help command
    assert_match "Usage:", shell_output("#{bin}/$formula_name --help")
  end
end
EOF

    print_success "Created formula file: $formula_file"
}

# Main function
main() {
    local formula_name=""
    local url=""
    local description=""
    local license=""
    local homepage=""
    local interactive=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -u|--url)
                url="$2"
                shift 2
                ;;
            -d|--desc)
                description="$2"
                shift 2
                ;;
            -l|--license)
                license="$2"
                shift 2
                ;;
            --homepage)
                homepage="$2"
                shift 2
                ;;
            --interactive)
                interactive=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$formula_name" ]]; then
                    formula_name="$1"
                else
                    print_error "Multiple formula names provided"
                    exit 1
                fi
                shift
                ;;
        esac
    done

    # Check if formula name was provided
    if [[ -z "$formula_name" ]]; then
        print_error "Formula name is required"
        show_help
        exit 1
    fi

    # Validate formula name
    if ! validate_formula_name "$formula_name"; then
        exit 1
    fi

    # Convert formula name to class name
    local class_name=$(kebab_to_camel "$formula_name")

    print_info "Creating new formula: $formula_name (class: $class_name)"

    # Interactive mode or fill in missing values
    if [[ "$interactive" == true ]] || [[ -z "$description" ]]; then
        prompt_input "Description" "$description" description
    fi

    if [[ "$interactive" == true ]] || [[ -z "$homepage" ]]; then
        prompt_input "Homepage URL" "$homepage" homepage
    fi

    if [[ "$interactive" == true ]] || [[ -z "$url" ]]; then
        prompt_input "Source URL" "$url" url
    fi

    if [[ "$interactive" == true ]] || [[ -z "$license" ]]; then
        prompt_input "License" "${license:-MIT}" license
    fi

    # Validate required fields
    if [[ -z "$description" ]] || [[ -z "$homepage" ]] || [[ -z "$url" ]]; then
        print_error "Description, homepage, and URL are required"
        exit 1
    fi

    # Calculate SHA256 if URL is provided
    local sha256=$(calculate_sha256 "$url")

    # Detect project type
    local project_type=$(detect_project_type "$url" "$homepage")
    print_info "Detected project type: $project_type"

    # Create the formula
    if create_formula "$formula_name" "$class_name" "$description" "$homepage" "$url" "$license" "$sha256" "$project_type"; then
        print_info "Next steps:"
        echo "  1. Edit Formula/${formula_name}.rb to customize the installation"
        echo "  2. Update the SHA256 checksum if needed"
        echo "  3. Test the formula: brew install --build-from-source ./Formula/${formula_name}.rb"
        echo "  4. Validate: ./scripts/validate-formulas.sh -f Formula/${formula_name}.rb"
        echo "  5. Run tests: brew test $formula_name"
    fi
}

# Change to the repository root
cd "$(dirname "$0")/.."

# Check if we're in a homebrew tap directory
if [[ ! -d "Formula" ]]; then
    print_error "Formula directory not found. Are you in a Homebrew tap repository?"
    exit 1
fi

# Run main function
main "$@"
