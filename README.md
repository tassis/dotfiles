# dotfiles

This repository is my personal chezmoi source directory. It is mainly used for:

- base system bootstrap
- shell environment setup
- mise-managed tool versions
- terminal / workspace configuration
- optional manual installation scripts

## Structure

```text
.
├── .chezmoiignore
├── autostart/
├── dot_config/
│   ├── mise/
│   ├── tassis/
│   ├── wezterm/
│   └── zellij/
├── dot_default-go-packages
├── executable_labenv
├── private_dot_local/
└── scripts/
```

## Important directories

### `autostart/`

Contains chezmoi lifecycle scripts. These are executed automatically during `chezmoi apply`.

Current order:

1. `run_once_before_000-install-base-dependencies.sh.tmpl`
   - Installs base dependencies such as `curl`, `git`, `gnupg`, `unzip`, `wget`, and `xz`.
   - Supports common Linux package managers and Homebrew on macOS.

2. `run_once_before_100-install-mise.sh.tmpl`
   - Installs mise if it is not already available.
   - On Linux, it installs via `curl https://mise.run` to `~/.local/bin/mise` by default.
   - On macOS, it prefers Homebrew.

3. `run_onchange_after_200-mise-install-tools.sh.tmpl`
   - Re-runs when `dot_config/mise/config.toml` changes.
   - Runs `mise install --yes` to install or update tools.

4. `run_after_300-ensure-tassis-env-source.sh.tmpl`
   - Ensures shell rc files source `~/.config/tassis/env.sh`.
   - Always handles `~/.zshrc`.
   - Only handles `~/.bashrc` if it already exists, so bash config is not created unnecessarily.
   - Uses `~/.local/state/tassis/ensure-env-source.done` to avoid repeated modifications.

### `dot_config/tassis/`

Personal shell environment configuration.

- `env.sh`
  - PATH helper functions
  - `~/bin`, `~/.local/bin`, and `~/go/bin`
  - `EDITOR` / `PAGER`
  - common aliases
  - mise / zoxide / fzf initialization
  - local override loading via `~/.config/tassis/local.sh`

- `local.sh.example`
  - Template for machine-specific local settings.
  - The real `~/.config/tassis/local.sh` is not tracked and is excluded by `.chezmoiignore`.

### `dot_config/mise/`

mise configuration.

- `config.toml`
  - Manages Go, Rust, Node, Bun, and common CLI tools.
  - Changes to this file trigger `autostart/run_onchange_after_200-mise-install-tools.sh.tmpl`.

### `dot_config/wezterm/`

WezTerm configuration. It is split into multiple Lua files for easier maintenance of keybindings, the bar, helpers, and related settings.

### `dot_config/zellij/`

Zellij configuration, layouts, and plugins.

Note: `config.kdl.bak` is intentionally kept as a temporary backup for now.

### `scripts/`

Contains optional, manually executed installation scripts.

This directory is intentionally separate from `autostart/`:

- `autostart/`: part of the chezmoi apply lifecycle; runs automatically.
- `scripts/`: optional installation, one-off operations, or workflows that should not run automatically.

The directory is currently kept with `.gitkeep`.

Suggested naming for future scripts:

```text
scripts/install-optional-xxx.sh
scripts/setup-optional-yyy.sh
```

## chezmoi naming conventions

This repository currently uses:

- `dot_`: deploy as a dotfile, e.g. `dot_config` → `~/.config`
- `private_`: deploy as private, e.g. `private_dot_local` → `~/.local`
- `executable_`: deploy with the executable bit set
- `*.tmpl`: chezmoi template
- `run_once_before_*`: run once before apply
- `run_onchange_after_*`: run after apply when content changes
- `run_after_*`: run after apply

## Local overrides

Machine-specific settings should go in:

```text
~/.config/tassis/local.sh
```

This file is not tracked by the repository.

The example file is:

```text
dot_config/tassis/local.sh.example
```

## Maintenance notes

- Put automatic first-run or every-apply workflows in `autostart/`.
- Put optional installation or manual helper scripts in `scripts/`.
- After changing `dot_config/mise/config.toml`, the next `chezmoi apply` will run `mise install --yes` automatically.
- If `dot_config/tassis/env.sh` grows too large, split it into files such as `path.sh`, `aliases.sh`, and `tools.sh`.
- `.bak` files are currently allowed as temporary backups.

## Common commands

```sh
chezmoi diff
chezmoi apply
chezmoi status
```
