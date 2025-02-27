# openjdk and ruby are already installed on macos
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export PATH="$HOME/.gem/ruby/3.3.0/bin:$PATH"

# get brew to work
eval "$(/opt/homebrew/bin/brew shellenv)"

export EDITOR=$(which nvim)
bindkey -e # Even though I use vim, I prefer emacs keybinds for the terminal.

export ANTHROPIC_API_KEY=$(cat < ~/.secret/anthropic.key)
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

# Fzf
export FZF_CTRL_T_COMMAND="command cat <(fre --sorted) <(fd) <(fd . $HOME/code) <(fd . $HOME/tools) <(fd . $HOME/docs)"
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

# Starship
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/presley/.lmstudio/bin"

# Added by Windsurf
export PATH="/Users/presley/.codeium/windsurf/bin:$PATH"

export PLAYDATE_SDK_PATH="/Users/presley/Developer/PlaydateSDK"
