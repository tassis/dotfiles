# ~/.config/tassis/env.sh
# managed by chezmoi

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_append() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

# user local binaries
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

# Go binaries installed by go install
path_append "$HOME/go/bin"

export PATH

# common env
export EDITOR="${EDITOR:-nvim}"
export PAGER="${PAGER:-less}"

alias nv="nvim"

# mise
if command -v mise >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(mise activate zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(mise activate bash)"
  fi
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    eval "$(zoxide init zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(zoxide init bash)"
  fi
  alias cd="z"
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ]; then
    source <(fzf --zsh)
  elif [ -n "${BASH_VERSION:-}" ]; then
    eval "$(fzf --bash)"
  fi
fi

# local machine-specific override
if [ -f "$HOME/.config/tassis/local.sh" ]; then
  . "$HOME/.config/tassis/local.sh"
fi
