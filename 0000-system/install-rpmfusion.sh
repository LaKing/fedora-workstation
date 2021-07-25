question add_rpmfusion 'The rpmfusion repo contains most of the packages that are needed on a proper workstation, to use proprietary software such as mp3 codecs. Recommended on a workstation.' yes
function add_rpmfusion {
    run dnf -y install --nogpgcheck "http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}
