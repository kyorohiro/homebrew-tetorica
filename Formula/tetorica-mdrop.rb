class TetoricaMdropCli < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.5.2"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "PUT_SHA256_HERE"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "PUT_SHA256_HERE"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "PUT_SHA256_HERE"
  end

  def install
    bin.install "tetorica-mdrop"

    (var/"tetorica-mdrop").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"tetorica-mdrop", "serve", var/"tetorica-mdrop", "--hostname", "0.0.0.0", "--port", "7878"]
    keep_alive true
    working_dir var/"tetorica-mdrop"
    log_path var/"log/tetorica-mdrop.log"
    error_log_path var/"log/tetorica-mdrop-error.log"
  end

  test do
    system "#{bin}/tetorica-mdrop", "--version"
  end
end