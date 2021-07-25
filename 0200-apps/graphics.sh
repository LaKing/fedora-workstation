question install_graphics_tools "Inkscape is powerful vector graphic editor. Darktable can process RAW photos. Gimp is a GNU Image manipulation progran. Blender is for 3D, Dia is a diagram editor." yes
function install_graphics_tools {

    run dnf -y install gimp 
    run dnf -y install darktable 
    run dnf -y install inkscape 
    run dnf -y install dia 
    run dnf -y install blender
    #dnf -y install gimp-data-extras gimpfx-foundry gimp-lqr-plugin gimp-resynthesizer gnome-xcf-thumbnailer phatch nautilus-phatch

}