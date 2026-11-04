# pywal fork (github.com/murtaza64/pywal). Update url and sha256 for each release.
# The commands run the fork through uv from a pinned tag: brew owns the install and upgrade, and uv
# owns Python 3.13 and the wheels (modern_colorthief's Rust wheel, Pillow), so nothing builds from source.
class Pywal < Formula
  desc "pywal fork with OKLCH palettes, a semantic palette contract and Palette Studio"
  homepage "https://github.com/murtaza64/pywal"
  url "https://github.com/murtaza64/pywal/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e9c35521229b5938da727a5935d3d300165fac180e55e0debbc16fc246a70915"
  license "MIT"

  depends_on "uv"
  depends_on "imagemagick" => :recommended

  def install
    source = "git+https://github.com/murtaza64/pywal@#{version.to_s.start_with?("v") ? version : "v#{version}"}"
    %w[wal walstudio].each do |cmd|
      (bin/cmd).write <<~SH
        #!/bin/sh
        exec "#{Formula["uv"].opt_bin}/uv" tool run --from "#{source}" #{cmd} "$@"
      SH
      chmod 0755, bin/cmd
    end
  end

  test do
    # The first real run downloads the fork through uv; the test checks the wrappers offline.
    %w[wal walstudio].each { |cmd| assert_match "tool run --from", (bin/cmd).read }
  end
end
