class Ym < Formula
  desc "Bootstrap spec-driven development projects with AI agent roles"
  homepage "https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt"
  license "MIT"

  # Stable release — update url and sha256 after tagging a release:
  #   git tag v0.1.0 && git push origin v0.1.0
  #   curl -fsSL https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt/archive/refs/tags/v0.1.0.tar.gz | sha256sum
  #
  # url "https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt/archive/refs/tags/v0.1.0.tar.gz"
  # sha256 "<fill after tagging>"

  # HEAD install (current main branch):
  #   brew install --HEAD ym
  head "https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt.git", branch: "main"

  def install
    bin.install "bin/ym"
  end

  test do
    assert_match "ym", shell_output("#{bin}/ym --version")
  end
end
