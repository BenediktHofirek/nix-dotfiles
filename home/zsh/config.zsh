# Prevent Ctrl+d from closing shell
setopt ignore_eof

# Preferred editor for local and remote sessions
if [[ -n "$SSH_CONNECTION" ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

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

# Automatically start tmux outside an existing tmux session
# to have separate session for each terminal window
if [[ -o interactive && -z "$TMUX" ]]; then
  tmux -S "/tmp/tmux-$$.sock"
fi

# Clipboard - shouldn't be needed, everything should be handled inside tmux
# yank (y{motion}) in vi normal mode also goes to the system clipboard
#_vi_yank_clip() { zle vi-yank; print -rn -- "$CUTBUFFER" | wl-copy }
#zle -N _vi_yank_clip
#bindkey -M vicmd 'y' _vi_yank_clip

# copy the whole current command line
#_copy_line() { print -rn -- "$BUFFER" | wl-copy; zle -M "copied" }
#zle -N _copy_line
#bindkey '^Y' _copy_line          # emacs/viins; adjust key to taste
#bindkey -M viins '^Y' _copy_line

# paste from the system clipboard at the cursor
#_paste_clip() { LBUFFER+="$(wl-paste --no-newline)" }
#zle -N _paste_clip
#bindkey -M viins '^[v' _paste_clip   # Alt+v
#bindkey -M vicmd 'p' _paste_clip

# Bind up-arrow key to trigger Atuin inside tmux popup as well
bindkey '^[[A' _atuin_search_widget
bindkey '^[OA' _atuin_search_widget

# Aliases

# Jujutsu
alias j='jj'
alias jw="watch -n 0.5 -t --color 'jj --ignore-working-copy log -n 20 --color=always'"

# Eza
alias e='eza'

# Nvim
alias n='nvim'

# Steno
alias stenodev='find ~/steno-dictionary/steno -name "*.steno" | entr -c ~/steno-dictionary/scripts/checker/target/release/checker'

# Hunk
h() {
    if [[ $# -eq 0 ]]; then
        hunk show
    else
        hunk "$@"
    fi
}
