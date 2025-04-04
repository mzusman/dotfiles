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
setopt share_history


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
# if [ -z $(brew list | grep jetbrains) ]; then
    # brew install font-jetbrains-mono-nerd-font
# fi
# if [ -z $(brew list | grep tmux-xpanes) ]; then
    # brew install tmux-xpanes
# fi
# if [ -z $(brew list | grep stern) ]; then
    # brew install stern
# fi
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if [ -f ~/.ai21_zshrc ]; then
    source ~/.ai21_zshrc
fi
alias vim="nvim"
# alias python="python3.11"
# alias pip="python3.11 -m pip"
alias gcp="gsutil -m cp -r "
alias gmv="gsutil -m mv "
alias grm="gsutil -m rm -r "
alias krsync="sh ~/.config/nvim/configs/krsync.sh"
alias krsynca="sh ~/.config/nvim/configs/krsynca.sh"
alias gcat="gsutil cat "
alias cls="ai21 kubectl-clusters --all"
alias viz="vim ~/.zshrc"
alias apply="source ~/.zshrc"
alias w="watch -n 0.5"
alias -g vast="/Users/morzusman/projects/vast/vast"
alias k="kubectl"
alias pip="uv pip"

export SOFA_ROOT="/Users/morzusman/projects/sofa_build/build/v23.06"
export PYTHONPATH="/Users/morzusman/projects/sofa_build/build/v23.06/lib/python3/site-packages":$PYTHONPATH
export PATH="/Users/morzusman/go/bin:$PATH"

kkcp(){
    DIR=$1
    PATTERN=$2
    export POD=`pod | awk '{print $1}'`;kubectl exec $POD -- ls $DIR | grep $PATTERN  | xargs -P 8 -I + kubectl cp default/$POD:$DIR/+ +
}


ktcp(){
    INPATH=$1
    OUTPATH=$2
    POD=`pod | awk '{print $1}'`
    echo "kubectl cp $INPATH default/$POD:$OUTPATH"
    kubectl cp $INPATH default/$POD:$OUTPATH
}

kcp(){
    DIR=$1
    PATTERN=$2
    export POD=`pod | awk '{print $1}'`;kubectl exec $POD -- ls $1 | grep $PATTERN  | xargs -P 8 -I + kubectl cp default/$POD:/app/+ +
}

ghp(){
    git log $1 --pretty=oneline | _fzfm | awk '{print $1}' | tac | xargs git cherry-pick
}

_fzf(){
    fzf --bind 'ctrl-r:reload('$FZF_COMMAND')' --layout=reverse
}

_fzfm(){
    fzf -m --bind 'ctrl-r:reload('$FZF_COMMAND')' --layout=reverse
}

jobs(){
    export FZF_COMMAND='kubectl get jobs  --no-headers -o custom-columns=":metadata.name"' 
    eval $FZF_COMMAND | _fzfm
}

wdeps(){
    export FZF_COMMAND='kubectl get deployments  --no-headers -o wide --show-labels' 
    eval $FZF_COMMAND | _fzfm
}


wjobs(){
    export FZF_COMMAND='kubectl get jobs  --no-headers -o wide --show-labels' 
    eval $FZF_COMMAND | _fzfm
}

auto(){
    python ~/.config/nvim/configs/auto-refresh.py $1
}

wjob(){kubectl get jobs --no-headers -o wide | fzf | awk '{print $2}' | xargs -I A kubectl describe job.batch/A}
wjob2(){FZF_COMMAND='kubectl get jobs  --no-headers -o wide' fzf }
job(){kubectl get jobs  --no-headers -o custom-columns=":metadata.name" | fzf }

pods(){kubectl get pods  --no-headers -o custom-columns=":metadata.name" | fzf -m }
wpod(){kubectl get pods  --no-headers -o wide | fzf | awk '{print $1}' | xargs kubectl describe pod }

wpods2(){
    export FZF_COMMAND='kubectl get pods --no-headers -o wide' 
    eval $FZF_COMMAND | _fzfm
}

wpod2(){
    export FZF_COMMAND='kubectl get pods --no-headers -o wide' 
    eval $FZF_COMMAND | _fzf
}

