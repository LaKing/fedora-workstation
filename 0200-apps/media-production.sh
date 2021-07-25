question install_media_producer_tools "Compose multitrack soundtracks with Ardour,.. use mixxx to create your mixes." no
function install_media_producer_tools {
     
    run dnf -y install audacity-freeworld 
    run dnf -y install ardour5
    #run dnf -y install qjackctl a2jmidid alsa-tools ffado alsa-plugins-jack jack-audio-connection-kit-dbus vlc-plugin-jack pulseaudio-module-jack
    run dnf -y install mixxx
}