question install_steam "Steam is a gaming platform." no
function install_steam {

    add_rpmfusion

    run dnf -y install steam
    run dnf -y install vulkan
    
}
