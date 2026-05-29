class TetoricaMdropAT062 < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.6.2"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.2/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "d8ec5b69e858458528070fa7e305154766336934b6fd1a26bc9b6ef0478b6de0"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.2/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "3198c423726ae97a0fee2f789c567e4e1692d64168e621bc818ff593bc266901"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.2/tetorica-mdrop-linux-arm.tar.gz"
    sha256 "e0724ad825c9d44f00c9483cbdd2dd47e4b80ef3a49e421da1cb1c3f7b5026fb"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.6.2/tetorica-mdrop-linux-x86.tar.gz"
    sha256 "9d3098f767133f4f5a94e7a1329b2d7fa27444f93731f4d93b458999090f88e2"
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
