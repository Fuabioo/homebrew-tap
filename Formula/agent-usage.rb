# Written by scripts/brew-release.sh in the agent-usage-tray repo; edit it there.
class AgentUsage < Formula
  desc "Usage and pace of AI coding agents (Claude, Codex, Charm Hyper) as JSON"
  homepage "https://github.com/Fuabioo/agent-usage-tray"
  url "https://github.com/Fuabioo/agent-usage-tray/releases/download/v0.1.0/agent-usage-0.1.0-darwin-arm64.tar.gz"
  version "0.1.0"
  sha256 "c93f606ed7862089777b18cf7d4699d5b2e6db988ef96b4d7a960b244ea4ad87"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "agent-usage"
  end

  def caveats
    <<~EOS
      `agent-usage all --json` reads every agent it finds credentials for;
      `agent-usage claude --status` is the human-readable view of one.
      Settings live in ~/.config/agent-usage/config.json (`agent-usage config`).
    EOS
  end

  test do
    assert_equal "agent-usage #{version}\n", shell_output("#{bin}/agent-usage --version")
  end
end
