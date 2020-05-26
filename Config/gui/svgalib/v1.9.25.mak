# svgalib v1.4.3		[ since v1.4.3, c.2003-07-05 ]
# last mod WmT, 2014-10-27	[ (c) and GPLv2 1999-2014* ]

#	# svgalib v1.4.3		[ since v1.4.3, c.2003-07-05 ]
#	# last mod WmT, 2011-06-11	[ (c) and GPLv2 1999-2011 ]
#	
#	ifneq (${HAVE_SVGALIB_CONFIG},y)
#	HAVE_SVGALIB_CONFIG:=y
#	
#	DESCRLIST+= "'cui-svgalib' -- svgalib"
#	
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	include ${CFG_ROOT}/ENV/native.mak
#	include ${CFG_ROOT}/ENV/target.mak
#	
#	ifneq (${HAVE_CROSS_GCC_VER},)
#	include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
#	include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
#	else
#	include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
#	endif
#	
#	#include ${CFG_ROOT}/buildtools/make/v3.81.mak
#	#include ${CFG_ROOT}/distrotools-legacy/coreutils/v5.97.mak
#	
#	SVGALIB_VER:=1.4.3
#	SVGALIB_SRC=${SRCDIR}/s/svgalib-1.4.3.tar.gz
#	SVGALIB_PATCHES=
#	
#	
#	# ,-----
#	# |	Extract
#	# +-----
#	
#	CTI_SVGALIB_TEMP=cti-svgalib-${SVGALIB_VER}
#	CTI_SVGALIB_INSTTEMP=${CTI_TC_ROOT}/usr/${CTI_SPEC}
#	
#	CTI_SVGALIB_EXTRACTED=${EXTTEMP}/${CTI_SVGALIB_TEMP}/Makefile
#	
#	CUI_SVGALIB_TEMP=cui-svgalib-${SVGALIB_VER}
#	CUI_SVGALIB_INSTTEMP=${EXTTEMP}/insttemp
#	
#	CUI_SVGALIB_EXTRACTED=${EXTTEMP}/${CUI_SVGALIB_TEMP}/Makefile
#	
#	NTI_SVGALIB_TEMP=nti-svgalib-${SVGALIB_VER}
#	NTI_SVGALIB_INSTTEMP=${NTI_TC_ROOT}
#	
#	NTI_SVGALIB_EXTRACTED=${EXTTEMP}/${NTI_SVGALIB_TEMP}/Makefile
#	
#	
#	##
#	
#	.PHONY: cti-svgalib-extracted
#	
#	cti-svgalib-extracted: ${CTI_SVGALIB_EXTRACTED}
#	
#	${CTI_SVGALIB_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${CTI_SVGALIB_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_SVGALIB_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${SVGALIB_SRC}
#	ifneq (${SVGALIB_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PF in ${SVGALIB_PATCHES} ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d svgalib-${SVGALIB_VER} -Np1 < $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/svgalib-${SVGALIB_VER} ${EXTTEMP}/${CTI_SVGALIB_TEMP}
#	
#	##
#	
#	.PHONY: cui-svgalib-extracted
#	
#	cui-svgalib-extracted: ${CUI_SVGALIB_EXTRACTED}
#	
#	${CUI_SVGALIB_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${CUI_SVGALIB_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SVGALIB_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${SVGALIB_SRC}
#	ifneq (${SVGALIB_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PF in ${SVGALIB_PATCHES} ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d svgalib-${SVGALIB_VER} -Np1 < $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/svgalib-${SVGALIB_VER} ${EXTTEMP}/${CUI_SVGALIB_TEMP}
#	
#	##
#	
#	.PHONY: nti-svgalib-extracted
#	
#	nti-svgalib-extracted: ${NTI_SVGALIB_EXTRACTED}
#	
#	${NTI_SVGALIB_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${NTI_SVGALIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SVGALIB_TEMP}
#		m -C ${TOPLEV}ake extract ARCHIVES=${SVGALIB_SRC}
#	ifneq (${SVGALIB_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PF in ${SVGALIB_PATCHES} ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d svgalib-${SVGALIB_VER} -Np1 < $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/svgalib-${SVGALIB_VER} ${EXTTEMP}/${NTI_SVGALIB_TEMP}
#	
#	
#	
#	# ,-----
#	# |	Configure
#	# +-----
#	
#	CTI_SVGALIB_CONFIGURED=${EXTTEMP}/${CTI_SVGALIB_TEMP}/Makefile.cfg.OLD
#	
#	CUI_SVGALIB_CONFIGURED=${EXTTEMP}/${CUI_SVGALIB_TEMP}/Makefile.cfg.OLD
#	
#	NTI_SVGALIB_CONFIGURED=${EXTTEMP}/${NTI_SVGALIB_TEMP}/Makefile.cfg.OLD
#	
#	##
#	
#	.PHONY: cti-svgalib-configured
#	
#	cti-svgalib-configured: cti-svgalib-extracted ${CTI_SVGALIB_CONFIGURED}
#	
#	${CTI_SVGALIB_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CTI_SVGALIB_TEMP} || exit 1 ;\
#			[ -r Makefile.cfg.OLD ] \
#				|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
#			cat Makefile.cfg.OLD \
#				| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
#				| sed '/^	*CC/ s%gcc%'${CTI_GCC}'%' \
#				| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
#				| sed '/^prefix/ s%/usr/local%%' \
#				| sed '/^INSTALL_/ { s/-o root// ; s/-g bin// }' \
#				| sed '/^INSTALLMAN/ s/^/#/' \
#				> Makefile.cfg || exit 1 ;\
#			[ -r lrmi-0.6m/Makefile.OLD ] || mv lrmi-0.6m/Makefile lrmi-0.6m/Makefile.OLD ;\
#			cat lrmi-0.6m/Makefile.OLD \
#				| sed '/^CFLAGS/	s%^%include ../Makefile.cfg\n\n%' \
#				> lrmi-0.6m/Makefile \
#		)
#	
#	##
#	
#	.PHONY: cui-svgalib-configured
#	
#	cui-svgalib-configured: cui-svgalib-extracted ${CUI_SVGALIB_CONFIGURED}
#	
#	${CUI_SVGALIB_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CUI_SVGALIB_TEMP} || exit 1 ;\
#			[ -r Makefile.cfg.OLD ] \
#				|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
#			cat Makefile.cfg.OLD \
#				| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
#				| sed '/^	*CC/ s%gcc%'${CTI_GCC}'%' \
#				| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
#				| sed '/^prefix/ s%/usr/local%%' \
#				| sed '/^INSTALL_/ { s/-o root// ; s/-g bin// }' \
#				| sed '/^INSTALLMAN/ s/^/#/' \
#				> Makefile.cfg || exit 1 ;\
#			[ -r lrmi-0.6m/Makefile.OLD ] || mv lrmi-0.6m/Makefile lrmi-0.6m/Makefile.OLD ;\
#			cat lrmi-0.6m/Makefile.OLD \
#				| sed '/^CFLAGS/	s%^%include ../Makefile.cfg\n\n%' \
#				> lrmi-0.6m/Makefile \
#		)
#	
#	##
#	
#	.PHONY: nti-svgalib-configured
#	
#	nti-svgalib-configured: nti-svgalib-extracted ${NTI_SVGALIB_CONFIGURED}
#	
#	${NTI_SVGALIB_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
#			[ -r Makefile.cfg.OLD ] \
#				|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
#			cat Makefile.cfg.OLD \
#				| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
#				| sed '/^	*CC/ s%gcc%'${NUI_CC_PREFIX}'cc%' \
#				| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
#				| sed '/^prefix/ s%/usr/local%%' \
#				| sed '/^INSTALL_/ { s/-o root// ; s/-g bin// }' \
#				| sed '/^INSTALLMAN/ s/^/#/' \
#				> Makefile.cfg || exit 1 ;\
#			[ -r lrmi-0.6m/Makefile.OLD ] || mv lrmi-0.6m/Makefile lrmi-0.6m/Makefile.OLD ;\
#			cat lrmi-0.6m/Makefile.OLD \
#				| sed '/^CFLAGS/	s%^%include ../Makefile.cfg\n\n%' \
#				> lrmi-0.6m/Makefile \
#		)
#	
#	
#	
#	# ,-----
#	# |	Build
#	# +-----
#	
#	CTI_SVGALIB_BUILT=${EXTTEMP}/${CTI_SVGALIB_TEMP}/lrmi-0.6m/mode3
#	
#	CUI_SVGALIB_BUILT=${EXTTEMP}/${CUI_SVGALIB_TEMP}/lrmi-0.6m/mode3
#	
#	NTI_SVGALIB_BUILT=${EXTTEMP}/${NTI_SVGALIB_TEMP}/lrmi-0.6m/mode3
#	
#	##
#	
#	.PHONY: cti-svgalib-built
#	cti-svgalib-built: cti-svgalib-configured ${CTI_SVGALIB_BUILT}
#	
#	${CTI_SVGALIB_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CTI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=/ shared static textutils lrmi || exit 1 \
#		) || exit 1
#	
#	##
#	
#	.PHONY: cui-svgalib-built
#	cui-svgalib-built: cui-svgalib-configured ${CUI_SVGALIB_BUILT}
#	
#	${CUI_SVGALIB_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CUI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=/ shared static textutils lrmi || exit 1 \
#		) || exit 1
#	
#	##
#	
#	.PHONY: nti-svgalib-built
#	nti-svgalib-built: nti-svgalib-configured ${NTI_SVGALIB_BUILT}
#	
#	${NTI_SVGALIB_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=/ shared static textutils lrmi || exit 1 \
#		) || exit 1
#	
#	
#	
#	# ,-----
#	# |	Install
#	# +-----
#	
#	CTI_SVGALIB_INSTALLED=${CTI_SVGALIB_INSTTEMP}/usr/bin/mode3
#	
#	CUI_SVGALIB_INSTALLED=${CUI_SVGALIB_INSTTEMP}/usr/bin/mode3
#	
#	NTI_SVGALIB_INSTALLED=${NTI_SVGALIB_INSTTEMP}/usr/bin/mode3
#	
#	
#	##
#	
#	.PHONY: cti-svgalib-installed
#	
#	cti-svgalib-installed: cti-svgalib-built ${CTI_SVGALIB_INSTALLED}
#	
#	${CTI_SVGALIB_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		mkdir -p ${CTI_SVGALIB_INSTTEMP}/etc
#		( cd ${EXTTEMP}/${CTI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=${CTI_SVGALIB_INSTTEMP}/ installconfig || exit 1 ;\
#			make TOPDIR=${CTI_SVGALIB_INSTTEMP}/usr \
#				installheaders installsharedlib installstaticlib installutils installman || exit 1 ;\
#			case ${SVGALIB_VER} in \
#			1.4.3)	\
#				mv ${CTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config ${CTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default || exit 1 ;\
#				cat ${CTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default \
#					| sed '/^mouse/ s/[A-Za-z]*$$/PS2/' \
#					| sed '/^mdev/	s/ttyS0.*/psaux/' \
#					| sed '/640x480/ s/^# modeline/modeline/' \
#					| sed '/800x600/ s/^# modeline/modeline/' \
#					| sed '/1024x768/ s/^# modeline/modeline/' \
#					> ${CTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config || exit 1 \
#			;; \
#			*) \
#				echo "$0: INSTALL: Unexpected SVGALIB_VER ${SVGALIB_VER}" 1>&2 ;\
#				exit 1 \
#			;; \
#			esac \
#		) || exit 1
#	
#	
#	##
#	
#	.PHONY: cui-svgalib-installed
#	
#	cui-svgalib-installed: cui-svgalib-built ${CUI_SVGALIB_INSTALLED}
#	
#	${CUI_SVGALIB_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		mkdir -p ${CUI_SVGALIB_INSTTEMP}/etc
#		( cd ${EXTTEMP}/${CUI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=${CUI_SVGALIB_INSTTEMP}/ installconfig || exit 1 ;\
#			make TOPDIR=${CUI_SVGALIB_INSTTEMP}/usr \
#				installheaders installsharedlib installstaticlib installutils installman || exit 1 ;\
#			case ${SVGALIB_VER} in \
#			1.4.3)	\
#				mv ${CUI_SVGALIB_INSTTEMP}/etc/vga/libvga.config ${CUI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default || exit 1 ;\
#				cat ${CUI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default \
#					| sed '/^mouse/ s/[A-Za-z]*$$/PS2/' \
#					| sed '/^mdev/	s/ttyS0.*/psaux/' \
#					| sed '/640x480/ s/^# modeline/modeline/' \
#					| sed '/800x600/ s/^# modeline/modeline/' \
#					| sed '/1024x768/ s/^# modeline/modeline/' \
#					> ${CUI_SVGALIB_INSTTEMP}/etc/vga/libvga.config || exit 1 \
#			;; \
#			*) \
#				echo "$0: INSTALL: Unexpected SVGALIB_VER ${SVGALIB_VER}" 1>&2 ;\
#				exit 1 \
#			;; \
#			esac \
#		) || exit 1
#	
#	##
#	
#	.PHONY: nti-svgalib-installed
#	
#	nti-svgalib-installed: nti-svgalib-built ${NTI_SVGALIB_INSTALLED}
#	
#	${NTI_SVGALIB_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		mkdir -p ${NTI_SVGALIB_INSTTEMP}/etc
#		( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
#			make TOPDIR=${NTI_SVGALIB_INSTTEMP}/ installconfig || exit 1 ;\
#			make TOPDIR=${NTI_SVGALIB_INSTTEMP}/usr \
#				installheaders installsharedlib installstaticlib installutils installman || exit 1 ;\
#			case ${SVGALIB_VER} in \
#			1.4.3)	\
#				mv ${NTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config ${NTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default || exit 1 ;\
#				cat ${NTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config.default \
#					| sed '/^mouse/ s/[A-Za-z]*$$/PS2/' \
#					| sed '/^mdev/	s/ttyS0.*/psaux/' \
#					| sed '/640x480/ s/^# modeline/modeline/' \
#					| sed '/800x600/ s/^# modeline/modeline/' \
#					| sed '/1024x768/ s/^# modeline/modeline/' \
#					> ${NTI_SVGALIB_INSTTEMP}/etc/vga/libvga.config || exit 1 \
#			;; \
#			*) \
#				echo "$0: INSTALL: Unexpected SVGALIB_VER ${SVGALIB_VER}" 1>&2 ;\
#				exit 1 \
#			;; \
#			esac \
#		) || exit 1
#	
#	##
#	
#	.PHONY: cti-svgalib
#	cti-svgalib: cti-cross-gcc cti-svgalib-installed
#	
#	.PHONY: cui-svgalib
#	cui-svgalib: cti-cross-gcc cui-uClibc-rt cui-svgalib-installed
#	
#	.PHONY: nti-svgalib
#	nti-svgalib: nti-make nti-coreutils nti-svgalib-installed
#	
#	
#	CTARGETS+= cui-svgalib
#	
#	endif	# HAVE_SVGALIB_CONFIG

