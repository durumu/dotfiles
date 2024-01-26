# Note to self: this file is executed even on non-interactive shells
# Don't modify the behavior of default commands here, or you'll break scripts.
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
export SHELL=/bin/zsh

export PATH="/usr/local/texlive/2023/bin/universal-darwin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

. "$HOME/.cargo/env"
