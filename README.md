## fedora-install-workstation

## Start with
```bash
curl https://raw.githubusercontent.com/LaKing/fedora-workstation/master/install-workstation.sh | bash -
```

### answer questions with yes or no - or leave the default value
```
The rpmfusion repo contains most of the packages that are needed on a proper workstation, to use proprietary software such as mp3 codecs. Recommended on a workstation.
add rpmfusion?  [Y/n] yes

Run a yum update to update all packages?
run update?  [Y/n] yes

Enable the ssh service, and let users log in via shell.
enable ssh?  [y/N] no

SElinux enhances security by default, but sometimes hard to understand error messages waste your time, especially when selinux is preventing a hack.
disable selinux?  [y/N] no

By default users can use the up and down arrow keys to see their command history. This can be replaced by a set of commands used frequently.
limit bash history to specific commands?  [y/N] no

Gnome is the default Desktop enviroment, but you might run another spin. It has some options for customization.
install and finetune gnome desktop?  [Y/n] yes

Get some media files? Music, Desktop wallpapers, ...
grab media files?  [Y/n] yes

User x can be enabled to be logged in automatically, without requesting a password when the system is started.
set autologin for first user?  [y/N] no

There are some basic tools in a proper workstation, such a system monitoring tools, or the Disks tool, exfat support, gkrellm, filezilla, extra vnc clients, brasero, zip, rar, ..
install basic system tools?  [Y/n] yes

Google chrome, Flash player, java support is also part of a a proper desktop workstation, even though its propreitary software.
install browsers?  [Y/n] yes

XFCE? - Lightweight desktops with some traditional look might come handy on a less powerful computer. XFCE and LXDE are such Desktop enviroments.
install alternative lightweight desktop xfce?  [y/N] no

LXDE? - Lightweight desktops with some traditional look might come handy on a less powerful computer. XFCE and LXDE are such Desktop enviroments.
install alternative lightweight desktop lxde?  [y/N] no

Libre office is a proper Office suite, that fits most users.
install office suite?  [Y/n] yes

Community version of Kingsoft Wps-Office, a MS office clone with high compatibilty to the MS formats.
install kingsoft office?  [Y/n] yes

Inkscape is powerful vector graphic editor. Darktable can process RAW photos. Gimp is a GNU Image manipulation progran. Blender is for 3D, Dia is a diagram editor.
install graphics tools?  [Y/n] yes

Amarok is a cool media player, and VLC has also some unique features. Download youtube videos with youtube-dl,..
install media players?  [Y/n] yes

Edit videos with Kdenlive, sound files with Audacity, .. 
install media editors?  [y/N] no

Compose multitrack soundtracks with Ardour,.. use mixxx to create your mixes.
install media producer tools?  [y/N] no

Dropbox is a popular file sharing service.
install dropbox?  [y/N] no

Mumble is a useful free VOIP program, pidgin is a multiprotocol chat client.
install chattools?  [Y/n] yes

Skype is bought by MS, however a lot of people use it, and it might be need to stay connected. Currently, the installation process will ask for the root password.
install skype?  [y/N] no

Software development tools are for programmers and hackers. 
install devtools?  [y/N] no

Use virtualbox to emulate windows or any other operating system. (please reboot first, if you have update the kernel.)
install virtualbox?  [y/N] no
```