ifneq (${HAVE_SVGALIB_CONFIG},y)
HAVE_SVGALIB_CONFIG:=y

#DESCRLIST+= "'nti-svgalib' -- svgalib"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
include ${CFG_ROOT}/ENV/buildtype.mak

#	#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#	##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#	include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#	#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${SVGALIB_VERSION},)
#SVGALIB_VERSION=1.4.3
SVGALIB_VERSION=1.9.25
endif
SVGALIB_SRC=${SOURCES}/s/svgalib-${SVGALIB_VERSION}.tar.gz

URLS+= http://www.svgalib.org/svgalib-${SVGALIB_VERSION}.tar.gz

#	SVGALIB_PATCHES+=${SRCDIR}/s/svgalib-1.4.3-debian_fixes-1.patch
#	URLS+=http://www.linuxfromscratch.org/patches/downloads/svgalib/svgalib-1.4.3-debian_fixes-1.patch

NTI_SVGALIB_TEMP=nti-svgalib-${SVGALIB_VERSION}

NTI_SVGALIB_EXTRACTED=${EXTTEMP}/${NTI_SVGALIB_TEMP}/LICENSE
NTI_SVGALIB_CONFIGURED=${EXTTEMP}/${NTI_SVGALIB_TEMP}/Makefile.cfg.OLD
NTI_SVGALIB_BUILT=${EXTTEMP}/${NTI_SVGALIB_TEMP}/svgalib-config
NTI_SVGALIB_INSTALLED=${NTI_TC_ROOT}/usr/bin/svgalib-config