wpod2a(){export FZF_COMMAND='kubectl get pods --all-namespaces --no-headers -o wide'
eval $FZF_COMMAND | _fzf }

wpods(){export FZF_COMMAND='kubectl get pods --no-headers -o wide' 
    eval $FZF_COMMAND | _fzfm}
pod(){
    export FZF_COMMAND='kubectl get pods --no-headers -o wide' 
    eval $FZF_COMMAND | _fzfm
}

poda(){kubectl get pods --all-namespaces --no-headers -o custom-columns=":metadata.name" | fzf }

wnode(){kubectl get nodes --no-headers -o wide | fzf | awk '{print $2}' | xargs -I A kubectl describe node/A}
wnode2(){export FZF_COMMAND='kubectl get pods --no-headers -o wide'
eval $FZF_COMMAND | _fzf }
wnodes(){kubectl get nodes --no-headers -o wide | fzf -m}
node(){kubectl get nodes --no-headers -o custom-columns=":metadata.name" | fzf }

wpod2a(){export FZF_COMMAND='kubectl get pods --all-namespaces --no-headers -o wide'
eval $FZF_COMMAND | _fzf }

portfa(){
    POD=$(wpod2a)
    name=`echo $POD | awk '{print $2}'`
    namespace=`echo $POD | awk '{print $1}'`
    echo "Forwarding $1 to $2 , pod: $name"
kubectl port-forward -n $namespace $name $1:$2 }

portf(){
    POD=$(wpod2)
    name=`echo $POD | awk '{print $1}'`
    echo "Forwarding $1 to $2 , pod: $name"
while true; do kubectl port-forward $name $1:$2; done; }

jlogs(){
    JOB=$(wjob2)
    # namespace=`echo $JOB | awk '{print $1}'`
    name=`echo $JOB | awk '{print $1}'`
    while true; do sleep 2;kubectl logs job.batch/$name | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")';done
}

logs(){
    POD=$(wpod2)
    name=`echo $POD | awk '{print $1}'`
    while true; do sleep 2;kubectl logs $name --timestamps=true | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")';done
}

xlogs(){
    xpanes -B "while true; do kubectl logs -f --tail=100 {}; done;" `pods`
}

jlogs(){
    xpanes -B "while true; do kubectl logs -f --tail=100 job/{}; done;" `jobs`
}


flogs(){
    POD=$(wpod2)
    name=`echo $POD | awk '{print $1}'`
    while true; do kubectl logs -f --tail=100 $name $1 | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")';done
}

slogs(){
    PODS=$(wpods2)
    names=`echo $PODS | awk '{print $1}' `
    prefix=`echo $names | sed -e '$q;N;s/^\(.*\).*\n\1.*$/\1/;h;G;D'`
    while true; do sleep 2;stern  $prefix --no-follow;done;
    # kubectl logs -f $name $1 | tee >(grep -v "eventTime") | grep "^{" | jq -r '[.eventTime , .severity , .message] | join(" | ")'
}

dpod(){kubectl delete pod `pod $1`}
djob(){kubectl delete job `job $1`}
djobs(){wjobs $1 | awk '{print $1}' | xargs kubectl delete job }
ddeps(){wdeps $1 | awk '{print $1}' | xargs kubectl delete deployment }
dpods(){pods $1 | xargs kubectl delete pod }
dpod(){pods $1 | xargs kubectl delete pod }
h(){history | grep $1 | tail -10}
vol(){osascript -e "set Volume $1"}
pclean(){pip uninstall -y -r <(pip freeze)}

ksc(){
    SESSION="${1:-debug}"
    POD=$(wpod2a)
    name=`echo $POD | awk '{print $2}'`
    while true; do kubectl exec -it $name -- env COLUMNS=$COLUMNS LINES=$LINES screen -D -R -S $SESSION; done
    # echo "Connecting to $1"
    # kubectl exec -it `pod` --container $1 env COLUMNS=$COLUMNS LINES=$LINES tmux -c /bin/bash
}

xsc(){
    SESSION="${1:-debug}"
    xpanes -d -B "while true; do kubectl exec -it {} -- env COLUMNS=$COLUMNS LINES=$LINES screen -D -R -S $SESSION; done" `pods`
    # echo "Connecting to $1"
    # kubectl exec -it `pod` --container $1 env COLUMNS=$COLUMNS LINES=$LINES tmux -c /bin/bash
}

