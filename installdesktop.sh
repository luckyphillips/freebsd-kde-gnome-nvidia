#!/bin/sh
if ! [ $(id -u) = 0 ]; then
   echo -e "\n\n****  You must run this script as ROOT user  ****\n\n"
   exit 1
fi

INSTALLGNOME()
{
            case $1 in
                    1)
#                             echo 'kld_list="nvidia"' >> /etc/rc.conf
                            pkg install -y nvidia-driver-390* linux-nvidia-libs-390* gnome3 gdm xorg libgnomeui xf86-video-intel nvidia-xconfig nvidia-settings bash gsettings-desktop-schemas
                            echo "/root/installdesktop.sh 2 1" > /usr/local/etc/rc.d/installMYkde.sh
                            reboot
                            exit 1
                    ;;
                    *)
#                             echo 'kld_list="nvidia-modeset"' >> /etc/rc.conf
                            pkg install -y nvidia-driver linux-nvidia-libs gnome3 gdm xorg libgnomeui xf86-video-intel nvidia-xconfig nvidia-settings bash gsettings-desktop-schemas
                            echo "/root/installdesktop.sh 2 2" > /usr/local/etc/rc.d/installMYkde.sh
                            reboot
                            exit 1
                    ;;
            esac
}




INSTALLKDE()
{
            case $1 in
                    1)
#                             echo 'kld_list="nvidia"' >> /etc/rc.conf
                            pkg install -y nvidia-driver-390* linux-nvidia-libs-390* kde5 sddm xorg xf86-video-intel plasma5-plasma-desktop nvidia-xconfig nvidia-settings bash
                            echo "/root/installdesktop.sh 2 1" > /usr/local/etc/rc.d/installMYkde.sh
                            reboot
                            exit 1
                    ;;
                    *)
#                             echo 'kld_list="nvidia-modeset"' >> /etc/rc.conf
                            pkg install -y nvidia-driver linux-nvidia-libs kde5 sddm xorg xf86-video-intel plasma5-plasma-desktop nvidia-xconfig nvidia-settings bash
                            echo "/root/installdesktop.sh 2 2" > /usr/local/etc/rc.d/installMYkde.sh
                            reboot
                            exit 1
                    ;;
            esac
}






INSTALLIT()
{
if ! grep -Fxq "net.local.stream.recvspace=65536" /etc/sysctl.conf 
then
    echo "net.local.stream.recvspace=65536" >> /etc/sysctl.conf    
fi

if ! grep -Fxq "net.local.stream.sendspace=65536" /etc/sysctl.conf
then
    echo "net.local.stream.sendspace=65536" >> /etc/sysctl.conf
fi


if ! grep -Fxq "proc /proc procfs rw 0 0" /etc/fstab
then
    echo "proc /proc procfs rw 0 0" >> /etc/fstab 
fi

if ! grep -Fxq "linprocfs   /compat/linux/proc  linprocfs       rw      0       0" /etc/fstab
then
    echo "linprocfs   /compat/linux/proc  linprocfs       rw      0       0" >> /etc/fstab 
fi

if ! grep -Fxq "linsysfs    /compat/linux/sys   linsysfs        rw      0       0" /etc/fstab
then
    echo "linsysfs    /compat/linux/sys   linsysfs        rw      0       0" >> /etc/fstab 
fi

if ! grep -Fxq "tmpfs    /compat/linux/dev/shm  tmpfs   rw,mode=1777    0       0" /etc/fstab
then
    echo "tmpfs    /compat/linux/dev/shm  tmpfs   rw,mode=1777    0       0" >> /etc/fstab 
fi


case $1 in
        1)
if ! grep -Fxq "gnome_enable=yes" /etc/rc.conf
then
    echo "gnome_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "gdm_enable=yes" /etc/rc.conf
then
    echo "gdm_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "mouse_enable=yes" /etc/rc.conf
then
    echo "mouse_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "hald_enable=yes" /etc/rc.conf
then
    echo "hald_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "dbus_enable=yes" /etc/rc.conf
then
    echo "dbus_enable=yes" >> /etc/rc.conf
fi
            INSTALLGNOME $2            
        ;;
        2)
if ! grep -Fxq "sddm_enable=yes" /etc/rc.conf
then
    echo "sddm_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "mouse_enable=yes" /etc/rc.conf
then
    echo "mouse_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "hald_enable=yes" /etc/rc.conf
then
    echo "hald_enable=yes" >> /etc/rc.conf
fi

if ! grep -Fxq "dbus_enable=yes" /etc/rc.conf
then
    echo "dbus_enable=yes" >> /etc/rc.conf
fi
            INSTALLKDE $2
        ;;     
esac
}


STEPONE()
{
cat << EOF 

Installing all files needed for your desktop.
Once you choose the desktop, this will take quite a while to install.

Would you like to install (K)DE or (G)NOME?
    
    Default = (K)DE

EOF
read GETDESKTOP
case $GETDESKTOP in
        [Gg]*)
            SETDESKTOP=1
        ;;
        *)
            SETDESKTOP=2
        ;;            
esac

echo "Does your system have an (O)lder graphics card or a (N)ewer card? Newer = at least a nvidia gtx1050. Default (N)ewer GPU"
read GETGPUCARD
case $GETGPUCARD in
        [Oo]*)
            echo 'kld_list="nvidia"' >> /etc/rc.conf
            SETGPUCARD=1
        ;;
        *)
            echo 'kld_list="nvidia-modeset"' >> /etc/rc.conf
            SETGPUCARD=2
        ;;            
esac

sysrc linux_enable=yes
pkg update

if [ ! -d "/usr/local/etc/rc.d/" ]
then
    mkdir -p /usr/local/etc/rc.d/
fi
cp $PWD/installdesktop.sh /root/installdesktop.sh
echo "/root/installdesktop.sh 1 $SETDESKTOP $SETGPUCARD" > /usr/local/etc/rc.d/installMYkde.sh
chmod +x /usr/local/etc/rc.d/installMYkde.sh
chmod +x /root/installdesktop.sh
reboot
exit 1

}



if [ -z "$1" ]
then
clear

cat << EOF




***********************************************

           Starting Desktop Install
       
        *** Run script at own risk! ***
    (I take NO responsibility to this script)

 
Before running this script (or any script), 
please read through it to understand what is 
happening when you agree to the questions

This script will alter to the following files 
    
    /etc/rc.conf
    /etc/fstab
    /etc/sysctl.conf
    
This script will reboot your computer twice, 
enable_linux to your system, 
add directories and take a long time to install 
everything depending on your internet speed
       

             CONTINUE? (y/N)
       
       
***********************************************

EOF

read var_Continue

case $var_Continue in
        [Yy]*)
            echo ""
            echo "Let's DO IT!"
            echo ""
            STEPONE
		;;
        *)
            echo "Exiting..."
            exit 1
		;;
esac
fi


if [ "$1" = "1" ];then
INSTALLIT $2 $3
fi

if [ "$1" = "2" ];then

if [ "$2" = "1" ];then
pkg install -fy gsettings-desktop-schemas
fi
/usr/local/bin/nvidia-xconfig
rm /root/installdesktop.sh
rm /usr/local/etc/rc.d/installMYkde.sh
reboot
exit 1
fi

