export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export FZF_DEFAULT_OPTS='--layout=reverse --cycle --color=16'

fpath=(
  /opt/homebrew/share/zsh/site-functions/
  $fpath
)

path=(
  $HOME/bin(N-/)
  /opt/homebrew/Cellar/openjdk/15.0.2/bin(N-/)
  /opt/homebrew/bin(N-/)
  /usr/local/sbin
  /usr/local/bin
  /usr/sbin
  /usr/bin
  /sbin
  /bin
)

alias vi='vim'
alias grep='grep --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias rake='noglob rake'
alias history='history -r -i 1 L'
alias diff='diff -u'
alias tree='tree --dirsfirst -N -C -I "__*|.git"'

alias -g L='| less -R'
alias -g V='| vim -R -'
alias -g JSON='| python -m json.tool --no-ensure-ascii'
alias -g BQ='| bq query --nouse_legacy_sql'
alias -g GIST='| gh gist create -w -'

# GNU
alias ls='gls --color'
alias date='gdate'
alias sed='gsed'
alias zcat='gzcat'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

autoload -U +X compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1

autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%u%c %b'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '-'


# hook functions
chpwd() {
  ls
}

preexec() {
  timer=$SECONDS
}

precmd() {
  if [ $timer ]; then
    elapsed_time="$(($SECONDS - $timer))sec"
    unset timer
  fi
  psvar=()
  vcs_info
  [[ -n $vcs_info_msg_0_ ]] && print -v 'psvar[1]' -Pr -- "$vcs_info_msg_0_"
}


PROMPT='%(?,%F{green},%F{red})%#%f '
RPROMPT='%(1v.%F{yellow}%1v%f.) %F{cyan}%~%f %F{white}${elapsed_time}%f'

HISTFILE=$HOME/.zsh_history
HISTSIZE=65536
SAVEHIST=$HISTSIZE

setopt append_history
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt bang_hist
setopt case_glob
setopt extended_glob
setopt extended_history
setopt hist_allow_clobber
setopt hist_ignore_dups
setopt hist_no_functions
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt ignore_eof
setopt inc_append_history
setopt list_packed
setopt magic_equal_subst
setopt mark_dirs
setopt numeric_glob_sort
setopt print_eight_bit
setopt prompt_subst
setopt share_history
setopt transient_rprompt

setopt no_beep
setopt no_flow_control
setopt no_hist_beep
setopt no_hup
setopt no_list_beep


# key binding
bindkey -e
bindkey '^A' backward-word
bindkey '^E' forward-word
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey '^J' self-insert

ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N ctrl-z
bindkey '^Z' ctrl-z

fzf-history() {
  local hist_id=$(history | fzf --no-sort | awk '{print $1}' | sed -e 's/[^0-9]//g')
  if [ -n "$hist_id" ]; then
    BUFFER="!${hist_id}"
    zle accept-line
  fi
}
zle -N fzf-history
bindkey '^R' fzf-history

fzf-src() {
  local repo_dir=$(ghq list --full-path | sort | fzf)
  if [ -n "$repo_dir" ]; then
    BUFFER="cd ${repo_dir}"
    zle accept-line
  fi
}
zle -N fzf-src
bindkey '^\' fzf-src


# source files
source_files=(
  $HOME/.zshrc.local
  /opt/homebrew/opt/asdf/asdf.sh
  /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
)
for file in ${source_files[@]}; do [[ -f $file ]] && source $file; done

if which kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi


# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"


# golang
export GOPATH=$HOME
export GGO111MODULE=on


# Zinit
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma/fast-syntax-highlighting


# start tmux
function() {
  local session_name=$(hostname | cut -d. -f1)
  if which tmux > /dev/null 2>&1 && [[ -z "$TMUX" ]]; then
    if tmux has-session -t $session_name; then
      tmux attach -d -t $session_name
    else
      tmux new -s $session_name
    fi
  fi
}
