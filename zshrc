# get brew to work
eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
export SHELL=/bin/zsh

export PATH="/opt/homebrew/opt/libpq/bin:/usr/local/texlive/2023/bin/universal-darwin:$PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

export OPENAI_API_KEY=$(cat ~/secret/openai.key)
export SSH_KEY_PATH="~/.ssh/rsa_id"

export PS1="%1~ %# "

source ~/.aliases

function rufftest() {
    # Build with all warnings enabled
    cargo clippy --workspace --all-targets --all-features -- -D warnings
    if [[ $? ]]
    then
        # Test and update ruff.schema.json
        RUFF_UPDATE_SCHEMA=1 cargo test;
    fi
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
