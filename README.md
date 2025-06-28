# My Homebrew Tap 🍺

A cross-platform Homebrew tap containing custom formulas for macOS and Linux, featuring an automated formula generation system that serves as a modern alternative to APT repositories.

## What is a Homebrew Tap?

A Homebrew tap is a third-party repository that allows you to install software not available in the main Homebrew repository. Think of it as a custom package repository that works on both macOS and Linux, providing a unified package management experience across platforms.

## 🌍 Cross-Platform Support

This tap provides true cross-platform support:

- **macOS**: Native Homebrew support (Intel and Apple Silicon)
- **Linux**: Full Homebrew support on all major distributions
- **Same commands**: Identical installation and usage across platforms
- **APT Alternative**: Modern replacement for traditional APT repositories

## Installation

### macOS Installation

```bash
# Homebrew should already be installed on macOS
brew tap fuabioo/homebrew-tap
brew install fastfetch dontrm
```

### Linux Installation

```bash
# Install Homebrew on Linux (if not already installed)
Head to https://brew.sh/

# Add tap and install packages
brew tap fuabioo/homebrew-tap
brew install fastfetch dontrm
```

Once the tap is added, you can install any formula from this repository:

```bash
brew install example-tool
brew install my-python-cli
```

## Available Formulas

### Example Tool
A demonstration command-line tool showcasing Homebrew formula structure.

```bash
brew install example-tool
```

### My Python CLI
A modern Python CLI tool with rich features and beautiful output.

```bash
brew install my-python-cli
```

## Development

### Prerequisites

- **macOS or Linux** (Windows via WSL also supported)
- **Homebrew installed** (works on both platforms)
- **just command runner** (`brew install just` or see [installation guide](https://github.com/casey/just#installation))
- **Ruby** (for formula development)
- **Git**
- **GitHub token** (recommended for API access)
- **Docker** (optional, for isolated testing environment)

### Local Development

1. Clone this repository:
   ```bash
   git clone https://github.com/fuabioo/homebrew-tap.git
   cd homebrew-tap
   ```

2. Install development dependencies:
   ```bash
   brew install ruby
   ```

3. Test a formula locally:
   ```bash
   brew install --build-from-source ./Formula/example-tool.rb
   ```

4. Validate formula syntax:
   ```bash
   ./scripts/validate-formulas.sh
   ```

### Creating a New Formula

1. Create a new `.rb` file in the `Formula/` directory
2. Use the existing formulas as templates
3. Follow Homebrew's [Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
4. Test your formula thoroughly

### Formula Structure

Homebrew formulas are Ruby classes that inherit from the `Formula` class. Key components include:

- **desc**: Short description of the software
- **homepage**: Official website URL
- **url**: Download URL for the source code
- **sha256**: Checksum of the source archive
- **license**: Software license
- **depends_on**: Dependencies required for building/running
- **install**: Installation instructions
- **test**: Tests to verify the installation works

### Testing

Before submitting changes:

1. Run the validation script:
   ```bash
   ./scripts/validate-formulas.sh
   ```

2. Test installation locally:
   ```bash
   brew install --build-from-source ./Formula/your-formula.rb
   ```

3. Run the formula's tests:
   ```bash
   brew test your-formula
   ```

4. Clean up test installations:
   ```bash
   brew uninstall your-formula
   ```

## Homebrew vs APT Packages

Here are the key differences between Homebrew formulas and APT packages:

### Package Format
- **Homebrew**: Ruby-based DSL (Domain Specific Language) with `.rb` files
- **APT**: Debian control files with binary `.deb` packages

| Feature | APT | Homebrew |
|---------|-----|----------|
| **Platform Support** | Linux only | macOS + Linux |
| **User Installation** | Root required | User space |
| **Package Versions** | Distribution managed | Latest upstream |
| **Dependency Management** | System-wide | Isolated |
| **Development Tools** | Limited | Extensive |
| **Cross-Platform Consistency** | No | Yes |

### When to Use Each

**Choose Homebrew when:**
- Developing on macOS and deploying on Linux
- Need latest versions of development tools
- Want consistent package management across platforms
- Working in containerized environments
- Need user-space installation without root access

**Choose APT when:**
- Pure Linux server environments with system integration
- Corporate environments with strict package policies
- Need distribution-specific optimizations

### Migration Benefits

Moving from APT to Homebrew provides:
- **Unified tooling** across development and production
- **Latest software versions** without waiting for distribution updates
- **User-space installation** without requiring root privileges
- **Cross-platform consistency** for development teams

## Contributing

### Adding New Formulas

1. Fork this repository
2. Create a feature branch: `git checkout -b my-new-formula`
3. Create a YAML spec: `just new-spec my-tool`
4. Edit the spec file in `specs/my-tool.yml`
5. Generate and test the formula with end-to-end testing: `just docker-formula my-tool`
6. Run full test suite with end-to-end testing: `just docker-test`
7. Commit your changes: `git commit -am 'Add new formula: my-tool'`
8. Push to the branch: `git push origin my-new-formula`
9. Submit a pull request

### Updating Existing Formulas

1. Update the YAML spec in `specs/`
2. Regenerate and test the formula with end-to-end testing: `just docker-formula name`
3. Run validation and end-to-end testing: `just docker-e2e`
4. Submit a pull request

### Using Just Command Runner

This project uses `just` as its command runner for a better developer experience. See [MIGRATION.md](MIGRATION.md) for migration details from the previous `make` system.

**Command Reference:**
- `just build` - Build all formulas
- `just formula name` - Build specific formula
- `just new-spec tool` - Create new spec template
- `just test` - Run comprehensive tests
- `just help` - Show all available commands

### Guidelines

- Follow the [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
- Ensure your formula passes all tests
- Use descriptive commit messages
- Update documentation as needed
- Respect existing code style and conventions

## Troubleshooting

### Common Issues

**Formula not found after adding tap:**
```bash
brew update
brew search your-formula-name
```

**Build failures:**
```bash
brew install --verbose --debug your-formula-name
```

**Permission issues:**
```bash
sudo chown -R $(whoami) $(brew --prefix)/*
```

**Outdated formula:**
```bash
brew update
brew upgrade your-formula-name
```

### Getting Help

- Check the [Homebrew Documentation](https://docs.brew.sh/)
- Search existing issues in this repository
- Create a new issue with detailed information about your problem

## License

This tap repository is available under the MIT License. Individual formulas may have their own licenses - please check each formula file for specific license information.

## Acknowledgments

- The Homebrew team for creating an amazing package manager
- The community for contributing formulas and improvements
- All the developers whose tools are packaged in this tap

---
