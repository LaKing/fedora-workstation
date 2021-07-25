question install_virtualbox "Use virtualbox to emulate any OS. (please reboot first, if you have update the kernel, and don't use UEFI secure boot.)" no
function install_virtualbox { 
    
    run dnf -y install VirtualBox
    
}

## diabled and not maintained for now.
#question install_virtualbox_oracle "Use virtualbox to emulate windows or any other operating system. (please reboot first, if you have update the kernel.)" no
function install_virtualbox_oracle {   

    run dnf -y remove VirtualBox
    run dnf -y install kernel binutils gcc make perl patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon

    run wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
    run dnf -y install VirtualBox-6.1
    run usermod -a -G vboxusers "$USER"
    
    if [ "$(rpm -qa kernel |sort -V |tail -n 1)" == "kernel-$(uname -r)" ]
    then
        msg "Kernel is OK! starting vboxdrv"
        run /usr/lib/virtualbox/vboxdrv.sh setup

    else
        err "You are not running the latest kernel! Please reboot and start this command again."
    fi

}