question install_spotify "Spotify is a music-streaming service, would you like to install the client?" no
function install_spotify {

    run dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo
    run dnf -y install spotify-client
}