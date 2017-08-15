#!/bin/bash
#
# Workstation installer script for Fedora (23 and up) Latest fedora is 26.
#
# D250 Laboratories / D250.hu 2014-2016
# Author: István király
# LaKing@D250.hu
# 
## download, update with:
# curl http://d250.hu/scripts/install-workstation.sh > install.sh 
## run with bash 
# && bash install.sh
#

## Timestamp
readonly NOW="$(date +%Y.%m.%d-%H:%M:%S)"
## logfile
readonly LOG="$(pwd)/install-workstation.log"
## current dir
readonly DIR="$(pwd)"
## temporal backup and work directory
readonly TMP="/temp"
## A general message string 
readonly MSG="## D250 Laboratories $0 @ $NOW"
## Debugging helper
DEBUG=false
## constants

## constants for use everywhere
readonly RED='\e[31m'
readonly GREEN='\e[32m'
readonly YELLOW='\e[33m'
readonly BLUE='\e[34m'
readonly GRAY='\e[37m'
readonly CLEAR='\e[0m'

## Lablib functions

function msg {
    ## message for the user
    echo -e "${GREEN}$*${CLEAR}"
}

function ntc {
    ## notice for the user
    echo -e "${YELLOW}$*${CLEAR}"
}


function log {
    ## create a log entry
    echo -e "${YELLOW}$1${CLEAR}"
    echo "$NOW: $*" >> "$LOG"
}

## silent log
function logs {
    ## create a log entry
    echo "$NOW: $*" >> "$LOG"
}
dbgc=0
function dbg {
    ((dbgc++))
    ## short debug message if debugging is on
    if $DEBUG
    then
        echo -e "${YELLOW}DEBUG #$dbgc ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} ${RED} $* ${CLEAR}"
    fi
}
function debug {
    ## tracing debug message
    echo -e "${YELLOW}DEBUG ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} ${RED} $*${CLEAR}"
}
function err {
    ## error message
    echo -e "$NOW ERROR ${RED}$*${CLEAR}" >> "$LOG"
    echo -e "${RED}$*${CLEAR}" >&2
}

function run {
    local signum='$'
    if [ "$USER" == root ]
    then
        signum='#'
    fi
    local WDIR
    WDIR="$(basename "$PWD")"
    echo -e "${BLUE}[$USER@${HOSTNAME%%.*} ${WDIR/#$HOME/\~}]$signum ${YELLOW}$*${CLEAR}"

    # shellcheck disable=SC2048
    $*
    eyif "command '$*' returned with an error"
}

## exit if failed
function exif {
    local exif_code="$?"
    if [ "$exif_code" != "0" ]
    then
        if $DEBUG
        then
            ## the first in stack is what we are looking for. (0th is this function itself)
            err "ERROR $exif_code @ ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} :: $*"
        else
            err "$*"
        fi
        exit "$exif_code";
    fi
}

## extra yell if failed
function eyif {
    local eyif_code="$?"
    if [ "$eyif_code" != "0" ]
    then
        if $DEBUG
        then
            err "ERROR $eyif_code @ ${BASH_SOURCE[1]}#$BASH_LINENO ${FUNCNAME[1]} :: $*"
        else
            err "$*"
        fi
    fi
}


## If user is root or runs on root privileges, continiue.
if [ "$UID" -ne "0" ]
then
  ntc "Root privileges needed to run this script. Trying with sudo."
  ## Attemt to get root privileges with sudo, and run the script
  sudo bash "$0"
  exit
fi

## Any enemy in sight? :)
clear

#if [[ $SUDO_USER ]]
#then
#     ## calling user is a sudoer
#     USER="$SUDO_USER"
#else
#     ## user must be root, and a default user is needed
#     USER="$(getent passwd 1000 | cut -d: -f1)"
#fi

## Author info
# echo "István Király - D250 Laboratories. LaKing@D250.hu"

## Version info
ntc "$(cat /etc/fedora-release) detected!"

USER_HOME="$( getent passwd "$USER" | cut -d: -f6 )"


if [ -z "$USER" ]
then 
    err "No user could be located." 
    exit
else
    log "Started with user: $USER - home in $USER_HOME"
fi

msg "$MSG"
mkdir -p "$TMP"


log "Questioning Installation started."

a=0
n=0
h=0

## Basic helper functions

