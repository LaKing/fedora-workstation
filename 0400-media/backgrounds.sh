question grab_wallpaper_files 'Get some media files? Music, Desktop wallpapers, ...' yes
function grab_wallpaper_files {


## Add some wallpapers

mkdir "/home/$USER/Pictures"
cd "/home/$USER/Pictures"

## CC Photo Desktop Wallpapers

run wget -nc http://fc05.deviantart.net/fs50/f/2009/339/0/4/Frozen_Heart____Still_Burning_by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs32/f/2008/233/1/8/Broken_Glass_by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs32/f/2008/232/1/c/Corn__by_D250Laboratories.jpg
run wget -nc http://fc06.deviantart.net/fs31/f/2008/232/2/a/Butterfly_by_D250Laboratories.jpg
run wget -nc http://fc00.deviantart.net/fs31/f/2008/230/2/9/Clublife_by_D250Laboratories.jpg
run wget -nc http://fc04.deviantart.net/fs31/f/2008/230/3/5/Danceing_Girl_by_D250Laboratories.jpg
run wget -nc http://fc08.deviantart.net/fs32/f/2008/233/6/f/Weed_1_of_4_by_D250Laboratories.jpg
run wget -nc http://fc07.deviantart.net/fs44/f/2009/124/b/3/MicroEye_by_D250Laboratories.jpg
run wget -nc http://fc07.deviantart.net/fs70/f/2009/358/d/6/Merry_Christmas_by_D250Laboratories.jpg
run wget -nc http://fc05.deviantart.net/fs32/f/2008/233/f/a/After_the_rain_by_D250Laboratories.jpg
run wget -nc http://fc02.deviantart.net/fs36/f/2010/006/b/d/Dust_and_Scraches_by_D250Laboratories.jpg
run wget -nc http://fc08.deviantart.net/fs31/f/2008/230/3/7/Leaves_of_the_forest__by_D250Laboratories.jpg

## If you want your backgrounds a bit darker
#mogrify -brightness-contrast -30x-20 *.jpg 

## Standard Destop Wallpapers
run wget -nc http://www.justinmaller.com/img/projects/wallpaper/WP_Pump-2560x1440_00000.jpg

## Feel free to add your pictures here, and you can recommend your favorites too.

chown -R "$USER":"$USER" "/home/$USER/Pictures" 

su "$USER" -c "dbus-launch gsettings set org.gnome.desktop.background picture-uri file:////home/$USER/Pictures/Leaves_of_the_forest__by_D250Laboratories.jpg"

}

