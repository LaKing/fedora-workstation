question install_browsers "Firefox, midori " yes
function install_browsers {

    run dnf -y install firefox 
    run dnf -y install firefox midori
}