class TetoricaMdropAT063 < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.6.3"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.3/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "6d1fea142291ded2a4678cdc6034487d9b309bc9077a03c261158c2d369cb532"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.3/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "76ca0f731f7376fd0c31155dbfbb808e02ce8abe9ce69b321b1b1eca83fd88f7"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.3/tetorica-mdrop-linux-arm.tar.gz"
    sha256 "08175538ed2f0761df62ae5dbd8606b6f9f79bc0478b7e3d9ed5ce328ccfee54"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.3/tetorica-mdrop-linux-x86.tar.gz"
    sha256 "dfa2786fe4d9954d9e307fe1ea5cfb35e21d8439440b1a25db809671933d03c4"
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