function question {
    ## Add to the question que asq, with counter a

    (( a++ ))
    asq[$a]=$1
    hlp[$a]=$2
    def[$a]=$3
}

function run_in_que {
    ## run the question que. Default answer is no, y is the only other option
    ## y-answered question are added to the executation que
    echo ''
    echo "${hlp[h]}"

    key=
    echo -n "$1? " | tr '_' ' '

    default_key=${def[h]:0:1}
    default_str="y/N"

    if [[ $default_key == y* ]]; then
      default_str="Y/n"
    else
      default_str="y/N"
    fi
     # shellcheck disable=SC2034
    read -s -r -p " [$default_str] " -n 1 -i "y" key

    ## Check for default action
    if [ ${#key} -eq 0 ]; then
     ## Enter was hit"
     key=$default_key
    fi

    ## Makre it an ordenary string
    if [[ $key == y ]]; then
     key="yes"
    else
     key="no";
    fi

    echo $key

    ## Que the action if yes
    if [[ $key == y* ]]; then
      echo "$1" >> "$LOG"
      (( n++ ))
      que[$n]=$1 
    fi
}

function bak {
    ## create a backup of the file, with the same name, same location .bak extension
    ## filename=$1
    echo "$MSG" >> "$1.bak"
    cat "$1" >> "$1.bak"
    #echo "$1 has a .bak file"
}

function set_file {
    ## cerate a file with the content overwriting everything
    ## filename=$1 content=$2

    if [[ -f $1 ]]
    then 
          bak "$1"
    fi
    echo "creating $1"
    echo "$2" > "$1"
}

function sed_file {
    ## used to replace a line in a file
    ## filename=$1 old line=$2 new line=$3
    bak "$1"
    cat "$1" > "$1.tmp"
    sed "s|$2|$3|" "$1.tmp" > "$1"
    rm "$1.tmp"
}

function add_conf {
    ## check if the content string is present, and add if necessery. Single-line content only.
    ## filename=$1 content=$2

    if [[ -f $1 ]]
    then 
          bak "$1"
    fi

    if grep -q "$2" "$1"
    then
     echo "$1 already has $2"
    else
     echo "adding $2"
     echo "$2" >> "$1"
    fi
}



function finalize {
## run the que's, and do the job's. This is the main function.
  msg "=== Confirmation for ${#asq[*]} commands. [Ctrl-C to abort] ==="
  for item in ${asq[*]}
  do
    (( h++ ))
    run_in_que "$item" #?
  done

  msg "=== Running the Que of ${#que[*]} commands. ==="
  for item in ${que[*]}
  do
    msg "== $item started! =="
    ntc "$item"
    $item
    msg "== $item finished =="
  done

  msg "=== Post-processing tasks ===";
  for item in ${que[*]}
  do
    if [ "$item" == "install_and_finetune_gnome_desktop" ] 
    then
     # run this graphical tool at the end
     if [ -z "$USER" ]; then echo "No user to tune gnome, skipping question." >> "$LOG"; else
        ntc "Starting the gnome Tweak tool."
        su "$USER" -c gnome-tweak-tool
     fi
    fi 
  done
  echo "Finished. $MSG" >> "$LOG"
}

## NOTE: question / function should be consistent

question add_rpmfusion 'The rpmfusion repo contains most of the packages that are needed on a proper workstation, to use proprietary software such as mp3 codecs. Recommended on a workstation.' yes
function add_rpmfusion {
    run dnf -y install --nogpgcheck "http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}


question run_update 'Run a yum update to update all packages?' yes
function run_update {
    run dnf -y update
}

question enable_ssh 'Enable the ssh service, and let users log in via shell.' no
function enable_ssh {
    run dnf -y install fail2ban
    run systemctl start fail2ban.service
    run systemctl enable sshd.service
    run systemctl start sshd.service
}

question disable_selinux "SElinux enhances security by default, but sometimes hard to understand error messages waste your time, especially when selinux is preventing a hack." no
function disable_selinux { 

sed_file /etc/selinux/config "SELINUX=enforcing" "SELINUX=disabled"

}

question limit_bash_history_to_specific_commands 'By default users can use the up and down arrow keys to see their command history. This can be replaced by a set of commands used frequently.' no
function limit_bash_history_to_specific_commands {

    bash_history_path="$USER_HOME/.bash_history"
    bash_profile_path="$USER_HOME/.bash_profile"
    
    add_conf "$bash_profile_path" 'HISTFILE=/dev/null'

    ## The bash history will be limited to these commands
    echo  'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -L 5901:localhost:5901 -N -f -l 
vinagre localhost:1
sudo mc' > "$bash_history_path"

    chmod 644 "$bash_history_path"
}

question disable_caps_lock "Caps lock is one of the biggest keys on the keybord. Annoying when pressed accidentally. Disable it?" no
function disable_caps_lock {
    echo 'setxkbmap -option ctrl:nocaps' >> $USER_HOME/.bashrc
    setxkbmap -option ctrl:nocaps
}

question disable_systemd_pager "Systemd uses a pager, that is unncessery when using a gui terminal." yes
function disable_systemd_pager {
    echo 'export SYSTEMD_PAGER=' >> $USER_HOME/.bashrc
    export SYSTEMD_PAGER=
}



if [ -z "$USER" ] 
then 
     ntc "No user to tune gnome, skipping question."; 
else
     question install_and_finetune_gnome_desktop 'Gnome is the default Desktop enviroment, but you might run another spin. It has some options for customization.' yes
fi

function install_and_finetune_gnome_desktop {

    run dnf -y install @GNOME
    run dnf -y install gnome-tweak-tool dconf-editor 
    run dnf -y install wget #ImageMagick

## gedit
su "$USER" -c "dbus-launch gsettings set org.gnome.gedit.preferences.editor scheme cobalt"
su "$USER" -c "dbus-launch gsettings set org.gnome.gedit.preferences.editor display-line-numbers true"

}

question grab_media_files 'Get some media files? Music, Desktop wallpapers, ...' yes
function grab_media_files {
## get some music
mkdir -p "$USER_HOME/Music"

set_file "$USER_HOME/Music/brfm130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/brfm-128-aac
Title1=SomaFM: Black Rock FM (#1  ): From the Playa to the world, back for the 2015 Burning Man festival.
Length1=-1
File2=http://ice2.somafm.com/brfm-128-aac
Title2=SomaFM: Black Rock FM (#2  ): From the Playa to the world, back for the 2015 Burning Man festival.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/cliqhop64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/cliqhop-64-aac
Title1=SomaFM: cliqhop idm (#1  ): Blipsn beeps backed mostly w/beats. Intelligent Dance Music.
Length1=-1
File2=http://ice1.somafm.com/cliqhop-64-aac
Title2=SomaFM: cliqhop idm (#2  ): Blipsn beeps backed mostly w/beats. Intelligent Dance Music.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/deepspaceone130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/deepspaceone-128-aac
Title1=SomaFM: Deep Space One (#1  ): Deep ambient electronic, experimental and space music. For inner and outer space exploration.
Length1=-1
File2=http://ice2.somafm.com/deepspaceone-128-aac
Title2=SomaFM: Deep Space One (#2  ): Deep ambient electronic, experimental and space music. For inner and outer space exploration.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/dubstep64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/dubstep-64-aac
Title1=SomaFM: Dub Step Beyond (#1  ): Dubstep, Dub and Deep Bass. May damage speakers at high volume.
Length1=-1
File2=http://ice1.somafm.com/dubstep-64-aac
Title2=SomaFM: Dub Step Beyond (#2  ): Dubstep, Dub and Deep Bass. May damage speakers at high volume.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/groovesalad130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/groovesalad-128-aac
Title1=SomaFM: Groove Salad (#1  ): A nicely chilled plate of ambient/downtempo beats and grooves.
Length1=-1
File2=http://ice2.somafm.com/groovesalad-128-aac
Title2=SomaFM: Groove Salad (#2  ): A nicely chilled plate of ambient/downtempo beats and grooves.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/secretagent130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/secretagent-128-aac
Title1=SomaFM: Secret Agent (#1  ): The soundtrack for your stylish, mysterious, dangerous life. For Spies and PIs too!
Length1=-1
File2=http://ice2.somafm.com/secretagent-128-aac
Title2=SomaFM: Secret Agent (#2  ): The soundtrack for your stylish, mysterious, dangerous life. For Spies and PIs too!
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/silent130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/silent-128-aac
Title1=SomaFM: The Silent Channel (#1  ): Chilled ambient electronic music for calm inner atmospheres from Silent Records.
Length1=-1
File2=http://ice2.somafm.com/silent-128-aac
Title2=SomaFM: The Silent Channel (#2  ): Chilled ambient electronic music for calm inner atmospheres from Silent Records.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/thetrip64.pls" '[playlist]
numberofentries=2
File1=http://ice2.somafm.com/thetrip-64-aac
Title1=SomaFM: The Trip (#1  ): Progressive house / trance. Tip top tunes.
Length1=-1
File2=http://ice1.somafm.com/thetrip-64-aac
Title2=SomaFM: The Trip (#2  ): Progressive house / trance. Tip top tunes.
Length2=-1
Version=2' 

set_file "$USER_HOME/Music/u80s130.pls" '[playlist]
numberofentries=2
File1=http://ice1.somafm.com/u80s-128-aac
Title1=SomaFM: Underground 80s (#1  ): Early 80s UK Synthpop and a bit of New Wave.
Length1=-1
File2=http://ice2.somafm.com/u80s-128-aac
Title2=SomaFM: Underground 80s (#2  ): Early 80s UK Synthpop and a bit of New Wave.
Length2=-1
Version=2' 


chown "$USER":"$USER" "$USER_HOME/Music"/*

## Add some wallpapers

mkdir "/home/$USER/Pictures"
cd "/home/$USER/Pictures"

## CC Photo Desktop Wallpapers

run wget -nc http://fc05.deviantart.net/fs50/f/2009/339/0/4/Frozen_Heart____Still_Burning_by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs32/f/2008/233/1/8/Broken_Glass_by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs32/f/2008/232/1/c/Corn__by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs31/f/2008/232/2/a/Butterfly_by_D250Laboratories.jpg
run wget -nc http://fc00.deviantart.net/fs31/f/2008/230/2/9/Clublife_by_D250Laboratories.jpg
run wget -nc http://fc04.deviantart.net/fs31/f/2008/230/3/5/Danceing_Girl_by_D250Laboratories.jpg
run wget -nc http://fc08.deviantart.net/fs32/f/2008/233/6/f/Weed_1_of_4_by_D250Laboratories.jpg
run wget -nc http://fc07.deviantart.net/fs44/f/2009/124/b/3/MicroEye_by_D250Laboratories.jpg
run wget -nc http://fc07.deviantart.net/fs70/f/2009/358/d/6/Merry_Christmas_by_D250Laboratories.jpg
run wget -nc http://fc05.deviantart.net/fs32/f/2008/233/f/a/After_the_rain_by_D250Laboratories.jpg
run wget -nc http://fc02.deviantart.net/fs36/f/2010/006/b/d/Dust_and_Scraches_by_D250Laboratories.jpg
run wget -nc http://fc08.deviantart.net/fs31/f/2008/230/3/7/Leaves_of_the_forest__by_D250Laboratories.jpg

## If you want your backgrounds a bit darker
#mogrify -brightness-contrast -30x-20 *.jpg 

## Standard Destop Wallpapers
run wget -nc http://www.justinmaller.com/img/projects/wallpaper/WP_Pump-2560x1440_00000.jpg

## Feel free to add your pictures here, and you can recommend your favorites too.

chown -R "$USER":"$USER" "/home/$USER/Pictures" 

su "$USER" -c "dbus-launch gsettings set org.gnome.desktop.background picture-uri file:////home/$USER/Pictures/Leaves_of_the_forest__by_D250Laboratories.jpg"

}



if [ -z "$USER" ] 
then 
     ntc "No autologin question."
else
     question set_autologin_for_first_user "User $USER can be enabled to be logged in automatically, without requesting a password when the system is started." no
fi

function set_autologin_for_first_user {

## for GDM 
set_file /etc/gdm/custom.conf '
# GDM configuration storage

[daemon]

AutomaticLoginEnable=True
AutomaticLogin='"$USER"'

[security]

[xdmcp]

[greeter]

[chooser]

[debug]

'

## for lightdm
set_file /etc/lightdm/lightdm.conf '
[LightDM]
minimum-vt=1
user-authority-in-system-dir=true

[SeatDefaults]
xserver-command=X -background none
greeter-session=lightdm-greeter
session-wrapper=/etc/X11/xinit/Xsession

autologin-in-background=true
autologin-user-timeout=0
autologin-user='"$USER"'

[XDMCPServer]

[VNCServer]

'

## for lxdm
    sed_file /etc/lxdm/lxdm.conf "# autologin=dgod" "autologin=$USER"

ntc "Autologin set for $USER"
} 


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


question install_browsers "Google chrome, Flash player, java support is also part of a a proper desktop workstation, even though its propreitary software." yes
function install_browsers {
    # flash player
    run dnf -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-i386-1.0-1.noarch.rpm  http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
    run rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
    run dnf -y update
    run dnf -y install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl

    #install google chrome repository
    set_file /etc/yum.repos.d/google-chrome.repo '[google-chrome]
name=google-chrome - 32-bit
baseurl=http://dl.google.com/linux/chrome/rpm/stable/i386
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub

[google-chrome]
name=google-chrome - 64-bit
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
'
    run dnf -y install google-chrome-stable firefox midori java java-plugin

    ## install Oracle java 7

    cd $TMP
    MACHINE_TYPE="$(uname -m)"
    if [[ "${MACHINE_TYPE}" == 'x86_64' ]]; then
      # 64-bit system
      run wget -nc --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jre-7u51-linux-x64.rpm"
      run dnf -y install jre-7u51-linux-x64.rpm
    else
      # 32-bit system
      run wget -nc --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" "http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jre-7u51-linux-i586.rpm"
      run dnf -y install jre-7u51-linux-i586.rpm
    fi

    ## java ##
    run alternatives --install /USER/bin/java java /USER/java/latest/jre/bin/java 20000
    ## javaws ##
    run alternatives --install /USER/bin/javaws javaws /USER/java/latest/jre/bin/javaws 20000

    ## Java Browser (Mozilla) Plugin 32-bit ##
    run alternatives --install /USER/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /USER/java/latest/jre/lib/i386/libnpjp2.so 20000

    ## Java Browser (Mozilla) Plugin 64-bit ##
    run alternatives --install /USER/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /USER/java/latest/jre/lib/amd64/libnpjp2.so 20000

    mkdir /opt/google/chrome/plugins
    cd /opt/google/chrome/plugins

    if [ -f /USER/java/latest/lib/amd64/libnpjp2.so ];
    then
     ln -s /USER/java/latest/lib/amd64/libnpjp2.so .
    fi

    if [ -f /USER/java/latest/lib/i386/libnpjp2.so ];
    then
     ln -s /USER/java/latest/lib/i386/libnpjp2.so .
    fi
    
    ## TODO java 8 https://www.if-not-true-then-false.com/2014/install-oracle-java-8-on-fedora-centos-rhel/
}

question install_alternative_lightweight_desktop_xfce "XFCE? - Lightweight desktops with some traditional look might come handy on a less powerful computer. XFCE and LXDE are such Desktop enviroments." no
function install_alternative_lightweight_desktop_xfce {
    run dnf -y install @XFCE
}
question install_alternative_lightweight_desktop_lxde "LXDE? - Lightweight desktops with some traditional look might come handy on a less powerful computer. XFCE and LXDE are such Desktop enviroments." no
function install_alternative_lightweight_desktop_lxde {
    run dnf -y install @LXDE
}

question install_office_suite "Libre office is a proper Office suite, that fits most users." yes
function install_office_suite {

    ## LibreOffice 
    run dnf -y groupinstall "Office"
    run dnf -y install libreoffice-writer libreoffice-calc libreoffice-langpack-de libreoffice-langpack-hu
    run dnf -y install dia dia-Digital dia-electronic 
    run dnf -y install scribus
}

question install_kingsoft_office "Community version of Kingsoft Wps-Office, a MS office clone with high compatibilty to the MS formats." yes
function install_kingsoft_office {

    ## Kingsoft Office
     MACHINE_TYPE="$(uname -m)"
    if [[ "${MACHINE_TYPE}" == 'x86_64' ]] 
    then
          run wget "http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office-10.1.0.5672-1.a21.x86_64.rpm"
          run dnf -y install wps-office-10.1.0.5672-1.a21.x86_64.rpm 
    else
          run wget "http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office-10.1.0.5672-1.a21.i686.rpm"
          run dnf -y install wps-office-10.1.0.5672-1.a21.i686.rpm
    fi
}

question install_graphics_tools "Inkscape is powerful vector graphic editor. Darktable can process RAW photos. Gimp is a GNU Image manipulation progran. Blender is for 3D, Dia is a diagram editor." yes
function install_graphics_tools {

    run dnf -y install gimp 
    run dnf -y install darktable 
    run dnf -y install inkscape 
    run dnf -y install dia 
    run dnf -y install blender
    #dnf -y install gimp-data-extras gimpfx-foundry gimp-lqr-plugin gimp-resynthesizer gnome-xcf-thumbnailer phatch nautilus-phatch

}

question install_media_players "Amarok is a cool media player, and VLC has also some unique features. Download youtube videos with youtube-dl,.." yes
function install_media_players {

    run dnf -y install vlc vlc-plugin-jack 
    run dnf -y install amarok
    run dnf -y install youtube-dl
}

question install_media_editors "Edit videos with Kdenlive, sound files with Audacity, .. " no
function install_media_editors {

    run dnf -y install kdenlive 
    run dnf -y install audacity-freeworld 
    
}

question install_media_producer_tools "Compose multitrack soundtracks with Ardour,.. use mixxx to create your mixes." no
function install_media_producer_tools {
 
    run dnf -y install ardour3
    run dnf -y install qjackctl a2jmidid alsa-tools ffado alsa-plugins-jack jack-audio-connection-kit-dbus vlc-plugin-jack pulseaudio-module-jack
    run dnf -y install mixxx
}

question install_spotify "Spotify is a music-streaming service, would you like to install the client?" no
function install_spotify {

    run dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo
    run dnf -y install spotify-client
}

question install_dropbox "Dropbox is a popular file sharing service." no
function install_dropbox {

    #dnf -y install caja-dropbox 
    run dnf -y install nautilus-dropbox

}

question install_chattools "Mumble is a useful free VOIP program, pidgin is a multiprotocol chat client." yes
function install_chattools {

    run dnf -y install pidgin 
    run dnf -y install mumble 

}


question install_skype "Install Skype, the chat program?" yes
function install_skype {
     run dnf config-manager --add-repo https://repo.skype.com/data/skype-stable.repo
     run dnf -y install skypeforlinux
}


question install_devtools "Software development tools are for programmers and hackers. " no
function install_devtools {

    ## TODO make it more complete

    # The generic Development tools compilation from fedora.
    run dnf -y groupinstall "Development Tools"

    # some more enviroments
    run dnf -y install netbeans
    run dnf -y install eclipse
    run dnf -y install geany
    run dnf -y install cssed
    run dnf -y install anjuta

    # Networking development
    run dnf -y install wireshark

    # some tools for ruby programming
    run dnf -y install rubygem-sinatra rubygem-shotgun rubygem-rails rubygem-passenger

    # For local web development. Apache and stuff.
    run dnf -y install httpd 
    run dnf -y install phpMyAdmin 
    run dnf -y install nginx 
    run dnf -y install nodejs
    run dnf -y install npm
    run dnf -y install ShellCheck
    
    # compilers
    run dnf -y install gcc-c++

}

question install_virtualbox "Use virtualbox to emulate windows or any other operating system. (please reboot first, if you have update the kernel.)" no
function install_virtualbox { 

    run dnf -y remove VirtualBox
    run dnf -y install kernel binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms

    run wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
    run dnf -y install VirtualBox-5.1
    run usermod -a -G vboxusers "$USER"
    
    if [ "$(rpm -qa kernel |sort -V |tail -n 1)" == "kernel-$(uname -r)" ]
    then
        msg "Kernel is OK! starting vboxdrv"
        run /usr/lib/virtualbox/vboxdrv.sh setup

    else
        err "You are not running the latest kernel! Please reboot and start this command again."
    fi

}

question install_steam "Steam is a gaming platform. Installs rpmfusion nvidia drivers as well."
function install_steam {

    add_rpmfusion

    run dnf -y install steam
    run dnf -y install vulkan
    
    if lspci | grep -E "VGA|3D" | grep NVIDIA
    then
        echo "You appear to have an Nvidia card."
        if glxinfo | grep 'server glx vendor string: NVIDIA Corporation'
        then
            echo "It appears to be installed already."
        else
            run dnf -y install xorg-x11-drv-nvidia akmod-nvidia kernel-devel
            run dnf -y install xorg-x11-drv-nvidia-libs.i686
        fi
    fi
}

## Finalize will do the job!
finalize
exit
