# Projo

![Logo](ios-webapp-baseimage.png)

A server and mobile web app I made to control my video projector without a
remote.

I can now switch the projector on/off, navigate the menu and blank the screen
using my phone (or other web-enabled device).

This device delivers a RESTful web-service as an interface to the video
projector via serial commands (Crestron protocol) and a web app that I use
on my mobile devices to replace the remote.

This version is made for Raspberry Pi and any \*nix running computer with a RS232 connector) and the
Crestron protocol seems to be common to multiple brand of AV equipment.

A version specially made for OpenWRT devices is avaible in the default branch.

## Software

![Screenshot](screenshot.png)

 * Web Server: [Flask](http://flask.pocoo.org)
 * Web App: [AngularJS](http://angularjs.org)

[Bonjour](http://en.wikipedia.org/wiki/Bonjour_%28software%29) is used for
auto-discovery so I just need to go the http://projo.local/ url on my mobile
devices and optionally add the App to the Home Screen.

Once launched there is a few buttons on the top and bottom. The dark area in
the center is a gesture interface to the menu. Swipe left/right/up/down
navigate in the menu, a tap select an item. The back button goes back one level.

AngularJS has been selected because I needed an excuse to play with it. It's used
in conjunction with [CoffeeScript](http://coffeescript.org), [Compass](http://compass-style.org), [Yeoman](http://yeoman.io), [Grunt](http://gruntjs.com) and [Bower](http://bower.io).

## Hardware

Serial cable on projector below ceiling...

![Serial cable on projector below ceiling...](http://farm3.staticflickr.com/2890/9703297446_a1c43fa01d_c.jpg)

You have two choices:

### Using the built-in serial port of the Raspberry Pi

The board is a simple [MAX232](http://en.wikipedia.org/wiki/MAX232) based TTL
to RS232 adapter. The UART on the Raspberry works at 3.3V so the MAX232 converts
it to signals compatible with other RS232 devices. You can find them on eBay
for a pittance by searching for "TTL to RS232".

Do note that you'll need a straight DB9<->DB9 male-female cable (or you'll
spend a few days wondering why it doesn't work with a null-modem cable, not
that it happened to me...).

Here is the pinout of the Raspberry Pi: [GPIO Pinout](http://elinux.org/RPi_Low-level_peripherals#General_Purpose_Input.2FOutput_.28GPIO.29).

* 5V from the GPIO goes to the 5V pin on the board (I added hotglue to secure
  it after soldering)
* Ground from the GPIO goes to the ground pin on the board
* RX on the GPIO goes to TX on the board
* TX on the GPIO goes to RX on the board

If that seems dauting, look at the second option.

### Using a usb-serial adapter

You can also just use a usb to serial cable along with a null-modem cable (but
where is the fun in that?).

## Installation

Here is a detailed [installation guide](INSTALL.md) that covers the setup needed to get it up and running.
