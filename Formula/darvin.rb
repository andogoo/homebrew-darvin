class Darvin < Formula
  desc "Personal AI assistant kernel — local-first, multi-CLI, scheduled"
  homepage "https://github.com/andogoo/darvin-core"
  url "https://github.com/andogoo/darvin-core/releases/download/v0.1.24/darvin-v0.1.24.tar.gz"
  sha256 "5dd3ad37b2993948662c1aa33cff1cb66ce2d39ddaf9154663533237ff93e61f"
  version "0.1.24"
  license "AGPL-3.0-or-later"

  depends_on "node"
  depends_on "tmux"
  depends_on "git"

  def install
    libexec.install Dir["*"]

    node_bin = Formula["node"].opt_bin
    (bin/"darvin").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      # Expose the brew-linked node + npm to darvin AND to any subprocess
      # it spawns (e.g. `npm install -g @anthropic-ai/claude-code` inside setup).
      export PATH="#{node_bin}:$PATH"
      cd "#{libexec}"
      exec "#{node_bin}/node" "packages/installer/dist-bundle/index.js" "$@"
    SH
    chmod 0755, bin/"darvin"

    bash_completion.install libexec/"packaging/completions/darvin.bash" if (libexec/"packaging/completions/darvin.bash").exist?
    zsh_completion.install libexec/"packaging/completions/_darvin" if (libexec/"packaging/completions/_darvin").exist?
  end

  def caveats
    <<~CAVEATS
      Дарвин е инсталиран. За да завършиш настройката:

          darvin init

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
