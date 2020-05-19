#!/bin/zsh

# Fail if exit code is not zero, in pipes, and also if variable is not set
# See: https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

mint_version="0.14.1"

function install_mint() {
  if [[ $(mint --version 2>/dev/null) == "Version: $mint_version" ]]; then
    echo "✨ Mint with version '$mint_version' is already installed"
  else
    mint_clone_path="mint-$mint_version"
    echo "✨ Downloading and installing Mint '$mint_version'"
    # Install method from https://github.com/yonaskolb/Mint#make
    git clone -b "$mint_version" --single-branch --depth 1 'https://github.com/yonaskolb/Mint.git' "$mint_clone_path"
    (cd "$mint_clone_path"; make)
    rm -rf "$mint_clone_path"
  fi
}

brew install mint # Install mint with brew, to speed up CI build
install_mint