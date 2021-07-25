question disable_systemd_pager "Systemd uses a pager, that is unncessery when using a gui terminal." yes
function disable_systemd_pager {
    echo 'export SYSTEMD_PAGER=' >> $USER_HOME/.bashrc
    export SYSTEMD_PAGER=
}