question install_basic_system_tools 'There are some basic tools in a proper workstation, such a system monitoring tools, or the Disks tool, exfat support, gkrellm, filezilla, extra vnc clients, brasero, zip, rar, ..' yes
function install_basic_system_tools {
    run dnf -y install mc
    run dnf -y install gkrellm wget 
    run dnf -y install gparted 
    run dnf -y install exfat-utils fuse-exfat 
    run dnf -y install gnome-disk-utility gnome-system-monitor
    run dnf -y install unrar p7zip p7zip-plugins 
    run dnf -y install filezilla 
    run dnf -y install remmina remmina-plugins-vnc 
    run dnf -y install brasero
    run dnf -y install system-config-users
    run dnf -y install tigervnc-server
}