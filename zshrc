# get brew to work
eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
export SHELL=/bin/zsh

export PATH="/usr/local/texlive/2023/bin/universal-darwin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/lib"

export OPENAI_API_KEY=$(cat ~/.secret/openai.key)
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Prompt
# git (ref https://sampo.website/blog/en/2021/zsh/)
autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
# %b = branch, %u = unstaged changes
zstyle ':vcs_info:git:*' formats '%F{green}(%b%u)%f '
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true # make %u work (there is a perf hit)
zstyle ':vcs_info:*' unstagedstr '•'
# %B/%b - begin bold/end bold
# %F{12}/%f - begin color 12/end color
# %1~ - last 1 directory, abbreviating home as ~
# %(!.#.>) - # if superuser, > if not
PROMPT='%B%F{blue}%2~%f ${vcs_info_msg_0_}%F{blue}%(!.#.>)%f %b'

# Fzf
export FZF_CTRL_T_COMMAND='command cat <(fre --sorted) <(fd -t d) <(fd -t d . ~/code) <(fd -t d . ~/tools) <(fd -t d . ~/docs)'
export FZF_CTRL_T_OPTS='--tiebreak=index'

# History (unlimited)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
# Overwrite duplicate commands
setopt hist_ignore_all_dups
# Do not record commands that start with a space in history
setopt hist_ignore_space

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
