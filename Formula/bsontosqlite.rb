class Bsontosqlite < Formula
  desc "CLI tool to convert BSON to SQLite"
  homepage "https://github.com/Fuabioo/bsontosqlite"
  version "0.0.0"
  license "MIT"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/Fuabioo/bsontosqlite/releases/download/v0.0.0/bsontosqlite_Darwin_amd64.tar.gz"
    sha256 "fffc567737542da59ba9dcf47c56137fe5575b21f7e816386b819b288d2e0088"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Fuabioo/bsontosqlite/releases/download/v0.0.0/bsontosqlite_Darwin_arm64.tar.gz"
    sha256 "f61220117f0af58424eef06a47ba336db9fadb6da339614b046e49719716f679"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Fuabioo/bsontosqlite/releases/download/v0.0.0/bsontosqlite_Linux_amd64.tar.gz"
    sha256 "cfe762910ba3c1085a2e5f1298201b6dcdbfd37ebd9b6820305dc1059f81f789"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Fuabioo/bsontosqlite/releases/download/v0.0.0/bsontosqlite_Linux_arm64.tar.gz"
    sha256 "ee449513e1a45a3c4382115b1f91a8b1442ab3be9ef68ffbd580f670cbb97a56"
  end

  def install
    bin.install "bsontosqlite"
  end

  test do
    system "#{bin}/bsontosqlite", "--help"
  end

  def post_install
    puts "bsontosqlite installed successfully!"
    puts ""
    puts "🔄 Convert MongoDB BSON dumps to SQLite databases"
    puts ""
    puts "Usage:"
    puts "  bsontosqlite -b collection.bson -m metadata.json -o output.db"
    puts ""
    puts "Flags:"
    puts "  -b, --bson      Path to BSON file (required)"
    puts "  -m, --metadata  Path to metadata.json file (required)"
    puts "  -o, --output    Output SQLite database file (default: output.db)"
    puts "  -v, --verbose   Verbose output (-v for info, -vv for debug)"
    puts ""
    puts "Run 'bsontosqlite --help' for more details."
  end
end
