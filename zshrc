zmodload zsh/zprof

# openjdk and ruby are already installed on macos
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export PATH="$HOME/.gem/ruby/3.3.0/bin:$PATH"

# get brew to work
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR=$(which nvim)

export OPENAI_API_KEY=$(cat ~/.secret/openai.key)
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

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

# Tab completion (taken from https://forge.daemonica.net/dgoerger/dotfiles)
# disable fuzzy match
zstyle ':completion:*' accept-exact-dirs true
# case-sensitive
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
# smaller 'cd' tab-completion array
zstyle ':completion:*:cd:*' tag-order local-directories
zstyle ':completion:*' use-cache yes
autoload -Uz compinit

compinit -i -D

# Fzf
export FZF_CTRL_T_COMMAND="command cat <(fre --sorted) <(fd -t d) <(fd -t d . $HOME/code) <(fd -t d . $HOME/tools) <(fd -t d . $HOME/docs)"
export FZF_CTRL_T_OPTS='--tiebreak=index'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


## history
setopt HIST_EXPIRE_DUPS_FIRST  # Remove older duplicate entries from history first when trimming the history list to fit within `HISTSIZE`.
setopt HIST_IGNORE_DUPS        # Do not enter command lines into the history list if they are duplicates of the previous command.
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks from each command line being added to the history list.
setopt INC_APPEND_HISTORY      # Append each command to the history file as it is executed, rather than waiting until the shell exits.
setopt HIST_IGNORE_SPACE       # Commands starting with a space character are not entered into the history list.

# History (unlimited)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

source "$HOME/.aliases"
