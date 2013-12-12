# Installation guide

This is mostly a guide tailored for the Raspberry Pi but is also valid for
other Debian based setups.

## Auto-discovery

Add auto-discovery via [bonjour](http://en.wikipedia.org/wiki/Bonjour_(software).

Install avahi

    apt-get install avahi-daemon

## Serial port

If you are not using the built-in serial port of the Raspberry Pi, you can skip
this step.

Comment this line in `/etc/inittab` so we can free the serial port for our use instead of a console:

    #T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100

## Python

Install required python packages:

    apt-get install install python python-flask python-serial

I normally would install the Python packages via pip as it's a saner way of
doing this but in that case it's simpler and quicker to use apt-get.

## Install

Copy and untar the release files in `/srv/projo` for example:

    mkdir -p /srv/projo/
    cd /srv/projo
    tar xfvzp ~/projo-XX.tar.gz

copy the init script:

    cp projo.init /etc/init.d/
    update-rc.d projo defaults

## All done!

Sit down, relax, take the batteries out of your remote and switch your
projector on like a 21st century denizen.

## Build and Deployment

### Building

You'll need node installed on your local machine beforehand.

    npm -g install # Will install all the dependencies needed for development
    bower install # Will install the dependencies for runtime

To build:

    grunt build

To launch a server with auto-reloading and live-reload.

    grunt server

### Deploying

You'll need fabric on your computer beforehand:

    pip install fabric
    fab projo deploy
