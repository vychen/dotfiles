alias untar='tar -zxvf'
alias rm="rm -i"
alias c="clear"
alias h="history"
alias lsdir="ls -d */"
alias o="gnome-open"

# git.
alias ga="git add"
alias gb="git branch"
__git_complete gb _git_branch
alias gd="git diff"
alias gco="git checkout"
__git_complete gco _git_checkout
alias gst="git status"
