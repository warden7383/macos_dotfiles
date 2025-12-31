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
  hyprland
"
pkgsSnap="
  spotify 
  discord 
"

pkgsCopr=("atim/starship" "scottames/ghostty" "solopasha/hyprland" "dejan/lazygit" "phracek/PyCharm")

echo -e "[Dotfile Installer]:"
echo -e "[OS] $osName detected"
echo -e "\n"

if [[ $1 == "list" ]]; then
  echo -e "Packages:\n"
  echo "Flatpak Packages: $pkgsFlat"
  echo "DNF Fedora Packages: $pkgsDnf"
  echo "Snap Packages: $pkgsSnap"
  echo "COPR Fedora Packages: "
  for repo in "${pkgsCopr[@]}"; do
    echo "$repo"
  done
else
  if [[ "$osName" == "Linux" ]]; then
    touch output.txt
    echo "INFO: Created output file" >> output.txt
    echo "INFO: Updating existing packages:" >> output.txt
    sudo dnf upgrade -y 2>&1 | sudo tee -a output.txt
    echo -e "INFO: Install script detected [LINUX] OS. Installing Dotfiles:\n" >> output.txt

    echo -e "INFO: Enabling COPR Repos\n" >> output.txt
    for repo in "${pkgsCopr[@]}"; do
      echo "> Enabling COPR Repo: $repo" >> output.txt
      sudo dnf copr enable "$repo" -y 2>&1 | sudo tee -a output.txt
    done

    echo "INFO: Installing flatpak" >> output.txt
    sudo dnf install flatpak -y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing dnf packages" >> output.txt
    sudo dnf install $pkgsDnf -y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing flat packages" >> output.txt
    sudo flat install $pkgsFlat 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing snap packages" >> output.txt
    sudo snap install $pkgsSnap -y 2>&1 | sudo tee -a output.txt

    echo -e "\nDone installing packages." >> output.txt
  elif [[ "$osName" == "Darwin" ]]; then
    touch output.txt
    echo -e "INFO: Install script detected [MACOS] OS. Installing Dotfiles:\n"
  else
    echo "Unknown OS detected, dotfilies will not be installed."
  fi
fi
