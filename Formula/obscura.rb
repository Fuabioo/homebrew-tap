require_relative "../custom_download_strategy"

class Obscura < Formula
  desc "Private tool hosted on GitHub releases"
  homepage "https://github.com/Fuabioo/obscura"
  version "1.0.0"  # Update this to match your actual version
  license "MIT"

  # Note: Update these URLs to match your actual release assets
  # The URLs should follow the pattern: https://github.com/owner/repo/releases/download/tag/filename
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/Fuabioo/obscura/releases/download/v#{version}/obscura_Darwin_x86_64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "update_with_actual_sha256_for_darwin_x86_64"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Fuabioo/obscura/releases/download/v#{version}/obscura_Darwin_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "update_with_actual_sha256_for_darwin_arm64"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Fuabioo/obscura/releases/download/v#{version}/obscura_Linux_x86_64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "update_with_actual_sha256_for_linux_x86_64"
  end

  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Fuabioo/obscura/releases/download/v#{version}/obscura_Linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "update_with_actual_sha256_for_linux_arm64"
  end

  def install
    # Install the binary (update binary name if different)
    bin.install "obscura"
  end

  test do
    # Basic test to ensure the binary runs
    system "#{bin}/obscura", "--version"
  end

  def caveats
    <<~EOS
      This formula requires a GitHub Personal Access Token for private repository access.

      Setup instructions:
      1. Create token: https://github.com/settings/tokens
      2. Grant 'repo' scope for private repository access
      3. Set environment variable: export GITHUB_TOKEN=your_token_here
      4. Add to shell profile: echo 'export GITHUB_TOKEN=your_token_here' >> ~/.zshrc

      For more details: https://github.com/fuabioo/homebrew-tap#private-repository-access
    EOS
  end
end
