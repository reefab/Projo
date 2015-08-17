# Build instructions

## OpenWRT Package


### Setup

Install openwrt build root and luci feed: http://wiki.openwrt.org/doc/howto/buildroot.exigence

link `luci-projo` from repo to `feeds/luci/applications/luci-projo` in the openWRT source.

Edit `feeds/luci/contrib/package/luci-addons/Makefile`

Add

    $(eval $(call application,projo,Remote for serial connected AV devices,ser2net))

Among the others similar lines.

### Build:

    make package/luci-addons/compile
    make package/luci-addons/install
    make package/index

Package will be in `bin/ar71xx/packages/luci/`

## Web app

You'll need node installed on your local machine beforehand.

    npm -g install # Will install all the dependencies needed for development
    bower install # Will install the dependencies for runtime

To build:

    grunt build

Put the output to the `htdocs` directory of `luci-projo` if you want it packaged in the .ipk as seen above.

To launch a server with auto-reloading and livereload

    grunt server


