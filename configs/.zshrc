# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3.11

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/.ai21_zshrc
alias vim=nvim
alias vim="nvim"
alias gcp="gsutil -m cp -r "
alias gmv="gsutil -m mv "
alias grm="gsutil -m rm -r "
alias gcat="gsutil cat "
alias cls="ai21 kubectl-clusters --all"
alias viz="vim ~/.zshrc"
alias apply="source ~/.zshrc"
alias cb="pbcopy"
alias w="watch -n 0.5"
_fzf(){
  fzf --bind 'ctrl-r:reload('$FZF_COMMAND')' --header 'Press CTRL-R to reload' \
             --header-lines=1 --layout=reverse
}
_fzfm(){
  fzf -m --bind 'ctrl-r:reload('$FZF_COMMAND')' --header 'Press CTRL-R to reload' \
             --header-lines=1 --layout=reverse
}

jobs(){
  export FZF_COMMAND='kubectl get jobs -A --no-headers -o custom-columns=":metadata.name"' 
  _fzfm}
wjobs(){
  export FZF_COMMAND='kubectl get jobs -A --no-headers -o wide'
  kubectl get jobs -A --no-headers -o wide | _fzfm}
wjob(){kubectl get jobs -A --no-headers -o wide | fzf | awk '{print $2}' | xargs -I A kubectl describe job.batch/A}
wjob2(){FZF_COMMAND='kubectl get jobs -A --no-headers -o wide' fzf }
job(){kubectl get jobs -A --no-headers -o custom-columns=":metadata.name" | fzf }

pods(){kubectl get pods -A --no-headers -o custom-columns=":metadata.name" | fzf -m }
wpod(){kubectl get pods -A --no-headers -o wide | fzf | awk '{print $2}' | xargs -I A kubectl describe pod/A}
wpod2(){export FZF_COMMAND='kubectl get pods -A --no-headers -o wide' 
  kubectl get pods -A --no-headers -o wide | _fzf }
wpods(){kubectl get pods -A --no-headers -o wide | fzf -m}
pod(){kubectl get pods -A --no-headers -o custom-columns=":metadata.name" | fzf }

portf(){POD=$(wpod2)
	namespace=`echo $POD | awk '{print $1}'`
	name=`echo $POD | awk '{print $2}'`
	kubectl port-forward $name --namespace=$namespace $1:$2 }

jlogs(){
	JOB=$(wjob2)
	namespace=`echo $JOB | awk '{print $1}'`
	name=`echo $JOB | awk '{print $2}'`
	kubectl logs job.batch/$name --namespace=$namespace | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")'
}

logs(){
	POD=$(wpod2)
	namespace=`echo $POD | awk '{print $1}'`
	name=`echo $POD | awk '{print $2}'`
	kubectl logs $name --namespace=$namespace | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")'
}

flogs(){ 
	POD=$(wpod2)
	namespace=`echo $POD | awk '{print $1}'`
	name=`echo $POD | awk '{print $2}'`
	kubectl logs -f $name --namespace=$namespace $1 | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")'
	}
dpod(){kubectl delete pod -A `pod $1`}
djob(){kubectl delete job `job $1`}
djobs(){wjobs $1 | awk '{print $2}' | xargs kubectl delete job }
dpods(){pods $1 | xargs kubectl delete pod }
dpod(){pods $1 | xargs kubectl delete pod }
h(){history | grep $1 | tail -10}
vol(){osascript -e "set Volume $1"}
pclean(){pip uninstall -y -r <(pip freeze)}
kssh(){kubectl exec --stdin --tty `pod $1` -- /bin/bash}
cssh(){portf $1 9999 22 &;sleep 10;ssh root@127.0.0.1 -p 9999}
mon(){clear;while $1 $2; do sleep 2;clear; done}
qq(){ while true; do clear; date; "$@" ; sleep 5; done; }
gsmkd(){mkdir /tmp/$1;touch /tmp/$1/dummy;gcp cp -r /tmp/$1 $2;rm -rf /tmp/$1}

set rtp+=/opt/homebrew/opt/fzf

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/morzusman/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/morzusman/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/morzusman/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/morzusman/google-cloud-sdk/completion.zsh.inc'; fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

