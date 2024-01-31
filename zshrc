zmodload zsh/zprof

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

# Autocomplete
autoload -Uz compinit
compinit -C

# Fzf
export FZF_CTRL_T_COMMAND='command cat <(fre --sorted) <(fd -t d) <(fd -t d . ~/code) <(fd -t d . ~/tools) <(fd -t d . ~/docs)'
export FZF_CTRL_T_OPTS='--tiebreak=index'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh


# History (unlimited)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
# Overwrite duplicate commands
setopt hist_ignore_all_dups
# Do not record commands that start with a space in history
setopt hist_ignore_space

source ~/.aliases
