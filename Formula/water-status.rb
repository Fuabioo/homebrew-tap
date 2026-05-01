# Homebrew formula template for water-status.
#
# This file is a TEMPLATE. scripts/publish-release.sh substitutes the
# v0.1.0 / 0.1.0 / @@SHA_*@@ placeholders before committing the
# rendered formula to github.com/Fuabioo/homebrew-tap.
class WaterStatus < Formula
  desc "Monitor AyA (Costa Rica) water-service interruptions and notify Telegram"
  homepage "https://github.com/Fuabioo/water-status"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/Fuabioo/water-status/releases/download/v0.1.0/water-status-linux-amd64.tar.gz"
      sha256 "1d59542511bb405741ee50899842610a5f0c9632cbf1269657e99a720d9a2d7f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Fuabioo/water-status/releases/download/v0.1.0/water-status-linux-amd64.tar.gz"
      sha256 "1d59542511bb405741ee50899842610a5f0c9632cbf1269657e99a720d9a2d7f"
    end
    on_arm do
      if Hardware::CPU.is_64_bit?
        url "https://github.com/Fuabioo/water-status/releases/download/v0.1.0/water-status-linux-arm64.tar.gz"
        sha256 "6655d38f6c1f5d44559de0efee08e7036c1fc2760dbfcb8984cd45a551026cd2"
      else
        url "https://github.com/Fuabioo/water-status/releases/download/v0.1.0/water-status-linux-armv7.tar.gz"
        sha256 "b2ab06bb188d5d1dbb993a81af321b3d33f226f020d1f748798813751526590b"
      end
    end
  end

  def install
    # Pick whichever per-arch binary is in the tarball and install it
    # under a stable name. Other archs' binaries never end up here —
    # each tarball ships a single binary plus the support files.
    binary = Dir["water-status-linux-*"].first
    bin.install binary => "water-status" if binary

    # Ship the systemd units and example config into pkgshare so the
    # post_install hook (and the user) can find them at a stable path.
    pkgshare.install "water-status.service"        if File.exist?("water-status.service")
    pkgshare.install "water-status.user.service"   if File.exist?("water-status.user.service")
    pkgshare.install "config.example.yaml"         if File.exist?("config.example.yaml")
  end

  # post_install runs after the files are placed in the Cellar but before
  # `brew install` returns. We use it to:
  #   1. Seed a default config in $XDG_CONFIG_HOME on first install.
  #   2. Drop a user-level systemd unit and try to start it.
  # This is *only* attempted on Linux; on macOS we leave service control
  # to `brew services` (the formula's `service do` block, below).
  def post_install
    seed_default_config

    return unless OS.linux?
    install_user_systemd_unit
    start_user_service
  end

  service do
    # macOS launchd / `brew services start water-status` path.
    run [opt_bin/"water-status"]
    keep_alive true
    log_path var/"log/water-status.log"
    error_log_path var/"log/water-status.log"
  end

  def caveats
    if OS.linux?
      <<~EOS
        ─────────────────────────────────────────────────────────────────
        water-status is installed as a per-user systemd service.

        Configuration: ~/.config/water-status/config.yaml
        Database:      ~/.local/share/water-status/state.db
        Web UI:        http://localhost:8080

        Service control:
          systemctl --user status   water-status
          systemctl --user restart  water-status
          journalctl --user -u water-status -f

        Keep the service running after you log out (recommended on a Pi):
          loginctl enable-linger $USER

        For a hardened SYSTEM-WIDE unit (dedicated user, sandboxed
        filesystem, MemoryMax=128M), see:
          #{opt_pkgshare}/water-status.service

        If automatic enable+start failed (no D-Bus session at install
        time, common over plain SSH), run:
          systemctl --user daemon-reload
          systemctl --user enable --now water-status
        ─────────────────────────────────────────────────────────────────
      EOS
    else
      <<~EOS
        Configuration: ~/.config/water-status/config.yaml
        Database:      ~/.local/share/water-status/state.db
        Web UI:        http://localhost:8080

        Start the service:
          brew services start water-status
      EOS
    end
  end

  test do
    # The binary embeds version + commit + build_time as ldflags.
    # `-version` prints them; we just confirm the executable runs and
    # reports the version we expect.
    assert_match version.to_s, shell_output("#{bin}/water-status -version")
  end

  # ─── helpers ─────────────────────────────────────────────────────

  private

  def xdg_dir(env_name, fallback)
    base = ENV[env_name]
    base = "#{Dir.home}/#{fallback}" if base.nil? || base.empty?
    Pathname.new(base)/"water-status"
  end

  def seed_default_config
    cfg_dir  = xdg_dir("XDG_CONFIG_HOME", ".config")
    data_dir = xdg_dir("XDG_DATA_HOME",   ".local/share")
    cfg_dir.mkpath
    data_dir.mkpath

    cfg_file = cfg_dir/"config.yaml"
    return if cfg_file.exist?

    example = pkgshare/"config.example.yaml"
    return unless example.exist?

    cp example, cfg_file
    chmod 0600, cfg_file
    ohai "Seeded default config at #{cfg_file}"
  end

  def install_user_systemd_unit
    src = pkgshare/"water-status.user.service"
    return unless src.exist?

    unit_dir = Pathname.new(Dir.home)/".config/systemd/user"
    unit_dir.mkpath
    cp src, unit_dir/"water-status.service"
    ohai "Installed user systemd unit at #{unit_dir}/water-status.service"
  end

  def start_user_service
    # systemctl --user requires an active D-Bus session bus. On a
    # headless first-install over SSH this may not be present; fail
    # soft and let the caveats tell the user how to start manually.
    return unless system("systemctl", "--user", "daemon-reload")

    if system("systemctl", "--user", "enable", "--now", "water-status")
      ohai "Started water-status (systemctl --user)"
    else
      opoo "Could not auto-start water-status. Run:\n" \
           "  systemctl --user enable --now water-status"
    end
  end
end
