question install_transmission "Install Transmission, a torrent client .. " yes
function install_transmission {

  run dnf -y install transmission
}