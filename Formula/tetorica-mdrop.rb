class TetoricaMdrop < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/kyorohiro/tetorica-mdrop"
  version "0.5.2"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-aarch64-apple-darwin.tar.gz"
    sha256 "6c97a7e27cbd061999b9c6330e8e17e307e747f7cc337ec7ed62f5deab5c6c6c"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-x86_64-apple-darwin.tar.gz"
    sha256 "868531c9372b36b6988494428d05009ce0753f74f680adcfb58ae536e8eba1cb"
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