class BufFmtStdin < Formula
  desc "Buf protocol buffer formatter wrapper for stdin text editor integration"
  homepage "https://github.com/Fuabioo/buf-fmt-stdin"
  version "0.0.0"
  license "MIT"

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/buf-fmt-stdin/releases/download/v0.0.0/buf-fmt-stdin_Darwin_arm64.tar.gz"
  sha256 "0740d0fd9e7c399865efc903ef46f3d514fb5ce87aa615eaf32780f6eacebf86"
end

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/buf-fmt-stdin/releases/download/v0.0.0/buf-fmt-stdin_Linux_x86_64.tar.gz"
  sha256 "8340cc0f91b97236450d8ac14b77f70a77ca6c28090efd66e468512bc0b3e02b"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/buf-fmt-stdin/releases/download/v0.0.0/buf-fmt-stdin_Linux_arm64.tar.gz"
  sha256 "39b4302ffe74a7493a2ad92628435ebe00f7f102d6f403030c1c3a4a967a6f62"
end


  def install
    bin.install "buf-fmt-stdin"
  end

  test do
    system "#{bin}/buf-fmt-stdin", "--version"
  end

  def post_install
    puts "buf-fmt-stdin installed successfully!"
    puts "This tool provides protocol buffer formatting for stdin text editor integration."
    puts "Run 'buf-fmt-stdin --help' to get started."
  end
end
