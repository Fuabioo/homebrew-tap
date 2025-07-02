class Altalune < Formula
  desc "A beautiful, modern Jira epic management tool with stunning data visualizations"
  homepage "https://github.com/Fuabioo/altalune"
  version "1.0.0"
  license "MIT"

if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/altalune/releases/download/v1.0.0/altalune_Darwin_arm64.tar.gz"
  sha256 "03d5f9028ae1f548c24ed97d643f8644d57cf8c7af0328f000ef007db1e36b35"
end

if OS.mac? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/altalune/releases/download/v1.0.0/altalune_Darwin_amd64.tar.gz"
  sha256 "fb46c66684e683d1cc617d5721fab24aeacb9784e38ab20fd123a567d97f0723"
end

if OS.linux? && Hardware::CPU.intel?
  url "https://github.com/Fuabioo/altalune/releases/download/v1.0.0/altalune_Linux_amd64.tar.gz"
  sha256 "cfceb2b17f1e5b6887beaf0c53bd5dd8be1440978f84a76c426a174c4264df87"
end

if OS.linux? && Hardware::CPU.arm?
  url "https://github.com/Fuabioo/altalune/releases/download/v1.0.0/altalune_Linux_arm64.tar.gz"
  sha256 "af1257d8df565824e85e473fd64111e248891e03b87b3e164eedc9ec142f06ef"
end

  def install
    bin.install "altalune"
  end

  test do
    system "#{bin}/altalune", "--version"
  end

  def post_install
    puts "🌟 Altalune installed successfully!"
    puts ""
    puts "Navigate your epics among the stars with beautiful Jira epic management"
    puts ""
    puts "🚀 Quick Start:"
    puts "  1. Get your Jira API credentials (host, email, API token)"
    puts "  2. Set environment variables or create a .env file:"
    puts "     export JIRA_EPIC_EMAIL=your-email@example.com"
    puts "     export JIRA_EPIC_TOKEN=your-jira-api-token"
    puts "     export JIRA_EPIC_WORKSPACE=your-workspace-id"
    puts "  3. Run: altalune"
    puts "  4. Open: http://localhost:3002"
    puts ""
    puts "✨ Features:"
    puts "  • Epic Analytics with beautiful D3.js visualizations"
    puts "  • Modern Vue.js web interface"
    puts "  • Real-time progress tracking"
    puts "  • Secure Jira Cloud integration"
    puts ""
    puts "📚 Documentation: https://github.com/Fuabioo/altalune"
    puts "🆘 Help: altalune --help"
  end
end
