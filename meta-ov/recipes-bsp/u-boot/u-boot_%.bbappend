DESCRIPTION="Upstream's U-boot configured for sunxi devices (openvario-cubiebord2)"

# ====================================================================================================
# This part is a adapted copy from layer meta-sunx/recipes-bsb/u-boot/u-boot_%.bbappend
# removed suffix '-sunxi' to use it in this script
# disabling the fields with suffix '-sun50i'

# use f.e. boot.cmd from layer meta-sunxi!
FILESEXTRAPATHS:prepend := "${THISDIR}/../../../meta-sunxi/recipes-bsp/u-boot/files:"

DEPENDS:append = " bc-native dtc-native swig-native python3-native flex-native bison-native "
# sun50i: DEPENDS:append-sun50i = " atf-sunxi "

COMPATIBLE_MACHINE = "(sun4i|sun5i|sun7i|sun8i|sun50i)"

# DEFAULT_PREFERENCE-sun4i="1"
# DEFAULT_PREFERENCE-sun5i="1"
DEFAULT_PREFERENCE-sun7i="1"
# DEFAULT_PREFERENCE-sun8i="1"
# DEFAULT_PREFERENCE-sun50i="1"

# the nanopi-neo_air isn't used in openvario :), we need only the boot.cmd:
SRC_URI:append = " file://boot.cmd "
#            file://0001-nanopi_neo_air_defconfig-Enable-eMMC-support.patch

UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

EXTRA_OEMAKE:append = ' HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}" '
# EXTRA_OEMAKE:append-sun50i = " BL31=${DEPLOY_DIR_IMAGE}/bl31.bin "

# sun50i: do_compile-sun50i[depends] += "atf-sunxi:do_deploy"

do_compile:append() {
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}
# ====================================================================================================
# Add the files folder to the saerch path:
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:cubieboard2 = " \
	file://openvario_defconfig \
	file://per_machine.cfg \
	file://openvario.dts \
	file://config.uEnv \
	file://font.env \
	file://ov_recover_0.bmp \
	file://ov_recover_1.bmp \
	file://ov_recover_2.bmp \
	file://ov_recover_3.bmp \
	\
	file://ov_booting_0.bmp \
	file://ov_booting_1.bmp \
	file://ov_booting_2.bmp \
	file://ov_booting_3.bmp \
	\
	file://0001-Added-openvario.dts-to-Makefile.patch \
	file://0001-Added-RGB-swap-for-RGB-LCD.patch \
	file://0001-Environment-Openvario-mainline.patch \
	\
	file://ini2c.py \
	file://bootenv.ini \
"

do_bootenv() {
}

do_bootenv:append:cubieboard2() {
	echo '#define BOOTENV \' >>${S}/include/config_distro_bootcmd.h
	${PYTHON} ${WORKDIR}/ini2c.py <${WORKDIR}/bootenv.ini >>${S}/include/config_distro_bootcmd.h
}

addtask do_bootenv after do_unpack before do_configure
do_bootenv[depends] += "python3-native:do_populate_sysroot"

do_configure:prepend:cubieboard2() {
	cp ${WORKDIR}/openvario_defconfig ${S}/configs/openvario_defconfig
	cp ${WORKDIR}/openvario.dts ${S}/arch/arm/dts/openvario.dts
}

do_install:append:cubieboard2() {
	install -m 644 -D ${WORKDIR}/ov_*.bmp ${D}/boot
	install -m 644 -D ${WORKDIR}/config.uEnv ${D}/boot
	cat ${WORKDIR}/font.env >>${D}/boot/config.uEnv
}

do_deploy:append:cubieboard2() {
	install -d ${DEPLOYDIR}/pics
	install -m 644 -D ${WORKDIR}/ov_*.bmp ${DEPLOYDIR}/pics
	install -m 644 -D ${WORKDIR}/config.uEnv ${DEPLOYDIR}
	cat ${WORKDIR}/font.env >>${DEPLOYDIR}/config.uEnv
}
