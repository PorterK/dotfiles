#!bin/bash

alias g='git'
alias g{='git stash'
alias g}='git stash apply'
alias glg='git log'
alias gdc='git diff --cached'
alias gcm='git commit -S -m'
alias gc="git commit"
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gst='git status'
alias gco="git checkout"
alias gpp="git pull && git push"
alias gpull="git pull"
alias gpush="git push"
alias gd="git diff"
alias gb="git branch"
alias ga="git add"
alias gaa="git add -A ."

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

alias gda=_git_delete_local_and_remote_branch

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