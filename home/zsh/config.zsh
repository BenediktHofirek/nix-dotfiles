# Preferred editor for local and remote sessions
if [[ -n "$SSH_CONNECTION" ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Jujutsu
alias j='jj'
alias jw="watch -n 0.5 -t --color 'jj --ignore-working-copy log -n 20 --color=always'"

# Aliases
alias e='eza'

if [[ -n "$TMUX" ]]; then
  alias t="nvim -c ':terminal'"
else
  alias t='tmux'
fi

# SSH agent
# Preserve a forwarded SSH agent when one is already configured.
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-${XDG_RUNTIME_DIR}/ssh-agent.socket}"

# Prompt for the key passphrase on the first interactive shell
# when the agent has no identities.
if [[ -o interactive ]]; then
  if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add "$HOME/.ssh/id_rsa"
  fi
fi

# Automatically start tmux outside an existing tmux session.
if [[ -o interactive && -z "$TMUX" ]]; then
  tmux -S "/tmp/tmux-$$.sock"
fi

