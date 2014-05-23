include $(TOPDIR)/rules.mk

PKG_NAME:=luci-projo
PKG_VERSION:=0.9
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/luci-projo
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	MAINTAINER:=Fabien Piuzzi <reefab@demenzia.net>
	TITLE:=Remote for serial connected AV devices
	DEPENDS:=+luci-lib-web +luci-lib-lucid-http
endef

define Package/luci-projo/description
	Mobile web app and http and REST to serial interface.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) luasrc/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/luci-projo/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/www
	$(CP) htdocs/* $(1)/www/
endef

define Package/luci-projo/postinst
#!/bin/sh
	[ -n "$${IPKG_INSTROOT}" ] && exit
	rm -f /tmp/luci-indexcache
	rm -f /tmp/luci-modulecache/*
	/etc/init.d/lucid restart
endef

define Package/luci-projo/postrm
#!/bin/sh
	[ -n "$${IPKG_INSTROOT}" ] && exit
	/etc/init.d/lucid stop
	rm -f /tmp/luci-indexcache
	rm -f /tmp/luci-modulecache/*
	/etc/init.d/lucid start
endef

$(eval $(call BuildPackage,luci-projo))
