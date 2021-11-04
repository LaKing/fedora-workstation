question install_chattools "Discord, Viber." yes
function install_chattools {

    #run dnf -y install pidgin 
    #run dnf -y install mumble 
    
    ## Discord - crashes in if gpu_data_manager_impl_private, use --no-sandbox -- add it to launcher in /usr/share/applications
    run dnf -y install discord

	## Viber
	run dnf -y install https://download-ib01.fedoraproject.org/pub/fedora/linux/releases/33/Everything/x86_64/os/Packages/c/compat-openssl10-1.0.2o-11.fc33.x86_64.rpm
	run dnf -y install https://download.cdn.viber.com/desktop/Linux/viber.rpm
}
