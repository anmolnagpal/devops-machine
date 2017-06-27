#!/usr/bin/env bash
set -e

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi

if [ -d "$ZSH" ]; then
  echo "\033[0;33mYou already have Oh My Zsh installed.\033[0m You'll need to remove $ZSH if you want to install"
  exit
fi

echo "\033[0;34mCloning Oh My Zsh...\033[0m"
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  echo "git not installed"
  exit
}

echo "\033[0;34mLooking for an existing zsh config...\033[0m"
if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
  echo "\033[0;33mFound ~/.zshrc.\033[0m \033[0;32mBacking up to ~/.zshrc.pre-oh-my-zsh\033[0m";
  mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
fi

echo "\033[0;34mUsing the Oh My Zsh template file and adding it to ~/.zshrc\033[0m"
cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
sed -i -e "/^export ZSH=/ c\\
export ZSH=$ZSH
" ~/.zshrc

echo "\033[0;34mCopying your current PATH and adding it to the end of ~/.zshrc for you.\033[0m"
sed -i -e "/export PATH=/ c\\
export PATH=\"$PATH\"
" ~/.zshrc

echo "\033[0;34mCloning Plugins...\033[0m"
git clone https://github.com/zsh-users/zsh-syntax-highlighting /usr/local/share/zsh-syntax-highlighting || true
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/local/share/zsh-autosuggestions || true
