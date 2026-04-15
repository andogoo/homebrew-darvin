class Darvin < Formula
  desc "Personal AI assistant kernel — local-first, multi-CLI, scheduled"
  homepage "https://github.com/andogoo/darvin-core"
  url "https://github.com/andogoo/darvin-core/releases/download/v0.1.0/darvin-v0.1.0.tar.gz"
  sha256 "e65888ee18e1edcb8704f68bfa731a1c92c99d6733f2c95da82857bc4bd2506a"
  version "0.1.0"
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
