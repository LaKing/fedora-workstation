question install_skype "Install Skype, the chat program?" yes
function install_skype {
     run dnf config-manager --add-repo https://repo.skype.com/data/skype-stable.repo
     run dnf -y install skypeforlinux
}