if [ -z "$USER" ] 
then 
     ntc "No autologin question."
else
     question set_autologin_for_first_user "User $USER can be enabled to be logged in automatically, without requesting a password when the system is started." no
fi

function set_autologin_for_first_user {

passwd -d "$USER"

if [[ -f /etc/gdm/custom.conf ]]
then
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
fi

if [[ -f /etc/lightdm/lightdm.conf ]]
then
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
fi

if [[ -f /etc/lxdm/lxdm.conf ]]
then
## for lxdm
    sed_file /etc/lxdm/lxdm.conf "# autologin=dgod" "autologin=$USER"
fi
ntc "Autologin set for $USER"
} 