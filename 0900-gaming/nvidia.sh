if lspci | grep -E "VGA|3D" | grep NVIDIA
then
    question install_nvidia "Install the nvidia drivers from rpmfusion?"
fi

function install_nvidia {
   
    add_rpmfusion

        if glxinfo | grep 'server glx vendor string: NVIDIA Corporation'
        then
            echo "It appears to be installed already."
        else
            run dnf -y install xorg-x11-drv-nvidia akmod-nvidia xorg-x11-drv-nvidia-cuda kernel-devel
            run dnf -y install xorg-x11-drv-nvidia-libs.i686
        fi
}