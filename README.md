# My Homebrew Tap 🍺

A personal Homebrew tap containing custom formulas for various tools and applications.

## What is a Homebrew Tap?

A Homebrew tap is a third-party repository that allows you to install software not available in the main Homebrew repository. Think of it as a custom package repository for macOS and Linux.

## Installation

To add this tap to your Homebrew installation:

```bash
brew tap yourusername/homebrew-tap
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

- macOS or Linux
- Homebrew installed
- Ruby (for formula development)
- Git

### Local Development

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/homebrew-tap.git
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

### Installation Process
- **Homebrew**: Typically builds from source with formulas describing build process
- **APT**: Installs pre-compiled binary packages

### Dependency Management
- **Homebrew**: Automatic dependency resolution with `depends_on` declarations
- **APT**: Uses control file dependencies with more complex version constraints

### File Locations
- **Homebrew**: Installs to `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
- **APT**: Follows FHS (Filesystem Hierarchy Standard) with system-wide locations

### Distribution
- **Homebrew**: Git-based tap system, formulas are distributed as Ruby code
- **APT**: Repository-based with signed package indexes and binary distribution

### Platform Support
- **Homebrew**: macOS and Linux
- **APT**: Debian-based Linux distributions only

### Package Maintenance
- **Homebrew**: Community-driven with pull requests to formula repositories
- **APT**: Maintained by distribution maintainers with more formal processes

## Contributing

1. Fork this repository
2. Create a feature branch: `git checkout -b my-new-formula`
3. Add your formula to the `Formula/` directory
4. Test your formula thoroughly
5. Commit your changes: `git commit -am 'Add new formula: my-tool'`
6. Push to the branch: `git push origin my-new-formula`
7. Submit a pull request

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

**Note**: Replace `yourusername` with your actual GitHub username throughout this repository.