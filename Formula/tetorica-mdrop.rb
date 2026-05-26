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
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-linux-arm.tar.gz"
    sha256 "81196d27ddbf4f9e1d76d817cd5f300e92c07c3766bcca34b921fbb4a90dcd47"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kyorohiro/tetorica-mdrop/releases/download/v0.5.2/tetorica-mdrop-linux-x86.tar.gz"
    sha256 "565ab8f53d12429786808b7c621df87a020b7df26a9466429fce827e292ebd30"
  end


  def install
    bin.install "tetorica-mdrop"

    (var/"tetorica-mdrop/share").mkpath
    (var/"log").mkpath
  end

  service do
    run [
      opt_bin/"tetorica-mdrop",
      "serve",
      var/"tetorica-mdrop/share",
      "--hostname",
      "0.0.0.0",
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