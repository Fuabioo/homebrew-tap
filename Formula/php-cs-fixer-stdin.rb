class PhpCsFixerStdin < Formula
  desc "php-cs-fixer formatter wrapper for stdin text editor integration"
  homepage "https://github.com/Fuabioo/php-cs-fixer-stdin"
  version "0.0.0"
  license "MIT"

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/php-cs-fixer-stdin/releases/download/v0.0.0/php-cs-fixer-stdin_Darwin_arm64.tar.gz"
  sha256 "d1c901147dd8253a8571fd1d9c29296504d4f419b9249440db974290df98571c"
end

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/php-cs-fixer-stdin/releases/download/v0.0.0/php-cs-fixer-stdin_Linux_x86_64.tar.gz"
  sha256 "461a38f9869cfca6929449019577ec3e9af610641ca425167ea524e9fc064a1d"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/php-cs-fixer-stdin/releases/download/v0.0.0/php-cs-fixer-stdin_Linux_arm64.tar.gz"
  sha256 "cc57f1b5b8caff06f2cd2817e6ca5d01568cb65c850b6d654a1d902b2f1ee34f"
end


  def install
    bin.install "php-cs-fixer-stdin"
  end

  test do
    system "#{bin}/php-cs-fixer-stdin", "--version"
  end

  def post_install
    puts "php-cs-fixer-stdin installed successfully!"
    puts ""
    puts "🔧 PHP CS Fixer wrapper for stdin text editor integration"
    puts ""
    puts "Usage:"
    puts "  echo '<?php $a=1;' | php-cs-fixer-stdin    # Format PHP code from stdin"
    puts "  php-cs-fixer-stdin --help                  # Show all options"
    puts ""
    puts "This tool allows text editors to format PHP code via stdin/stdout,"
    puts "making it perfect for editor integrations and automated workflows."
  end
end
