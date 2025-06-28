class Fastfetch < Formula
  desc "A neofetch-like tool for fetching system information and displaying it in a pretty way"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  version "2.46.0"
  license "MIT"

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/fastfetch-cli/fastfetch/releases/download/2.46.0/fastfetch-linux-amd64.tar.gz"
  sha256 "d256c4fcd5d6677e53c8ed53763f6eb627d32964847925fada00e9858df7218c"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/fastfetch-cli/fastfetch/releases/download/2.46.0/fastfetch-linux-aarch64.tar.gz"
  sha256 "3b7a015fb2e9def4d4e8fd9a6477ba49ecbc2ed1e0c4d47802a869d1e5e05ba8"
end


  def install
    bin.install "fastfetch"
  end

  test do
    system "#{bin}/fastfetch", "--version"
  end

  def post_install
    puts "fastfetch installed successfully!"
    puts ""
    puts "🚀 A fast neofetch-like system information tool"
    puts ""
    puts "Usage:"
    puts "  fastfetch                    # Display system information"
    puts "  fastfetch --config-path      # Show config file location"
    puts "  fastfetch --help             # Show all options"
    puts ""
    puts "Run 'fastfetch' to see your system information!"
  end
end
