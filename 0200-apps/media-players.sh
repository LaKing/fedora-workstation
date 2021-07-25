question install_media_players "Amarok is a cool media player, and VLC has also some unique features. Download youtube videos with youtube-dl,.." yes
function install_media_players {

    run dnf -y install vlc
    run dnf -y install amarok
    run dnf -y install youtube-dl
}