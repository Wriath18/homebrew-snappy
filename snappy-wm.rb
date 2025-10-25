class SnappyWm < Formula
  desc "macOS window snapping utility with global hotkeys"
  homepage "https://github.com/Wriath18/Snappy"
  url "https://github.com/Wriath18/Snappy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d08aa7624c6b066498bffbea9d05f87690ba283e073ccfda2a37db966d34de39" # Will be filled when you create a release
  license "MIT"
  
  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/Snappy" => "snappy"
  end

  service do
    run [opt_bin/"snappy"]
    keep_alive true
    log_path "/tmp/snappy.out.log"
    error_log_path "/tmp/snappy.err.log"
    process_type :interactive
  end

  def caveats
    <<~EOS
      Snappy has been installed!

      To start the service now and at login:
        brew services start snappy-wm

      Or run manually:
        snappy

      First-time setup:
        1. Press any hotkey (Ctrl+Opt+Cmd + Arrow) to trigger the accessibility permission dialog
        2. Enable Snappy in System Settings > Privacy & Security > Accessibility
        3. Press the hotkey again to start snapping windows!

      Hotkeys:
        Ctrl+Opt+Cmd + Left/Right/Up/Down  - Snap to half
        Ctrl+Opt+Cmd + Return              - Maximize
        Ctrl+Opt+Cmd + C                   - Center

      HTTP API:
        POST http://localhost:42424/snap/{action}
        Actions: left, right, top, bottom, maximize, center

      Logs: /tmp/snappy.out.log and /tmp/snappy.err.log
    EOS
  end

  test do
    system "#{bin}/snappy", "--version"
  end
end

