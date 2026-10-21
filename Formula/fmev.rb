class Fmev < Formula
  desc "TypeSafe Jev-compatible decision API on Apple's on-device Foundation Model"
  homepage "https://github.com/mrubens/fmev"
  url "https://github.com/mrubens/fmev/releases/download/v0.1.1/fmev-0.1.1-macos-arm64.zip"
  sha256 "d90a5314d3ed9dbeadb84dd2ce32ea7db6fc4bd8334aacd96681326c223d41d4"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "fmev"
  end

  def caveats
    <<~EOS
      fmev uses the Apple Foundation Models model built into macOS. It needs
      macOS 27 or later with Apple Intelligence turned on
      (System Settings > Apple Intelligence & Siri).

      Run it in the foreground with `fmev`, or in the background with
      `brew services start fmev`. It listens on http://127.0.0.1:8787.
    EOS
  end

  service do
    run opt_bin/"fmev"
    keep_alive true
    log_path var/"log/fmev.log"
    error_log_path var/"log/fmev.log"
  end

  test do
    port = free_port
    pid = spawn({ "FMEV_PORT" => port.to_s }, bin/"fmev")
    sleep 3
    assert_match "\"ok\"", shell_output("curl -s http://127.0.0.1:#{port}/health")
  ensure
    Process.kill("TERM", pid)
  end
end
