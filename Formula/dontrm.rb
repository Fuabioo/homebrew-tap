class Dontrm < Formula
  desc "Subjective safe wheels for rm. Avoid messing up your system like a clown 🤡"
  homepage "https://dontrm.fuabioo.com/"
  version "0.0.0"
  license "MIT"

if OS.mac? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/dontrm/releases/download/v0.0.0/dontrm_Darwin_x86_64.tar.gz"
  sha256 "71202b65aedeed701927ec0a4c41c67ddafd9a19398ac03cfcba91582a7d0209"
end

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/dontrm/releases/download/v0.0.0/dontrm_Darwin_arm64.tar.gz"
  sha256 "b73143ce06ece42d657bf8de0c194cd3ce715f3949b1a2c0a769e949332a18e9"
end

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/dontrm/releases/download/v0.0.0/dontrm_Linux_x86_64.tar.gz"
  sha256 "7538c313ef9520e3f1e5d65cfd775ad0b05603b50df7f6ebad51ea65deb690ad"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/dontrm/releases/download/v0.0.0/dontrm_Linux_arm64.tar.gz"
  sha256 "a34ffdd9cfd0c75efd6ac31e77b284525c651ba6316c922ce55b85379158d623"
end


  def install
    bin.install "dontrm"
  end

  test do
    system "#{bin}/dontrm", "--version"
  end

  def post_install
    puts "dontrm installed successfully!"
    puts ""
    puts "🛡️  Replace 'rm' with 'dontrm' in your shell configuration"
    puts "   (e.g. .bashrc, .zshrc) for safer file deletion:"
    puts ""
    puts "   rm() {"
    puts "     dontrm \"$@\""
    puts "   }"
    puts ""
    puts "Run 'dontrm --help' to get started."
  end
end
