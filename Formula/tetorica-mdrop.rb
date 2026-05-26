class TetoricaMdrop < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.5.3+2"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+2/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "9b25133a10372200c889d7a2d9785b3ee2f7bb645a6a25c2c6b6774bc55b2651"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+2/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "376c0ea7c1a8e5d5adaff9fa4a6a2105e451d7de17dd7a46d4fd51ea23824e5f"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+1/tetorica-mdrop-linux-arm.tar.gz"
    sha256 "30fcf175addfab552ac810132ec3f963afa41297a2860d1ec0f09904154139c1"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+1/tetorica-mdrop-linux-x86.tar.gz"
    sha256 "23fbd76d4b5b06661e27403d7fd4d0c81829952bc426341b7dcf2519c9a6e91e"
  end


  def install
    bin.install "tetorica-mdrop"

    (var/"tetorica-mdrop/share").mkpath
    (var/"log").mkpath
  end

  service do
    run [
      opt_bin/"tetorica-mdrop",
      var/"tetorica-mdrop/share",
      "--config",
      etc/"tetorica-mdrop/config.toml",
      "--hostname",
      "mdrop.local",
      "--port",
      "7878"
    ]
    keep_alive true
    working_dir var/"tetorica-mdrop"
    log_path var/"log/tetorica-mdrop.log"
    error_log_path var/"log/tetorica-mdrop-error.log"
  end

  test do
    system "#{bin}/tetorica-mdrop", "--version"
  end
end