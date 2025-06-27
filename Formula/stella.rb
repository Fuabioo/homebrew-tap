class Stella < Formula
  desc "A TUI that shows a progress bar for a remote work"
  homepage "https://github.com/Fuabioo/stella"
  version "0.0.0"
  license "MIT"

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/stella/releases/download/v0.0.0/stella_Darwin_arm64.tar.gz"
  sha256 "1780d9c663f2fae0fc577e81761a81f2b433d44017506d309245da556c3bb84b"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/stella/releases/download/v0.0.0/stella_Linux_arm64.tar.gz"
  sha256 "8c1e34da1d2c58f9750293e4454164bcfaa220ac414fed6acf5486de27e68fd5"
end


  def install
    bin.install "stella"
  end

  test do
    system "#{bin}/stella", "--version"
  end

  def post_install
    puts "stella installed successfully!"
    puts ""
    puts "⭐ A beautiful TUI progress bar for remote work monitoring"
    puts ""
    puts "Usage:"
    puts "  stella <command>                # Show progress for a command"
    puts "  stella --help                   # Show all options"
    puts ""
    puts "Perfect for monitoring long-running remote tasks with style!"
    puts "Run 'stella --help' to get started."
  end
end
