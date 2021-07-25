question install_browsers "Install Google chrome .. " yes
function install_browsers {

  run dnf -y install fedora-workstation-repositories
  
  run dnf -y config-manager --set-enabled google-chrome
  
  run dnf -y install google-chrome-stable
}