xssh(){
    SESSION="${1:-debug}"
    xpanes -d -B "kubectl exec -it {} -- env COLUMNS=$COLUMNS LINES=$LINES /bin/bash" `pods`
    # echo "Connecting to $1"
    # kubectl exec -it `pod` --container $1 env COLUMNS=$COLUMNS LINES=$LINES tmux -c /bin/bash
}

kssh(){
    if [ -z "$1" ]
    then
        kubectl exec -it `pod` -- env COLUMNS=$COLUMNS LINES=$LINES /bin/bash
        return
    fi
    echo "Connecting to $1"
    kubectl exec -it `pod` --container $1 env COLUMNS=$COLUMNS LINES=$LINES /bin/bash
}

kssha(){
    POD=$(wpod2a)
    name=`echo $POD | awk '{print $2}'`
    ns=`echo $POD | awk '{print $1}'`
    kubectl exec --stdin --tty $name --namespace $ns -- /bin/bash
}
cssh(){portf $1 9999 22 &;sleep 10;ssh root@127.0.0.1 -p 9999}
mon(){clear;while $1 $2; do sleep 2;clear; done}

qq(){ while true; do clear; date; "$@" ; sleep 5; done; }
gsmkd(){mkdir /tmp/$1;touch /tmp/$1/dummy;gcp cp -r /tmp/$1 $2;rm -rf /tmp/$1}


_podsync(){
    echo "Syncing $1 to $2 , pod: $3"
    krsync -av --max-size=1mb --exclude={'*.git*','*mypy_cache*','*.pyc*','*venv*','*mlrun*','*ncu*','*nsys*','*MAC*','*zip*','data/','logs/'} $1 $3:$2
    # osascript -e 'display notification "Finished syncing with '$3'!" with title "Sync"'
}

_podsynca(){
    echo "Syncing $4 $1 to $2 , pod: $3"
    krsync -av --exclude={'*.git*','*.pyc*','*.venv*','*mlrun*','*ncu*','*nsys*'} $1 $3@$4:$2
    osascript -e 'display notification "Finished syncing with '$3'!" with title "Sync"'
}

vans(){
    GPU_RAM="${1:-20}"
    TYPE="--${2:-d}"
    export FZF_COMMAND="/Users/morzusman/projects/vast/vast search offers $TYPE 'reliability>0.99 gpu_ram>$(echo $GPU_RAM) num_gpus=1'"
    eval "$FZF_COMMAND" | _fzf
}

vala(){
    VANS=$(vans $1 $2)
    ID=`echo $VANS | awk '{print $1}'`
    PRICE=`echo $VANS | awk '{print $10}'`
    TYPE="${2:-d}"
    if [[ $TYPE == "i" ]]
    then
        PRICE_I=`python -c "print($PRICE + 0.01)"`
        echo "price for bidding $PRICE_I"
        /Users/morzusman/projects/vast/vast create instance $ID --price $PRICE_I --image pytorch/pytorch --disk 50 --onstart-cmd "touch ~/.no_auto_tmux; apt install -y unzip"
    else
        /Users/morzusman/projects/vast/vast create instance $ID --image pytorch/pytorch --disk 50 --onstart-cmd "touch ~/.no_auto_tmux; apt install -y unzip"
    fi
}

dva(){
    ID=$(vali | awk '{print $1}')
    /Users/morzusman/projects/vast/vast destroy instance $ID
}

vali(){
    export FZF_COMMAND="/Users/morzusman/projects/vast/vast show instances"
    eval $FZF_COMMAND | _fzf
}

vsshl(){
    ID=$(vali | awk '{print $1}')
    /Users/morzusman/projects/vast/vast ssh-url $ID
}

vssh(){
    URL=$(vsshl)
    ssh $URL
}

vsync(){
    ID=$(vali | awk '{print $1}')
    /Users/morzusman/projects/vast/vast copy . $ID:workspace/e$(basename $PWD)
    fswatch -e ".*" -i "\\.py$" -o $PWD/| while read f; do /Users/morzusman/projects/vast/vast copy . $ID:workspace/e$(basename $PWD); done;
}

