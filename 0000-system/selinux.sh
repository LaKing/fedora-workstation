question disable_selinux "SElinux enhances security by default, but sometimes hard to understand error messages waste your time, especially when selinux is preventing a hack." no
function disable_selinux { 

sed_file /etc/selinux/config "SELINUX=enforcing" "SELINUX=disabled"

}