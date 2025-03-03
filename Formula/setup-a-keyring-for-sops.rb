class SetupAKeyringForSops < Formula
  desc "Use gcloud to setup everything needed for SOPS"
  homepage "https://github.com/PurpleBooth/setup-a-keyring-for-sops"
  url "https://github.com/PurpleBooth/setup-a-keyring-for-sops/archive/refs/tags/v0.42.15.tar.gz"
  sha256 "46d3efb6a2441e8fae12f70e2b7258c6b9d0283a782e72b817294e99c48b821a"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/setup-a-keyring-for-sops-0.42.15"
    sha256 cellar: :any_skip_relocation, catalina:     "ecfb3349003109269f326b0c01bdc20200cbc72866d0edeafe5e25985454f5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "883e3a5a931df5daab711175a6fe4c15a0bdfb0a7e30556b5994f129241036b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  def caveats
    <<~EOS
      At runtime, gcloud must be accessible from your PATH.
      You can install gcloud from Homebrew Cask:
        brew install google-cloud-sdk
    EOS
  end

  test do
    system "#{bin}/setup-a-keyring-for-sops", "-h"
    system "#{bin}/setup-a-keyring-for-sops", "-V"
  end
end