## ,-----
## |	Extract
## +-----

${NTI_SVGALIB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/svgalib-${SVGALIB_VERSION} ] || rm -rf ${EXTTEMP}/svgalib-${SVGALIB_VERSION}
	zcat ${SVGALIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SVGALIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SVGALIB_TEMP}
	mv ${EXTTEMP}/svgalib-${SVGALIB_VERSION} ${EXTTEMP}/${NTI_SVGALIB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SVGALIB_CONFIGURED}: ${NTI_SVGALIB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
		[ -r Makefile.cfg.OLD ] \
			|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
		cat Makefile.cfg.OLD \
			| sed '/^WARN/		{ s/-Wall// ; s/-Wstrict-prototypes// }' \
			| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
			| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
			| sed '/^prefix/ s%/usr/local%%' \
			| sed '/^INSTALL_/ { s/-o root// ; s/-g bin// }' \
			| sed '/^INSTALLMAN/ s/^/#/' \
			> Makefile.cfg || exit 1 ;\
		[ -r lrmi-0.6m/Makefile.OLD ] || mv lrmi-0.6m/Makefile lrmi-0.6m/Makefile.OLD ;\
		cat lrmi-0.6m/Makefile.OLD \
			| sed '/^CFLAGS/	s%^%include ../Makefile.cfg\n\n%' \
			> lrmi-0.6m/Makefile ;\
		[ -r utils/gtf/gtfcalc.c.OLD ] || mv utils/gtf/gtfcalc.c utils/gtf/gtfcalc.c.OLD || exit 1 ;\
		cat utils/gtf/gtfcalc.c.OLD \
			| sed '/double round/,/}/ { s/^/\/\/ / }' \
			> utils/gtf/gtfcalc.c || exit 1 \
	)
#			| sed '/^	*CC/ s%gcc%'${NUI_CC_PREFIX}'cc%' \


## ,-----
## |	Build
## +-----

${NTI_SVGALIB_BUILT}: ${NTI_SVGALIB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
		make TOPDIR=/ shared static textutils lrmi || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_SVGALIB_INSTALLED}: ${NTI_SVGALIB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SVGALIB_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-svgalib
nti-svgalib: ${NTI_SVGALIB_INSTALLED}

ALL_NTI_TARGETS+= nti-svgalib

endif	# HAVE_SVGALIB_CONFIG
