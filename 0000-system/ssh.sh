question enable_ssh 'Enable the ssh service, and let users log in via shell.' no
function enable_ssh {
    #run dnf -y install fail2ban
    run systemctl start fail2ban.service
    run systemctl enable sshd.service
    run systemctl start sshd.service
}