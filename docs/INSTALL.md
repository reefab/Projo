# Installation guide

This is mostly a guide tailored for the TP-Link TL-MR3020 but is also
applicable to most OpenWRT installation.

## Install OpenWRT Barrier Breaker on TP-Link TL-MR3020

Follow the instructions on Openwrt's [wiki article](http://wiki.openwrt.org/toh/tp-link/tl-mr3020#installation) until you get a SSH connection to the router.

## Network configuration

### Wifi

`/etc/config/wireless`

Comment the following line:

    # option disabled 1

Make it a wireless client:

     config wifi-iface
            option device   radio0
            option network  wlan
            option mode     sta
            option ssid     <SSID>
            option encryption psk2
            option key <password>

Add the network interface configuration in `/etc/config/network`

    config interface 'wlan'
            option proto 'dhcp'

Add wlan interface to firewall rules: `/etc/config/firewall`

    config zone
            option name             lan
            option network          'lan wlan'

Disable dhcp server for wlan:

`/etc/config/dhcp`

    config dhcp wlan
            option ignore   1

Note that I haven't been able to have both Ethernet and Wifi connected to the
same network at the same time. If you want to use wifi, reboot and unplug the
ethernet cable.

### Wired network


Disable static ip for wired network:

`/etc/config/network`

    config interface 'lan'
            option ifname 'eth0'
            option proto 'dhcp'

Disable dhcp server for lan:

`/etc/config/dhcp`

    config dhcp lan
            option ignore   1        

> ### Auto-discovery

> Add auto-discovery via [bonjour](http://en.wikipedia.org/wiki/Bonjour_(software).

> Install avahi

>     opkg install avahi daemon

> édit `/etc/avahi/avahi-daemon.conf`

> add `enable-dbus=no` into the `[server]` section as follow:

>     [server]
>     #host-name=foo
>     #domain-name=local
>     use-ipv4=yes
>     use-ipv6=no
>     check-response-ttl=no
>     use-iff-running=no
>     enable-dbus=no

> Start avahi at boot: 

>     /etc/init.d/avahi-daemon enable
>     /etc/init.d/avahi-daemon start

## Serial port

Comment this line in `/etc/inittab` so we can free the serial port for our use instead of a console:

    ::askconsole:/bin/ash --login

## Install

Copy the .ipk package file to your device and install it.

    opkg install luci-app-projo*.ipk

This will install the dependencies.

Copy the ser2net `ser2net.conf.example` config file to `/etc/ser2net.conf`.
Copy the ser2net `ser2net.init` init script to `/etc/init.d/ser2net`.

Activate the init script:

    /etc/init.d/ser2net enable
    /etc/init.d/ser2net start
    
Enable uhttpd built-in lua interpreter for much faster requests.

    uci set uhttpd.main.lua_prefix=/luci
    uci set uhttpd.main.lua_handler=/usr/lib/lua/luci/sgi/uhttpd.lua/
    /etc/init.d/uhttpd enable
    /etc/init.d/uhttpd start

## All done!

Sit down, relax, take the batteries out of your remote and switch your
projector on like a 21st century denizen.
