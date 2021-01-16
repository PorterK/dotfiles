export PATH=/usr/local/bin:$PATH

# Add this in for M1 macs
alias brew=/opt/homebrew/bin/brew

# Remove all precmd funcs so we can set PS1
precmd_functions=""
for f in ~/code/dotfiles/zsh/*; do source $f; done
export GPG_TTY=$(tty)