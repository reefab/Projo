# Installation guide

This is mostly a guide tailored for the TP-Link TL-MR3020 but is also
applicable to most OpenWRT instalation or more mainstream Linux distributions.

## Install OpenWRT on TP-Link TL-MR3020

Follow the instructions on Openwrt's [wiki article](http://wiki.openwrt.org/toh/tp-link/tl-mr3020#installation) until you get a SSH connection to the router.

## Network configuration

### Wifi

`/etc/config/wireless`
 
Comment the following line:

    # option disabled 1               

Make it a wireless client:

     config wifi-iface
            option device   radio0
            option network  lan
            option mode     sta
            option ssid     <SSID> 
            option encryption psk2
            option key <password>
        
### Wired network

Disable dhcp server for lan: 

`/etc/config/dhcp`

    config dhcp lan
            option ignore   1        

Disable static ip for wired network:

`/etc/config/network`

    config interface 'lan'
            option ifname 'eth0'
            option proto 'dhcp'
    
Add wlan interface to firewall rules: `/etc/config/firewall`

    config zone
            option name             lan
            option network          'lan wlan'

### Auto-discovery

Add auto-discovery via [bonjour](http://en.wikipedia.org/wiki/Bonjour_(software).

Install avahi

    opkg install avahi daemon

édit `/etc/avahi/avahi-daemon.conf`

add `enable-dbus=no` into the `[server]` section as follow:

    [server]
    #host-name=foo
    #domain-name=local
    use-ipv4=yes
    use-ipv6=no
    check-response-ttl=no
    use-iff-running=no
    enable-dbus=no

Start avahi at boot: 

    ln -s /etc/init.d/avahi-daemon /etc/rc.d/S99avahi

## Storage
        
As the 4MB of flash built in into the router won't be enough for our needs,
let's add more space using a usb key.
Create an ext4 partition on usb key using another computer and plug it afterwards
on the router.

Install usb storage support packages:

    opkg update
    opkg install kmod-usb-storage block-mount kmod-fs-ext4

    mkdir /mnt/usb
    mount /dev/sda1 /mnt/usb

    # copy existing overlay to the usb key
    tar -C /overlay -cvf - . | tar -C /mnt/usb -xf -

Edit `/etc/config/fstab` to configure this partition as the new overlay

    config mount
            option target        /overlay
            option device        /dev/sda1
            option fstype        ext4
            option options       rw,sync
            option enabled       1
            option enabled_fsck  0
        
Reboot and you should see something like that:

    root@OpenWrt:~# df -h /
    Filesystem                Size      Used Available Use% Mounted on
    rootfs                    3.7G    122.3M      3.4G   3% /

Now there is a bunch of free space instead of having to fit everything in 4M

## Web server

Install required python packages:

    opkg install distribute python-openssl python pyserial
    easy_install pip

## Serial port

Comment this line in `/etc/inittab` so we can free the serial port for our use instead of a console:

    #ttyATH0::askfirst:/bin/ash --login
