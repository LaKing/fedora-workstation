question disable_caps_lock "Caps lock is one of the biggest keys on the keybord. Annoying when pressed accidentally. Disable it?" no
function disable_caps_lock {
    echo 'setxkbmap -option ctrl:nocaps' >> $USER_HOME/.bashrc
    setxkbmap -option ctrl:nocaps
}