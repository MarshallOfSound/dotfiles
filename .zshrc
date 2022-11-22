# oh-my-zsh config

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"


plugins=(git npm nvm node command-not-found dircycle docker extract gcloud zsh-autosuggestions zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh

# Personal configuration

fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit
prompt pure

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

eval $(thefuck --alias)

eval "$(direnv hook zsh)"

line() {
  dir=$(mktemp -d -t line-XXXXXXXX)
  curl --compressed $(echo $1 | cut -d: -f1-2) -o $dir/tmp.js
  code --goto $dir/tmp.js:$(echo $1 | cut -d: -f3-4)
}

alias yarn='npx -y yarn@1.21.1'

revoke_gh() {
  curl \
    -X DELETE \
    -vv \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $1" https://api.github.com/installation/token
}
