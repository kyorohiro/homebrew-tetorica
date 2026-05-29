
#!/bin/sh
set -eu

VERSION="${1:?usage: $0 0.5.12}"

REPO="kyorohiro/tetorica-mdrop"
CLASS_MAIN="TetoricaMdrop"
CLASS_VERSIONED="TetoricaMdropAT${VERSION}"

# Ruby class name 用に 0.5.12 -> 0512
CLASS_VERSIONED="$(echo "$CLASS_VERSIONED" | sed 's/[^A-Za-z0-9]//g')"

FORMULA_DIR="Formula"
MAIN_FORMULA="${FORMULA_DIR}/tetorica-mdrop.rb"
VERSIONED_FORMULA="${FORMULA_DIR}/tetorica-mdrop@${VERSION}.rb"

BASE_URL="https://github.com/${REPO}/releases/download/v${VERSION}"

AARCH64_MAC="tetorica-mdrop-aarch64-apple-darwin.tar.gz"
X86_64_MAC="tetorica-mdrop-x86_64-apple-darwin.tar.gz"
LINUX_ARM="tetorica-mdrop-linux-arm.tar.gz"
LINUX_X86="tetorica-mdrop-linux-x86.tar.gz"

mkdir -p "$FORMULA_DIR"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

sha256_of_url() {
  file="$1"
  url="${BASE_URL}/${file}"

  echo "Downloading: $url" >&2
  curl -fL "$url" -o "$tmpdir/$file"
  shasum -a 256 "$tmpdir/$file" | awk '{print $1}'
}

SHA_AARCH64_MAC="$(sha256_of_url "$AARCH64_MAC")"
SHA_X86_64_MAC="$(sha256_of_url "$X86_64_MAC")"
SHA_LINUX_ARM="$(sha256_of_url "$LINUX_ARM")"
SHA_LINUX_X86="$(sha256_of_url "$LINUX_X86")"

write_formula() {
  class_name="$1"
  output_file="$2"

  cat > "$output_file" <<EOF
class ${class_name} < Formula
  desc "Local network file sharing server"
  homepage "https://github.com/${REPO}"
  version "${VERSION}"

  if OS.mac? && Hardware::CPU.arm?
    url "${BASE_URL}/${AARCH64_MAC}"
    sha256 "${SHA_AARCH64_MAC}"
  elsif OS.mac? && Hardware::CPU.intel?
    url "${BASE_URL}/${X86_64_MAC}"
    sha256 "${SHA_X86_64_MAC}"
  elsif OS.linux? && Hardware::CPU.arm?
    url "${BASE_URL}/${LINUX_ARM}"
    sha256 "${SHA_LINUX_ARM}"
  elsif OS.linux? && Hardware::CPU.intel?
    url "${BASE_URL}/${LINUX_X86}"
    sha256 "${SHA_LINUX_X86}"
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
EOF
}

write_formula "$CLASS_MAIN" "$MAIN_FORMULA"
write_formula "$CLASS_VERSIONED" "$VERSIONED_FORMULA"

echo "Generated:"
echo "  $MAIN_FORMULA"
echo "  $VERSIONED_FORMULA"
echo
echo "Check:"
echo "  brew install --build-from-source ./$MAIN_FORMULA"
echo "  brew install --build-from-source ./$VERSIONED_FORMULA"
