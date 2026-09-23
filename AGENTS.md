# AGENTS.md

Guidance for AI agents working in this repository.

## Purpose and scope

- This repo **is** `~/.config`: it tracks personal macOS configuration for the tools
  listed below. Every tracked path must map to a real config location under
  `~/.config`.
- Do not add files outside `~/.config` (no `$HOME` dotfiles, no symlink farm).
- This is configuration, not application code. Prefer minimal edits to the relevant
  config file over adding scripts or tooling to the repo root.

## Tool map

| Path | Tool | Notes |
| --- | --- | --- |
| `btop/btop.conf` | btop | `color_theme` is an absolute Cellar path; keep it working or use `~/.config/btop/themes/` |
| `gh-dash/config.yml` | gh CLI extension `dlvhdr/gh-dash` | YAML; validated by `gh dash` |
| `ghostty/config` | Ghostty terminal | key = value format |
| `herdr/config.toml` | herdr | TOML; runtime state is ignored; formula pinned on Intel macOS |
| `htop/htoprc` | htop | Rewritten by htop itself |
| `nvim/` | Neovim 0.12+ | See Neovim conventions below |
| `opencode/opencode.jsonc`, `opencode/tui.jsonc` | opencode | JSONC; validated by opencode |
| `starship.toml` | Starship prompt | Shell hook lives in `~/.zshrc`, not here |
| `tmux/tmux.conf`, `tmux/scripts/` | tmux + TPM | Plugin list lives in `tmux.conf` |
| `Brewfile` | Homebrew | Full install list, used by `brew bundle` |

`README.md` has install steps and per-tool dependency details. Keep it in sync when
dependencies change.

## Guardrails

- **Never commit secrets.** Do not stage credentials, tokens, SSH material, or
  runtime state. Sensitive locations include `iterm2/sockets/secrets`,
  `~/.local/share/opencode/auth.json`, and anything in `gh` auth.
- **Never remove these ignores** from `.gitignore`: `tmux/plugins/`, `node_modules/`,
  `herdr/*.log`, `herdr/session.json`, `herdr/.plugins.lock`, `configstore/`,
  `iterm2/`, `mole/`.
- Do not commit `node_modules` or vendor plugin sources. tmux plugins are reinstalled
  by TPM; Neovim plugins by `vim.pack`.
- Do not run installers or intrusive commands (`brew bundle`, `tpm` install,
  `herdr update`, `gh extension install`) unless explicitly asked.
- Do not upgrade `herdr` on Intel macOS unless explicitly asked: no Homebrew bottles
  exist for this Tier 3 config, so `brew upgrade herdr` source-builds LLVM/Zig/Rust
  for hours. It is pinned (`brew pin herdr`); treat `brew unpin` as a deliberate action.
- Do not modify `~/.zshrc` from this repo; it is out of scope.

## Conventions

- Theme: tokyo-night / storm palette (colors `#1a1b26`, `#7aa2f7`, `#414868`, etc.)
  across Ghostty, tmux, btop, and Neovim. Match existing colors when adding UI config.
- Neovim:
  - Plugin management uses the built-in `vim.pack` API, **not** lazy.nvim. Add plugins
    in `nvim/init.lua`; revisions are pinned in `nvim-pack-lock.json` (do not hand-edit
    the lockfile).
  - LSP servers are configured natively in `nvim/lsp/<name>.lua` with `vim.lsp.config`
    (`cmd`, `filetypes`, `root_markers`, `settings`). Do not introduce a plugin-based
    LSP installer.
  - Formatting goes through `conform.nvim` in `nvim/lua/plugins/format.lua`.
  - Lua style: tabs/spaces per `nvim/stylua.toml`; run `stylua` before committing.
  - Plugin modules live in `nvim/lua/plugins/`; lazy-loading is wired in
    `nvim/lua/autocmds.lua` and `nvim/lua/keymaps.lua`.
- tmux: keep explanatory comments for non-obvious bindings/options; add new plugins to
  the `@plugin` list at the bottom of `tmux/tmux.conf` and reinstall via TPM.
- Keep edits ASCII unless the file already uses glyphs (tmux/tmux.conf does).

## Verification

Run the applicable checks before finishing:

```sh
git status --short                      # expect only intended changes
stylua --check nvim                     # Lua formatting
nvim --headless "+checkhealth" +q       # Neovim config loads
tmux -f tmux/tmux.conf new-session -d -s cfgcheck && tmux kill-session -t cfgcheck
opencode --version                      # if opencode config changed
gh dash                                 # if gh-dash config changed (needs auth)
starship --version                      # if starship.toml changed
```

`git status` must not show `tmux/plugins/`, `node_modules/`, or log/session files.

## Commits

- Use Conventional Commits, imperative mood, single line, e.g.
  `docs: add onboarding documentation and Brewfile`.
- Do not commit or push unless explicitly asked.
