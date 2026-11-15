################################################################################
#
# uboot-anbernic-rg-rotate
#
################################################################################

# TODO: pin to a commit (branch main) - please update when updating commit ref
UBOOT_ANBERNIC_RG_ROTATE_VERSION = main
UBOOT_ANBERNIC_RG_ROTATE_SITE = $(call github,beebono,u-boot-ums512,$(UBOOT_ANBERNIC_RG_ROTATE_VERSION))
UBOOT_ANBERNIC_RG_ROTATE_LICENSE = GPL-2.0+
UBOOT_ANBERNIC_RG_ROTATE_LICENSE_FILES = Licenses/README
UBOOT_ANBERNIC_RG_ROTATE_INSTALL_IMAGES = YES

UBOOT_ANBERNIC_RG_ROTATE_DEPENDENCIES = host-pkgconf host-openssl host-bison host-flex \
    host-python-setuptools host-dtc host-swig host-gnutls host-python-pyelftools

UBOOT_ANBERNIC_RG_ROTATE_DEFCONFIG = ums512_rg_rotate_defconfig
UBOOT_ANBERNIC_RG_ROTATE_DEVICE_TREE = ums512_rg_rotate

UBOOT_ANBERNIC_RG_ROTATE_MAKE_OPTS = \
	ARCH=arm \
	DEVICE_TREE=$(UBOOT_ANBERNIC_RG_ROTATE_DEVICE_TREE) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	HOSTCFLAGS="$(HOST_CFLAGS)" \
	HOSTLDFLAGS="$(HOST_LDFLAGS)"

define UBOOT_ANBERNIC_RG_ROTATE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(UBOOT_ANBERNIC_RG_ROTATE_MAKE_OPTS) \
		$(UBOOT_ANBERNIC_RG_ROTATE_DEFCONFIG)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(UBOOT_ANBERNIC_RG_ROTATE_MAKE_OPTS) \
		u-boot-dtb.bin
endef

# The raw payload is wrapped into the Unisoc DHTB header by create-boot-script.sh
define UBOOT_ANBERNIC_RG_ROTATE_INSTALL_IMAGES_CMDS
	mkdir -p $(BINARIES_DIR)/rg-rotate
	cp -v $(@D)/u-boot-dtb.bin $(BINARIES_DIR)/rg-rotate/u-boot-dtb.bin
	cp -v $(UBOOT_ANBERNIC_RG_ROTATE_PKGDIR)/pack_unisoc_uboot.py \
		$(UBOOT_ANBERNIC_RG_ROTATE_PKGDIR)/rehash.py $(BINARIES_DIR)/rg-rotate/
endef

$(eval $(generic-package))
