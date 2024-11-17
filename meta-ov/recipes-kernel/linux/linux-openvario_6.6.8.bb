DESCRIPTION = "Linux kernel for OpenVario"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit kernel kernel-yocto siteinfo

S = "${WORKDIR}/git"

KBRANCH = "linux-6.6.y"

SRCREV = "8dfb9086136c1092a4e613c0878a5b1e88d5f328"

SRC_URI = " \
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=${KBRANCH} \
	\
	file://defconfig \
	\
	file://systemd.cfg \
	file://no_debug.cfg \
        file://openvario.cfg \
	file://cpufreq.cfg \
        file://usbhost.cfg \
        file://networking.cfg \
        file://netdev.cfg \
        file://usbnet.cfg \
        file://usbserial.cfg \
        file://usbstorage.cfg \
        file://filesystems.cfg \
	file://graphics.cfg \
	file://sound.cfg \
	file://wifi.cfg \
	file://bluetooth.cfg \
	file://w1.cfg \
	file://debloat.cfg \
"

SRC_URI:append:sunxi = " \
	file://0004-Set-minimum-CPU-voltage-to-1.2V.patch\
	\
	file://ov-cb2-common.dts \
	file://ov-cb2-43-rgb.dts \
	file://ov-cb2-57-lvds-ds2.dts \
	file://ov-cb2-57-lvds.dts \
	file://ov-cb2-7-am070-ds2.dts \
	file://ov-cb2-7-ch070-ds2.dts \
	file://ov-cb2-7-ch070.dts \
	file://ov-cb2-7-pq070.dts \
	\
	file://sunxi.cfg \
	file://drm.cfg \
"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"
KCONFIG_MODE ?= "alldefconfig"
KMACHINE ?= "${MACHINE}"

# This kludge works around a failure to create
# "linux-*/meta/cfg/invalid.txt" because the "meta" directory does not
# exist.
KMETA = ".kernel-meta"

do_configure:prepend:sunxi() {
	cp ${WORKDIR}/ov-cb2-*.dts ${S}/arch/arm/boot/dts/
	cp ${WORKDIR}/ov-*.dts ${S}/arch/arm/boot/dts/
}

FILES_${KERNEL_PACKAGE_NAME}-base:append = " ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo"
