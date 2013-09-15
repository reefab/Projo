# Installation guide

This is mostly a guide tailored for the TP-Link TL-MR3020 but is also
applicable to most OpenWRT installation or more mainstream Linux distributions.

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
        
As the 4MB of flash built-in into the router won't be enough for our needs,
let's add more space using a usb key.
Create an ext4 partition on usb key using another computer and plug it afterwards
on the router. Also create a small swap partition that will be only used
punctually.

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

## Serial port

Comment this line in `/etc/inittab` so we can free the serial port for our use instead of a console:

    #ttyATH0::askfirst:/bin/ash --login

## Python

Install required python packages:

    opkg install distribute python-openssl python pyserial

Activate the swap partition created previously:

    swapon /dev/sda2

## Install

Install Flask 

    easy_install Flask

Copy and untar the release files in `/srv/projo` for example:

    mkdir -p /srv/projo/
    cd /srv/projo
    tar xfvzp ~/projo-XX.tar.gz

copy the init script:

    cp projo /etc/init.d/

Enable the service, after disabling the built-in webserver that's hogging the
80 port all for itself:

    /etc/init.d/uhttpd stop
    /etc/init.d/uhttpd disable
    /etc/init.d/projo start
    /etc/init.d/projo enable

## All done!

Sit down, relax, take the batteries out of your remote and switch your
projector on like a 21st century denizen.

## Build and Deployement

### Building

You'll need node installed on your local machine beforehand.

    npm -g install # Will install all the dependencies needed for development
    bower install # Will install the dependencies for runtime

To build:

    grunt build

To launch a server with auto-reloading and livereload

    grunt server

### Deploying

You'll need fabric on your computer beforehand:

    pip install fabric

There is a few issues that needs to be fixed for automatic deployement:

First, ssh key auth: your public key needs to be in
`/etc/dropbear/authorized_keys`.

Then, as Dropbear doesn't provide a SFTP server, you can use just this part
from openssh with this very convenient package:

Install `openssh-sftp-server` on the router:

    opkg update
    opkg install openssh-sftp-server

Now, you just need to do:

    fab projo deploy

