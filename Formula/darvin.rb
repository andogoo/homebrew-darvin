class Darvin < Formula
  desc "Personal AI assistant kernel — local-first, multi-CLI, scheduled"
  homepage "https://github.com/andogoo/darvin-core"
  url "https://github.com/andogoo/darvin-core/releases/download/v0.1.1/darvin-v0.1.1.tar.gz"
  sha256 "25430bf245ae947faf7835a3ef0f9c8a1b52158180c6fa2e186a2f081f96e86f"
  version "0.1.1"
  license "AGPL-3.0-or-later"

  depends_on "node@20"
  depends_on "tmux"
  depends_on "git"

  def install
    libexec.install Dir["*"]

    (bin/"darvin").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      cd "#{libexec}"
      exec "#{Formula["node@20"].opt_bin}/node" "packages/installer/dist/index.js" "$@"
    SH
    chmod 0755, bin/"darvin"

    bash_completion.install libexec/"packaging/completions/darvin.bash" if (libexec/"packaging/completions/darvin.bash").exist?
    zsh_completion.install libexec/"packaging/completions/_darvin" if (libexec/"packaging/completions/_darvin").exist?
  end

  def caveats
    <<~CAVEATS
      Дарвин е инсталиран. За да завършиш настройката:

          darvin setup

      Това ще открие кои AI CLI-и имаш (Claude Code, Codex, Gemini),
      ще ти помогне да се логнеш в тях и ще избере локален модел
      (Ollama / LM Studio / MLX).

      След setup, стартирай:

          darvin start

      Уеб таблото ще е на http://127.0.0.1:7420

      За проверка по всяко време:

          darvin doctor
    CAVEATS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/darvin --help")
  end
end
