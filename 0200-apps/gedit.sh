question customize_gedit "Customize GEdit to Cobalt theme, with line numbers?" yes
function customize_gedit {	

## gedit
su "$USER" -c "dbus-launch gsettings set org.gnome.gedit.preferences.editor scheme cobalt"
su "$USER" -c "dbus-launch gsettings set org.gnome.gedit.preferences.editor display-line-numbers true"

}