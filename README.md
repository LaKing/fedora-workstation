## Fedora workstation installer
Scripts to help your workstation getting running fast.
It asks some questions, and runds the corresponding installs then automatically. 
Trying to keep it up to date as good as I can.

## Prepare
It is recommended to get your system up to date before running the installer.
```bash
sudo dnf -y update
reboot
```
## Start with
```bash
curl https://codeload.github.com/LaKing/fedora-workstation/zip/refs/heads/master > fedora-workstation-installer.zip && \
rm -fr fedora-workstation-master && \ 
unzip fedora-workstation-installer.zip && \ 
cd fedora-workstation-master && \
bash install-workstation.sh
```

## Answer questions with yes or no - or leave the default value (capital letter)
```
The rpmfusion repo contains most of the packages that are needed on a proper workstation, to use proprietary software such as mp3 codecs. Recommended on a workstation.
add rpmfusion?  [Y/n] yes

Run a yum update to update all packages?
run update?  [Y/n] yes

```
 .. and so on.