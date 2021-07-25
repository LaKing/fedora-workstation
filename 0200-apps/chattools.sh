question install_chattools "Mumble is a useful free VOIP program, pidgin is a multiprotocol chat client." yes
function install_chattools {

    run dnf -y install pidgin 
    run dnf -y install mumble 
    run dnf -y install discord

	run dnf -y install https://download-ib01.fedoraproject.org/pub/fedora/linux/releases/33/Everything/x86_64/os/Packages/c/compat-openssl10-1.0.2o-11.fc33.x86_64.rpm
	run dnf -y install https://download.cdn.viber.com/desktop/Linux/viber.rpm
}
