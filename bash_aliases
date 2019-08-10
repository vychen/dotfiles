alias vi='vim'
alias untar='tar -zxvf'
alias rm="rm -i"
alias c="clear"
alias h="history"
alias lsdir="ls -d */"
alias o="gnome-open"

# git.
alias ga="git add"
alias gb="git branch"
alias gd="git diff"
alias gco="git checkout"
alias gst="git status"
alias gp="git pull"
alias gu="git push"

# Git auto-completion.
if [ -f "/usr/share/bash-completion/completions/git" ]; then
  source /usr/share/bash-completion/completions/git
  __git_complete gco _git_checkout
  __git_complete gp _git_pull
  __git_complete gb _git_branch
else
  echo "Error loading git completions"
fi
