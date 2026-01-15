#!/bin/bash
# NOTE: Move the entire dotfilies repo into your ~/.config dir before using this script
osName=$(uname -s)
# pkgsFlat=("app.zen_browser.zen")
# pkgsDnf=("ghostty" "tmux" "starship" "bat" "zoxide" "fzf" "btop" "rg" "zsh" "fd" "lsd" "lazygit" "clang" "nodejs" "cmake" "make" "rust" "cargo" "golang")
# NOTE: not sure how stable discord is from snap. (Install from official site if needed)
# pkgsSnap=("spotify" "discord")
# for docker reqs for linux: run: sudo usermod -aG kvm $USER and restart machine

pkgsFlat="
  app.zen_browser.zen
  com.discordapp.Discord
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
  dunst
  waybar
  rofi
  blueman
  python3-pip
  nvtop
  pavucontrol
  satty
  cliphist
  udiskie
  gimp
  gnome-terminal
  qt5ct
  qt6ct
  nwg-look
  mpv
  haruna
  mosh
  papirus-icon-theme
"

pkgsSnap="
  spotify 
  discord 
"

pkgsCopr=("atim/starship" "scottames/ghostty" "solopasha/hyprland" "dejan/lazygit" "phracek/PyCharm")

pkgsCargo="waybar-weather gpu-usage-waybar"

pkgsPip="PyGObject"

pkgsBrew="openjdk" "anomalyco/tap/opencode" 

pkgsNpm="@google/gemini-cli@latest" "opencode-ai@latest" 

fileApiKeys=("~/.config/waybar-weather/config.yaml")

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
    mkdir -p "$HOME"/.local/share/icons/hicolor/16x16/apps/ >> output.txt
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
    sudo flatpak install $pkgsFlat -Y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing snap packages" >> output.txt
    sudo snap install $pkgsSnap -y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing cargo packages" >> output.txt
    cargo install $pkgsCargo 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing npm packages" >> output.txt
    sudo npm install -g $pkgsNpm 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing pip packages" >> output.txt
    pip install $pkgsPip 2>&1 | sudo tee -a output.txt

    echo -e "\nDone installing packages." >> output.txt

    echo "Adding execution perms to hyprland's gamemode script" >> output.txt
    chmod +x ~/.config/hypr/gamemode.sh 

    echo -e "TODO: Please manually add the api-keys necessary to the following scripts\n" >> output.txt

    for key in "${fileApiKeys[@]}"; do
      echo "> FILE: $key" >> output.txt
    done

    echo "NOTE: if you are planning on pushing to github via ssh on another device, set up your ssh keys:" >> output.txt
    echo "> https://github.com/settings/keys - place your ssh pub key there. do a ssh -T git@github.com"  >> output.txt
    echo "> remember to do git remote add [name] [SSH github link] before pushing if using ssh"  >> output.txt
    echo -e "\nVesktop(Discord that fixes afk time): https://vesktop.dev/install/linux/ then run: sudo dnf install [package].rpm" >> output.txt
    echo "> Move the vesktop.desktop to /usr/share/applications/ after (check if vesktop is in the Exec={...} location in the .desktop file) (edited according to vesktop docs)" >> output.txt
    echo "NOTE: Gemini cli needs authentication" >> output.txt
    echo "NOTE: for docker setup, follow the docs: https://docs.docker.com/desktop/setup/install/linux/fedora/" >> output.txt
    echo "Setting up qt5 and qt6 themes..." >> output.txt
    git clone https://github.com/catppuccin/qt5ct "$HOME/qt5"
    mkdir -p ~/.config/qt5ct/colors/; cp -r "$HOME/qt5/themes/." ~/.config/qt5ct/colors/ 2>&1 || sudo tee -a output.txt
    mkdir -p ~/.config/qt6ct/colors/; cp -r "$HOME/qt5/themes/." ~/.config/qt6ct/colors/ 2>&1 || sudo tee -a output.txt

    echo "Setting up rofi themes..." >> output.txt
    git clone --depth=1 https://github.com/warden7383/rofi.git "$HOME" 2>&1 || sudo tee -a output.txt
    cd ~/rofi 2>&1 || sudo tee -a output.txt
    chmod +x setup.sh 2>&1 || sudo tee -a output.txt
    bash setup.sh 2>&1 || sudo tee -a output.txt

    echo "NOTE: go to https://github.com/catppuccin/kde?tab=readme-ov-file to theme KDE apps with catppuccin" >> output.txt
    echo "NOTE: go to https://gitlab.com/Pummelfisch/future-cyan-hyprcursor and git clone the repo to get hyprland cursor (or search for another hyprland cursor theme)" >> output.txt
    echo "NOTE: use nwg-look to configure the GTK cursor." >> output.txt
    echo "NOTE: see https://github.com/warden7383/rofi.git docs to how to edit/style rofi"


  elif [[ "$osName" == "Darwin" ]]; then
    touch output.txt
    echo -e "INFO: Install script detected [MACOS] OS. Installing Dotfiles:\n" >> output.txt
    brew upgrade
  else
    echo "Unknown OS detected, dotfilies will not be installed."
  fi
fi
