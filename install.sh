#!/bin/bash
osName=$(uname -s)
# pkgsFlat=("app.zen_browser.zen")
# pkgsDnf=("ghostty" "tmux" "starship" "bat" "zoxide" "fzf" "btop" "rg" "zsh" "fd" "lsd" "lazygit" "clang" "nodejs" "cmake" "make" "rust" "cargo" "golang")
# NOTE: not sure how stable discord is from snap. (Install from official site if needed)
# pkgsSnap=("spotify" "discord")

pkgsFlat="
  app.zen_browser.zen
"
pkgsDnf="
  ghostty 
  tmux 
  starship 
  bat 
  zoxide 
  fzf 
  btop 
  rg 
  zsh 
  fd 
  lsd 
  lazygit 
  clang 
  nodejs 
  cmake 
  make 
  rust 
  cargo 
  golang 
"
pkgsSnap="
  spotify 
  discord 
"

echo -e "[Dotfile Installer]:"
echo -e "[OS] $osName detected"
echo -e "\n"

if [[ $1 == "list" ]]; then
  echo "Packages:"

else
  if [[ "$osName" == "Linux" ]]; then
    touch output.txt
    echo "INFO: Created output file" >> output.txt
    echo "INFO: Updating existing packages:" >> output.txt
    sudo dnf upgrade -y | sudo tee -a output.txt
    echo -e "INFO: Install script detected [LINUX] OS. Installing Dotfiles:\n" >> output.txt
    echo -e "INFO: Enabling COPR Repos\n" >> output.txt
    echo "> Starship COPR:" >> output.txt
    sudo dnf copr enable atim/starship -y | sudo tee -a output.txt
    echo "> Ghostty COPR:" >> output.txt
    sudo dnf copr enable scottames/ghostty -y | sudo tee -a output.txt
    echo "INFO: Installing flatpak" >> output.txt
    sudo dnf install flatpak -y | sudo tee -a output.txt
    echo "INFO: Installing dnf packages" >> output.txt
    sudo dnf install $pkgsDnf -y | sudo tee -a output.txt
    echo "INFO: Installing flat packages" >> output.txt
    sudo flat install $pkgsFlat | sudo tee -a output.txt
    echo "INFO: Installing snap packages" >> output.txt
    sudo snap install $pkgsSnap -y | sudo tee -a output.txt
    echo -e "\nDone installing packages." >> output.txt
  elif [[ "$osName" == "Darwin" ]]; then
    touch output.txt
    echo -e "INFO: Install script detected [MACOS] OS. Installing Dotfiles:\n"
  else
    echo "Unknown OS detected, dotfilies will not be installed."
  fi
fi
