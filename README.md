#Install KDE or Gnome on Freebsd with nvidia card 

#This will install KDE or Gnome on a fresh built version of Freebsd. 

#Run as su



git clone https://github.com/luckyphillips/freebsd-kde-gnome-nvidia/

cd freebsd-kde-gnome-nvidia

chmod +x installdesktop.sh

./installdesktop.sh




#IF YOU HAVE ISSUES AFTER THE INSTALL, try running these 2 commands again, then reboot.

#if you've installed gnome

pkg install -fy gsettings-desktop-schemas

#For either install you may need to rerun this

nvidia-xconfig 

