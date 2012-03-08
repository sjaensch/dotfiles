# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME_PREFIX_ROOT=1
ZSH_THEME_USE_RPROMPT=1
ZSH_THEME="miloshadzic" 

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Enable colors in ls
DISABLE_LS_COLORS="false"

# Disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(npm brew bundler git-flow osx vagrant fabric gem pip redis-cli rbenv python nyan gnu-utils extract)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

if [ -f "$(command -v awsenv 2> /dev/null)" ]; then
    eval "$(awsenv init -)"
fi

if [ -f $HOME/.pythonbrew/etc/bashrc ]; then
    source $HOME/.pythonbrew/etc/bashrc
fi

export PIP_VIRTUALENV_BASE=$WORKON_HOME
# export PIP_REQUIRE_VIRTUALENV=true TODO Reactivate this?
export PIP_RESPECT_VIRTUALENV=true
if [ -f "$(command -v virtualenvwrapper.sh 2> /dev/null)" ]; then
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
    source "$(command -v virtualenvwrapper.sh)" 
fi

function scm_update {
    for dir in $(find . -type d -maxdepth 1 -not -wholename '.'); do 
        echo "\e[0;32m>>>> Checking $dir \e[0m"
        (
            cd $dir \
            && ([ -d .git ] \
                || echo "\e[0;31mNot a valid git repository \e[0m" \
                && [ -d .git ] ) \
            && echo "\e[0;34mRunning git pull \e[0m" \
            && git pull --all --recurse-submodules \
            && ([ -f .gitmodules ] \
                && echo "\e[0;34mRunning git submodule update \e[0m" \
                && git submodule update --recursive )
        )
        echo ""
    done
    cd "$PWD"
}

function terminate_vm {
    VBoxManage list vms \
        | grep $(basename $(pwd)) \
        | cut -d' ' -f1 \
        | xargs -I '{}' VBoxManage controlvm '{}' poweroff 2> /dev/null
}

# TODO: Move this into own zsh-plugin
function cd() {
    builtin cd "$@";
    echo "$PWD" >! $HOME/.zsh_cwd;
}
export cd

alias cwd='cd "$(cat $HOME/.zsh_cwd)"'
if [ -e $HOME/.zsh_cwd ]; then
    cwd
fi

alias l='ls -lh'
alias la='ls -lhA'
alias json_pp='python -mjson.tool'

# Speed up git completion
# http://talkings.org/post/5236392664/zsh-and-slow-git-completion
__git_files () {
    _wanted files expl 'local files' _files
}

# Disable autocorrect complete
unsetopt correct_all

# Fix alt-left and alt-right in Terminal.app
bindkey "\e[1;9D" backward-word
bindkey "\e[1;9C" forward-word

# Fix alt-left and alt-right in tmux
bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word

# Less Colors for Man Pages
# http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;33;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
