# Written by scripts/brew-release.sh in the mist repo; edit it there.
class Mist < Formula
  desc "Go build cache (GOCACHEPROG) that keeps many worktrees under a disk limit"
  homepage "https://github.com/Fuabioo/homebrew-tap#mist"
  url "https://github.com/Fuabioo/homebrew-tap/releases/download/mist-v0.1.1/mist-0.1.1-darwin-arm64.tar.gz"
  version "0.1.1"
  sha256 "3cd61606eb36ed2ff30930205feec2ba9ae9493c01544630fe686f498434dd15"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "mist"
  end

  def caveats
    <<~EOS
      mist does nothing until its daemon runs and GOCACHEPROG names it:
        export MIST_DIR=$HOME/Library/Caches/mist
        MIST_DISK_LIMIT=20G MIST_HOT_BYTES=12G MIST_WARM_BYTES=6G \\
          MIST_WARM_CODEC=zstd MIST_WARM_CHUNKING=cdc mist daemon &
        export GOCACHEPROG="#{opt_bin}/mist cacheprog"
      `mist status` shows the daemon; `unset GOCACHEPROG` turns it off.
      Never set it with `go env -w`: Go fails every command whose
      GOCACHEPROG cannot start, including ones outside your shell.
    EOS
  end

  test do
    assert_match(/\A[0-9a-f]{12}\n\z/, shell_output("#{bin}/mist version"))
  end
end
