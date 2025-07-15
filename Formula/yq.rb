class Yq < Formula
  desc "A lightweight and portable command-line YAML, JSON, XML, and CSV processor"
  homepage "https://github.com/mikefarah/yq"
  version "4.44.2"
  license "MIT"

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_darwin_arm64.tar.gz"
  sha256 "d1a0acfb67c5da10f10147b4d19e6b4a10112baaf458a3c879cfa8c92123941e562ac3e80b260c12998465ca0702bfe67d9098d99034dca807e3a5100c616fcc"
end

if OS.mac? && Hardware::CPU.intel?
  url "https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_darwin_amd64.tar.gz"
  sha256 "b9e6d008a17f4e41c89694b145c3d04a497a8854b98a2f61023244a6e44f8b85fad3b969fdca4355011f88e58b6bb9140a491b03a0ca0dd5c11a2e50673842ab"
end

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_linux_amd64.tar.gz"
  sha256 "faa269955cc5fe3b9c0e876e0917b32cef7d12350d3c428624d9c2e81726b2eea15399f6bdece19a0ecae8dcf06719564f847541cced34f009b59d297d95988f"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/mikefarah/yq/releases/download/v4.44.2/yq_linux_arm64.tar.gz"
  sha256 "542f745db7777cd7226c446bb5abd8af893befbd6bfb608ec5b5774c22cc44b0dcfefa69e6951af43747e2eab3cb9c4ea6de4241e10ef2dc89ab4fbe16c03c5c"
end

  def install
    # The binary name varies by platform in the tar archives
    if OS.mac? && Hardware::CPU.arm?
      bin.install "yq_darwin_arm64" => "yq"
    elsif OS.mac? && Hardware::CPU.intel?
      bin.install "yq_darwin_amd64" => "yq"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "yq_linux_amd64" => "yq"
    elsif OS.linux? && Hardware::CPU.arm?
      bin.install "yq_linux_arm64" => "yq"
    end
  end

  test do
    system "#{bin}/yq", "--version"
  end

  def post_install
    puts "yq installed successfully!"
    puts ""
    puts "🔧 A lightweight and portable command-line YAML, JSON, XML, and CSV processor"
    puts ""
    puts "Usage:"
    puts "  yq '.field' file.yaml           # Read a value from YAML"
    puts "  yq -i '.field = \"value\"' file.yaml  # Update YAML file in-place"
    puts "  yq -o json file.yaml            # Convert YAML to JSON"
    puts "  yq -o xml file.yaml             # Convert YAML to XML"
    puts "  yq --help                       # Show all options"
    puts ""
    puts "Examples:"
    puts "  cat file.yaml | yq '.name'      # Pipe YAML and extract field"
    puts "  yq eval-all '. as $item ireduce ({}; . * $item)' *.yml  # Merge multiple files"
    puts "  yq '.items[] | select(.name == \"foo\")' file.yaml      # Filter arrays"
    puts ""
    puts "Perfect for YAML processing, just like jq but for YAML!"
    puts "Run 'yq --help' to get started."
  end
end
