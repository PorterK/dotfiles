#!bash

[[ -f $HOME/.custom-bash/git-completion ]] && source $HOME/.custom-bash/git-completion

alias g='git'
alias g{='git stash'
alias g}='git stash apply'
alias glg='git log'
complete -o default -o nospace -F _git_log glg
alias gdc='git diff --cached'
complete -o default -o nospace -F _git_diff gdc
alias gcm='git commit -S -m'
alias gc="git commit"
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gst='git status'
alias gco="git checkout"
alias gpp="git pull && git push"
complete -o default -o nospace -F _git_checkout gco
alias gpull="git pull"
complete -o default -o nospace -F _git_pull gpull
alias gpush="git push"
complete -o default -o nospace -F _git_push gpush
alias gd="git diff"
complete -o default -o nospace -F _git_diff gd
alias gb="git branch"
complete -o default -o nospace -F _git_branch gb
alias ga="git add"
complete -o default -o nospace -F _git_add ga
alias gaa="git add -A ."
complete -o default -o nospace -F _git_add gaa

function ___gbr() {
  git branch -m "$1"
}

alias gbr=___gbr

alias git-nuclear-option="git reset --hard; git clean -fd"
alias gno="git-nuclear-option"

_git_delete_local_branch(){
    if [ "$1" ]
    then
    	gb -d "$1";
    fi
}

_git_delete_remote(){
    if [ "$1" ]
    then
    	gpush origin :"$1"
    fi
}

_git_delete_local_and_remote_branch (){
    if [ "$1" ]
    then
	_git_delete_local_branch "$1"; _get_delete_remote origin :"$1"
    fi
}

alias gbd=_git_delete_local_branch
complete -o default -o nospace -F _git_checkout gbd

alias gda=_git_delete_local_and_remote_branch
complete -o default -o nospace -F _git_checkout gda

FG_BLACK="\[\033[01;30m\]"
FG_WHITE="\[\033[01;37m\]"
FG_RED="\[\033[01;91m\]"
FG_GREEN="\[\033[01;32m\]"
FG_BLUE="\[\033[01;96m\]"
NO_COLOR="\[\e[0m\]"

#build PS1
#don't set PS1 for dumb terminals
if [[ "$TERM" != 'dumb' ]] && [[ -n "$BASH" ]]; then
    PS1=''
    #don't modify titlebar on console
    [[ "$TERM" != 'linux' && "$CF_REAL_TERM" != "eterm-color" ]] && PS1="${PS1}\[\e]2;\u@\H:\W\a"

    #use a red $ if you're root, white otherwise

    # if [[ $WHOAMI = "root" ]]; then
    # 	  #red hostname
	  #    PS1="${PS1}${FG_RED}"
    # else
    #   	# green user@hostname
    #  	  PS1="${PS1}${FG_GREEN}"
    # fi

    GIT_PS1_SHOWDIRTYSTATE=1
    #working dir basename and prompt
    PS1="${FG_RED}\W${FG_BLUE}\$(__git_ps1 "[%s]")${FG_GREEN}\$ ${NO_COLOR}"
fi

git config --global color.ui auto

alias unmerged-branches="comm -12 <(git branch -a --no-merge master | sort) <(git branch -a --no-merge develop | sort)"

function ___gprune {
  git remote prune origin --dry-run
  git branch -a

  COLLUMNS=50

  read -r -p "Pruning will delete all branches except for develop and master, do you want to continue? [y/N] " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
  then
      git remote prune origin
      git branch | grep -v "master" | grep -v "develop" | xargs git branch -D
      echo "Done."
  else
      echo "ok"
  fi
}

alias gprune='___gprune'

# Push current branch.
function ___gpushc {
  CURRENT_BRANCH="$(git branch | grep \* | cut -d ' ' -f2)"

  gpush origin $CURRENT_BRANCH
}

alias gpushc='___gpushc'

# Pull current branch.

function ___gpullc {
  CURRENT_BRANCH="$(git branch | grep \* | cut -d ' ' -f2)"

  gpull origin $CURRENT_BRANCH
}

alias gpullc='___gpullc'

function ___gbrr {
  if [ -z "$1" ]
  then
    echo "Please enter the old branch name."
  else
    if [ -z "$2" ]
    then
      echo "Please enter a new branch name."
    else
      gco $1
      gbr $2
      gpush origin --delete $1
      gpush origin -u $2
    fi
  fi

}

alias gbrr='___gbrr'