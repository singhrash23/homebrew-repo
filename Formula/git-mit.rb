class GitMit < Formula
  desc "Minimalist set of hooks to aid pairing and link commits to issues"
  homepage "https://github.com/PurpleBooth/git-mit"
  url "https://github.com/PurpleBooth/git-mit/archive/v4.0.2.tar.gz"
  sha256 "b418a70aa2cff85202e9b65a75886cc11531bfd4d64d6ca5fbb15d9c4b42a1ac"

  bottle do
    root_url "https://github.com/PurpleBooth/homebrew-repo/releases/download/git-mit-4.0.2"
    sha256 cellar: :any,                 catalina:     "24baa767a9b3543e104b9633f2ccba9b35c2e4cc876ae22ba00c371b0adba459"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c07bb97efcc0d64e9378e792cbc3fb7b8075b3d7a2b942183703e081778db274"
  end
  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "git"
  depends_on "openssl@1.1"
  on_linux do
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./mit-commit-msg/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./mit-pre-commit/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./mit-prepare-commit-msg/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./git-mit/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./git-mit-config/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./git-mit-relates-to/"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./git-mit-install/"

    Pathname.glob("**/bash_completion/*").each do |file|
      base = file.basename(".bash")
      bash_completion.install file => base
    end

    Pathname.glob("**/fish_completion/*").each do |file|
      fish_completion.install file
    end

    Pathname.glob("**/zsh_completion/*").each do |file|
      zsh_completion.install file
    end

    Pathname.glob("**/*.man.md").each do |file|
      base = file.basename(".man.md")
      system "pandoc", "--wrap=auto", "-s", "-f", "markdown", "-t", "man", file, "-o", "#{base}.1"
      man1.install "#{base}.1"
    end
  end

  test do
    system "git", "init", testpath
    system "#{bin}/git-mit-install"
    output = Utils.popen_read("#{bin}/git-mit-config", "mit", "example")
    (testpath/"git-mit.toml").write output
    system "#{bin}/git-mit", "-c", "git-mit.toml", "se"
    system "git-mit-relates-to", "#12356"
    system "git", "add", testpath
    system "git", "commit", "-m", "Exammple Commit"
    system "#{bin}/git-mit-config", "lint", "available"
  end
end
