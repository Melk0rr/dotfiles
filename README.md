# dotfiles
## Description
My config files for Linux and Windows

## Branches
One branch per distro

## Requirements
### git
```shell
  sudo pacman -Syu git # Arch
  sudo apt install git # Debian
  sudo zypper in git # openSuse
```
### GNU stow
```shell
  sudo pacman -Syu stow # Arch
  sudo apt install stow # Debian
  sudo zypper in stow # openSuse
```

## Installation
1. Git clone the repo in your home folder
   ```shell
   cd
   git clone https://github.com/Melk0rr/dotfiles
   cd dotfiles
   ```
2. Checkout the branch you want depending on the distro you're on
   ```shell
   git checkout arch # Arch
   git checkout debian # Debian
   git checkout opensuse # openSuse
   ```
3. Deploy the files using Stow
   ```shell
   stow .   
   ```
  
