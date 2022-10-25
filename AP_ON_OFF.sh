#! /bin/bash
arg1=$1

if [ $arg1 == "ON" ] ; then
        sed -i '60,64 s/^#*//'  /etc/dhcpcd.conf  &&
        systemctl daemon-reload &&
        service dhcpcd restart &&
        systemctl start dnsmasq &&
        systemctl start hostapd &&
        systemctl enable dnsmasq &&
        systemctl enable hostapd
elif [ $arg1 == "OFF" ] ; then
        systemctl stop dnsmasq &&
        systemctl stop hostapd &&
        systemctl disable dnsmasq &&
        systemctl disable hostapd &&
        sed -i '60,64 s/^/#/'  /etc/dhcpcd.conf &&
        systemctl daemon-reload &&
        service dhcpcd restart &&
        echo "Restart wpa_supplicant" &&
        sudo pkill wpa_supplicant &&
        sleep 2 &&
        sudo wpa_supplicant -c/etc/wpa_supplicant/wpa_supplicant.conf -iwlan0 -B -Dnl80211,wext
else
        printf "UNKNOWN input."
fi
