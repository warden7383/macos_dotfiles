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
  org.kde.haruna
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
  mosh
  papirus-icon-theme
  valgrind
  cgdb
  hyprprop
  java-latest-openjdk-devel
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  rpmfusion-nonfree-release-rawhide
  libva-nvidia-driver
  libva-utils
  vulkan-loader-devel
  mesa-vulkan-drivers.i686
  drm-utils
  drm_info
  hyprgraphics-devel
  hyprsunset
  pipx
  waypipe
"

pkgsSnap="
  spotify 
  discord 
  code
"

pkgsSnapClassic="
  code
"

pkgsCopr=("atim/starship" "scottames/ghostty" "solopasha/hyprland" "dejan/lazygit" "phracek/PyCharm")

pkgsCargo="waybar-weather gpu-usage-waybar"

pkgsPip="PyGObject"

pkgsBrew="openjdk" "anomalyco/tap/opencode" 

pkgsNpm="@google/gemini-cli@latest" "opencode-ai@latest" 

fileApiKeys=("~/.config/waybar-weather/config.yaml")

pkgsPipx="hyprshade"

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
    echo -e "INFO: Enabling free and nonfree repo...\n" >> output.txt
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm  -y 2>&1 | sudo tee -a output.txt
    sudo dnf --enablerepo=rpmfusion-nonfree-rawhide update "*nvidia*" -y 2>&1 j| sudo tee -a output.txt

    echo -e "INFO: set default config\n" >> output.txt
    sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1 2>&1 | sudo tee -a output.txt

    echo -e "INFO: Enabling COPR Repos\n" >> output.txt
    for repo in "${pkgsCopr[@]}"; do
      echo "> Enabling COPR Repo: $repo" >> output.txt
      sudo dnf copr enable "$repo" -y 2>&1 | sudo tee -a output.txt
    done

    echo "INFO: Installing flatpak" >> output.txt
    sudo dnf install flatpak -y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing snapd" >> output.txt
    sudo dnf install snapd -y 2>&1 | sudo tee -a output.txt
    echo "INFO: Enabling classic snap support..." >> output.txt
    sudo ln -s /var/lib/snapd/snap /snap 2>&1 | sudo tee -a ouput.txt

    echo "INFO: Installing dnf packages" >> output.txt
    sudo dnf install $pkgsDnf -y 2>&1 | sudo tee -a output.txt

    echo "INFO: reloading ~/.zshrc path" >> output.txt
    source ~/.zshrc 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing flat packages" >> output.txt
    sudo flatpak install $pkgsFlat -Y 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing snap packages" >> output.txt
    # sudo snap install $pkgsSnap -y 2>&1 | sudo tee -a output.txt # -y option may not work(?)
    sudo snap install $pkgsSnap 2>&1 | sudo tee -a output.txt


    echo "INFO: Installing snap classic packages" >> output.txt
    sudo snap install --classic $pkgsSnapClassic 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing cargo packages" >> output.txt
    cargo install $pkgsCargo 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing npm packages" >> output.txt
    sudo npm install -g $pkgsNpm 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing pip packages" >> output.txt
    pip install $pkgsPip 2>&1 | sudo tee -a output.txt

    echo "INFO: Installing pipx packages" >> output.txt
    pipx install $pkgsPipx 2>&1 | sudo tee -a output.txt

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

    echo "Enable passwordless boot from waybar power module..." >> output.txt
    echo "warden ALL=(ALL) NOPASSWD:/usr/sbin/grub2-reboot, /usr/sbin/reboot" | sudo tee /etc/sudooers.d/warden-reboot | sudo tee -a output.txt

    echo "NOTE: go to https://github.com/catppuccin/kde?tab=readme-ov-file to theme KDE apps with catppuccin" >> output.txt
    echo "NOTE: go to https://gitlab.com/Pummelfisch/future-cyan-hyprcursor and git clone the repo to get hyprland cursor (or search for another hyprland cursor theme)" >> output.txt
    echo "NOTE: use nwg-look to configure the GTK cursor." >> output.txt
    echo "NOTE: see https://github.com/warden7383/rofi.git docs to how to edit/style rofi"
    echo "NOTE: see hyprland nvidia docs if using nvidia gpu for setup. as well as doing the secure boot key import into BIOS/EFI from fedora official docs" >> output.txt
    echo "NOTE: enable haruna nvdec decoder (for nvidia gpu) from launching haruna -> settings -> playback -> hardware decoding" >> output.txt

  elif [[ "$osName" == "Darwin" ]]; then
    touch output.txt
    echo -e "INFO: Install script detected [MACOS] OS. Installing Dotfiles:\n" >> output.txt
    brew upgrade
  else
    echo "Unknown OS detected, dotfilies will not be installed."
  fi
fi
