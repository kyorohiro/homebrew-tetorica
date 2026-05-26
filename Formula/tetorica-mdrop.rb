class TetoricaMdrop < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.5.3+6"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+4/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "9b25133a10372200c889d7a2d9785b3ee2f7bb645a6a25c2c6b6774bc55b2651"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+4/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "376c0ea7c1a8e5d5adaff9fa4a6a2105e451d7de17dd7a46d4fd51ea23824e5f"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+4/tetorica-mdrop-linux-arm.tar.gz"
    sha256 "a8b93cdfc911e454801f1c9f320956d7a56d668a986a17eb45b9fbad1aa2ede6"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.3+4/tetorica-mdrop-linux-x86.tar.gz"
    sha256 "60e30e6bb4945c7805d9f6c8e79664e44b20a809ccbaf1f98ba19647600444e0"
  end

  def install
    bin.install "tetorica-mdrop"

    (var/"tetorica-mdrop/share").mkpath
    (var/"tetorica-mdrop").mkpath
    (var/"log").mkpath
    (etc/"tetorica-mdrop").mkpath

    config = etc/"tetorica-mdrop/config.toml"
    unless config.exist?
      config.write <<~EOS
        path = "#{var}/tetorica-mdrop/share"
        hostname = "mdrop.local"
        port = 7878
        no_bonjour = false
        local_only = true
        is_https = false
        id = ""
        password = ""
      EOS
    end
  end

  service do
    run [
      opt_bin/"tetorica-mdrop",
      "--config",
      etc/"tetorica-mdrop/config.toml"
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