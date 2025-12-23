osName=$(uname)

[[ -r ~/zshPlugins/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/zshPlugins/znap
source ~/zshPlugins/znap/znap.zsh  # Start Znap

if [[ "$osName" == "Linux" ]]; then

if [[ ! -d ~/zshPlugins/.zsh-autopair ]]; then
  git clone https://github.com/hlissner/zsh-autopair ~/zshPlugins/.zsh-autopair
fi

AUTOPAIR_INHIBIT_INIT=1
source ~/zshPlugins/.zsh-autopair/autopair.zsh
# autopair-init

if [[ ! -d ~/zshPlugins/.zsh-vi-mode ]]; then
  git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/zshPlugins/.zsh-vi-mode
fi

ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
ZVM_VI_ESCAPE_BINDKEY=jk
zvm_after_init_commands=(autopair-init) #loads autopair-init after loading zvm as zvm is lazy loaded
source ~/zshPlugins/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
#For completions to work, the above line must be added after compinit is called. You may have to rebuild your completions cache by running rm ~/.zcompdump*; compinit.
export FZF_DEFAULT_OPTS="--height ~40% 
--border=rounded 
--border-label='Fuzzy Finder' 
--margin=0,2 
--info=right 
--separator=─ 
--scrollbar=▐▐ 
--prompt=' ' 
--pointer=▶
--marker=�
--ansi 
--tabstop=2 
--preview-label=Preview 
--cycle 
--scroll-off=3
--color=fg:#cad3f5,fg+:#8593d1,bg:#24283b,bg+:#373d57
--color=hl:#0db9d7,hl+:#0db9d7,info:#8bd5ca,marker:#f5a97f
--color=prompt:#0db9d7,spinner:#8bd5ca,pointer:#c6a0f6,header:#f0c6c6
--color=gutter:#24283b,border:#80b7ff,scrollbar:#8b8faa,preview-fg:#cad3f5
--color=preview-scrollbar:#8b8faa,preview-label:#80b7ff,label:#80b7ff,query:#cad3f5
"
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"


#lsd (for ls colors and icons)
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias cdf='$(fd -Ht d . | fzf)' #use fd and fzf to jump to directory on search

if [[ ! -d ~/zshPlugins/zsh-autosuggestions ]]; then
git clone https://github.com/zsh-users/zsh-autosuggestions ~/zshPlugins/zsh-autosuggestions
fi

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source ~/zshPlugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ ! -d ~/zshPlugins/zsh-syntax-highlighting ]]; then
 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zshPlugins/zsh-syntax-highlighting
fi

if [[ ! -d ~/zshPlugins/catppuccinTheme-zsh-syntax-highlighting ]]; then
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/zshPlugins/catppuccinTheme-zsh-syntax-highlighting
fi

source ~/zshPlugins/catppuccinTheme-zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
source ~/zshPlugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# change directory by using yazi
function cdy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# TODO: Move the bat condition block into an install.sh script
batStatus=$(bat -h)
if [[ ! -d ~/.config/bat && $batStatus ]]; then
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
touch "$(bat --config-dir)/config"
fi

batdiff() {
    git diff --name-only --relative --diff-filter=d -z | xargs -0 bat --diff
}

export MANPAGER="bat -plman"
export PATH

if [[ -z "$TMUX" ]]; then
tmux
fi
elif [[ "$osName" == Darwin ]]; then
AUTOPAIR_INHIBIT_INIT=1
source $(brew --prefix)/share/zsh-autopair/autopair.zsh
# zsh-vi-mode: (via brew)
# Change to Zsh's default readkey engine
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
ZVM_VI_ESCAPE_BINDKEY=jk
zvm_after_init_commands=(autopair-init) #loads autopair-init after loading zvm as zvm is lazy loaded
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh


#If you need to have node@20 first in your PATH, run:
  #echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zshrc

#For compilers to find node@20 you may need to set:
  #export LDFLAGS="-L/opt/homebrew/opt/node@20/lib"
  #export CPPFLAGS="-I/opt/homebrew/opt/node@20/include"

#for zsh tetris if bored
#autoload -Uz tetriscurses
#alias tetris=tetriscurses

PATH="/opt/homebrew/opt/node@20/bin:$PATH"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
PATH="/Users/warden/tools/llvm-project/build/bin:$PATH" #llvm and clang
# PATH="$PATH:/Applications/nvim-macos/bin" #version 0.9
# PATH="$PATH:/Users/warden/Downloads/nvimTest/nvim-macos-arm64/bin" #nightly that had statusline working
# PATH="$PATH:/Applications/nvim-08-31-2024/nvim-macos-arm64/bin"
PATH="$PATH:/Applications/nvim-macos-arm64-03-05-2025/bin"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
#For completions to work, the above line must be added after compinit is called. You may have to rebuild your completions cache by running rm ~/.zcompdump*; compinit.
export FZF_DEFAULT_OPTS="--height ~40% 
--border=rounded 
--border-label='Fuzzy Finder' 
--margin=0,2 
--info=right 
--separator=─ 
--scrollbar=▐▐ 
--prompt=' ' 
--pointer=▶
--marker=�
--ansi 
--tabstop=2 
--preview-label=Preview 
--cycle 
--scroll-off=3
--color=fg:#cad3f5,fg+:#8593d1,bg:#24283b,bg+:#373d57
--color=hl:#0db9d7,hl+:#0db9d7,info:#8bd5ca,marker:#f5a97f
--color=prompt:#0db9d7,spinner:#8bd5ca,pointer:#c6a0f6,header:#f0c6c6
--color=gutter:#24283b,border:#80b7ff,scrollbar:#8b8faa,preview-fg:#cad3f5
--color=preview-scrollbar:#8b8faa,preview-label:#80b7ff,label:#80b7ff,query:#cad3f5
"
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"


#lsd (for ls colors and icons)
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias cdf='$(fd -Ht d . | fzf)' #use fd and fzf to jump to directory on search

# zsh autocomplete
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# change directory by using yazi
function cdy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


export PATH

else
echo "Running on unknown OS\n"
fi
