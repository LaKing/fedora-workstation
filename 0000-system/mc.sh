question install_mc 'Midnight Commander is a basic file manager in the console, .. ' yes
function install_mc {
    run dnf -y install mc
}