vmlruns(){
    ID=$(vali | awk '{print $1}')
    while [ 1 ]; do
        /Users/morzusman/projects/vast/vast copy $ID:workspace/eendo/mlruns .
        sleep 5
    done
}
vdata(){
    /Users/morzusman/projects/vast/vast cloud copy --src /Archive.zip --dst /workspace/  --transfer "Cloud To Instance" --instance $(vali | awk '{print $1}') --connection $(/Users/morzusman/projects/vast/vast show connections | tail -1 | awk '{print $1}')
}
vmsync(){
    VM=$1
    rsync -av --exclude 'venv*' --exclude '.git*' $PWD/ $VM:/home/morzusman/$(basename $PWD)
    fswatch -e ".*" -i "\\.py$" -o $PWD/| while read f; do rsync -av --exclude 'venv*' --exclude '.git*'  $VM:/home/morzusman/$(basename $PWD); done;
}

# podsync(){
#   POD=$(wpod2)
# 	name=`echo $POD | awk '{print $1}'`
#   _podsync $1 $2 $name
# }
#
podsynca(){
    POD=$(wpod2a)
    name=`echo $POD | awk '{print $2}'`
    ns=`echo $POD | awk '{print $1}'`
    ind=$1
    outd=$2
    _podsynca $ind $outd $name $ns
    fswatch -e ".*" -i "\\.py$" -o $1 | while read f; do _podsynca $ind $outd $name $ns; done;
}

locsync(){
    POD=$(wpod2)
    name=`echo $POD | awk '{print $1}'`
    ind=$1
    outd=$2
    k rsync $name:$ind $outd
    while true; do k rsync -- --exclude={"**echeckpoints/*"} -avr $name:$ind $outd; sleep 10; done;
}

kt(){
    REGEX='s/('$1'*-[a-z0-9\-]*)(.*)/\1/g'
    POD=`kubectl get pods | grep $1 | sed -E $REGEX`
    multitail -f --config $HOME/multitail.conf -CS $1 -l 'kubectl logs '$POD' -f'
}

ktail(){
    PODS=$(wpods2)
    names=`echo $PODS | awk '{print $1}' `
    # prefix=`echo $names | sed -e '$q;N;s/^\(.*\).*\n\1.*$/\1/;h;G;D'`

    # REGEX='s/('$1'*-[a-z0-9\-]*)(.*)/\1/g'
    multitail -f -CS $1 -l 'kubectl logs '$names' -f'
}

_podsync(){
    echo "Syncing $1 to $2 , pod: $3"
    krsync -av --max-size=1mb --exclude={'*.git*','*mypy_cache*','*.pyc*','*venv*','*mlrun*','*ncu*','*nsys*','*MAC*','*zip*','data/','logs/'} $1 $3:$2
    # osascript -e 'display notification "Finished syncing with '$3'!" with title "Sync"'
}

podsync(){
    POD=$(wpod2)
    name=`echo $POD | awk '{print $1}'`
    ind=$1
    outd=$2
    _podsync $ind $outd $name
    while true; do sleep 5; _podsync $ind $outd $name; done;
}

xpodsync1(){
    ind=$1
    outd=$2
    xpanes -B "_podsync $ind $outd {}" `pods`
}

xpodsync(){
    ind=$1
    outd=$2
    xpanes -B "while true; do sleep 5; _podsync $ind $outd {}; done;" `pods`
}

set rtp+=/opt/homebrew/opt/fzf

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

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

export PATH="/Users/morzusman/.config/nvim/k8s_scripts/:/Users/morzusman/.local/bin:/opt/homebrew/opt/qt@5/bin:/Users/morzusman/projects/vast/vast:$PATH"

# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v brew &> /dev/null; then
    eval "$(brew shellenv)"
fi


bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

export SOFA_ROOT=/Users/morzusman/projects/sofa/build
export SOFAPYTHON3_ROOT=/Users/morzusman/projects/sofa/build/plugins/SofaPython3

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/morzusman/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/morzusman/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/morzusman/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/morzusman/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

source ~/.ai21_zshrc

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/morzusman/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
