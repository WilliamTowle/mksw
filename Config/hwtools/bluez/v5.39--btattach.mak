# bluez v5.39			[ since v5.39, 2016-05-16 ]
# last mod WmT, 2016-06-06	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_BLUEZ_CONFIG},y)
HAVE_BLUEZ_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak


#DESCRLIST+= "'cui-bluez' -- bluez"
#DESCRLIST+= "'nti-bluez' -- bluez"

ifeq (${BLUEZ_VERSION},)
BLUEZ_VERSION=5.39
endif

BLUEZ_SRC=${SOURCES}/b/bluez-${BLUEZ_VERSION}.tar.xz
BLUEZ_PATCHES=
URLS+= http://www.kernel.org/pub/linux/bluetooth/bluez-5.39.tar.xz

BLUEZ_PATCHES+= ${CFG_ROOT}/hwtools/bluez/bluez-btattach-patch.txt
URLS+= http://www.spinics.net/lists/linux-bluetooth/msg66424.html

#include ${CFG_ROOT}/misc/glib/v2.46.2--arm64.mak
#include ${CFG_ROOT}/misc/glib/v2.49.1--arm64.mak

#CUI_BLUEZ_TEMP=cui-bluez-${BLUEZ_VERSION}
#CUI_BLUEZ_INSTTEMP=${EXTTEMP}/insttemp-cui
#
#CUI_BLUEZ_EXTRACTED=${EXTTEMP}/${CUI_BLUEZ_TEMP}/COPYING
#CUI_BLUEZ_CONFIGURED=${EXTTEMP}/${CUI_BLUEZ_TEMP}/.configure.done
#CUI_BLUEZ_BUILT=${EXTTEMP}/${CUI_BLUEZ_TEMP}/src/bluez
#CUI_BLUEZ_INSTALLED=${CUI_BLUEZ_INSTTEMP}/usr/sbin/bluez


NTI_BLUEZ_TEMP=nti-bluez-${BLUEZ_VERSION}

NTI_BLUEZ_EXTRACTED=${EXTTEMP}/${NTI_BLUEZ_TEMP}/configure
NTI_BLUEZ_CONFIGURED=${EXTTEMP}/${NTI_BLUEZ_TEMP}/config.log
NTI_BLUEZ_BUILT=${EXTTEMP}/${NTI_BLUEZ_TEMP}/src/bluez
NTI_BLUEZ_INSTALLED=${NTI_TC_ROOT}/usr/sbin/bluez


## ,-----
## |	Extract
## +-----

#${CUI_BLUEZ_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/bluez-${BLUEZ_VERSION} ] || rm -rf ${EXTTEMP}/bluez-${BLUEZ_VERSION}
#	xzcat ${BLUEZ_SRC} | tar xvf - -C ${EXTTEMP}
#	[ ! -d ${EXTTEMP}/${CUI_BLUEZ_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_BLUEZ_TEMP}
#	mv ${EXTTEMP}/bluez-${BLUEZ_VERSION} ${EXTTEMP}/${CUI_BLUEZ_TEMP}
#
###

${NTI_BLUEZ_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bluez-${BLUEZ_VERSION} ] || rm -rf ${EXTTEMP}/bluez-${BLUEZ_VERSION}
	xzcat ${BLUEZ_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${BLUEZ_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${BLUEZ_PATCHES} ; do \
			echo "*** PATCHING -- PF $${PF} ***" ;\
			patch --batch -d bluez-${BLUEZ_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_BLUEZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BLUEZ_TEMP}
	mv ${EXTTEMP}/bluez-${BLUEZ_VERSION} ${EXTTEMP}/${NTI_BLUEZ_TEMP}


## ,-----
## |	Configure
## +-----

#${CUI_BLUEZ_CONFIGURED}: ${CUI_BLUEZ_EXTRACTED}
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_BLUEZ_TEMP} || exit 1 ;\
#		case ${BLUEZ_VERSION} in \
#		B.02.18) \
#			for MF in src/Makefile src/core/Makefile ; do \
#				[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD || exit 1 ;\
#				cat $${MF}.OLD \
#					| sed '/^PREFIX[?=]/	s%/usr%'${CUI_BLUEZ_INSTTEMP}'/usr%' \
#					| sed '/^CXX[?=]/		s%g*c++%'${TARGSPEC}'-g++%' \
#					> $${MF} ;\
#			done \
#		;; \
#		esac ;\
#		touch $@ \
#	)
#
###

# [aarch64-native] using native pkg-config (dependencies too)
${NTI_BLUEZ_CONFIGURED}: ${NTI_BLUEZ_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-tools \
			--disable-udev \
			--disable-systemd \
			--enable-library \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^am__tools_hciattach_SOURCES_DIST/,+4	s%tools/hciattach_bcm43xx.c%tools/hciattach_marvell.c &%' \
			| sed '/^am_tools_hciattach_OBJECTS/,+7		s%tools/hciattach_bcm43xx%tools/hciattach_marvell.$$(OBJEXT) \\\n	&%' \
			| sed '/^tools_hciattach_SOURCES/,+7		s%tools/hciattach_bcm43xx.c%tools/hciattach_marvell.c \\\n	&%' \
			| sed '/^tools\/hciattach_bcm43xx/		s%^%tools/hciattach_marvell.$$(OBJEXT): tools/$$(am__dirstamp) \\\n	tools/$$(DEPDIR)/$$(am__dirstamp)\n%' \
			> Makefile \
	)
#			| sed '/hciattach_bcm43xx.Po/			s%^%include tools/$$(DEPDIR)/hciattach_marvell.Po\n%' \


## ,-----
## |	Build
## +-----

#${CUI_BLUEZ_BUILT}: ${CUI_BLUEZ_CONFIGURED}
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_BLUEZ_TEMP} || exit 1 ;\
#		make \
#	)
#
###

${NTI_BLUEZ_BUILT}: ${NTI_BLUEZ_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#${CUI_BLUEZ_INSTALLED}: ${CUI_BLUEZ_BUILT}
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CUI_BLUEZ_TEMP} || exit 1 ;\
#		make install \
#	)
#
#
#.PHONY: cui-bluez
#cui-bluez: ${CUI_BLUEZ_INSTALLED}
#
#ALL_CUI_TARGETS+= cui-bluez
#
###

${NTI_BLUEZ_INSTALLED}: ${NTI_BLUEZ_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BLUEZ_TEMP} || exit 1 ;\
		make install \
	)


.PHONY: nti-bluez
nti-bluez: \
	${NTI_BLUEZ_INSTALLED}
#nti-bluez: nti-pkg-config \
#	${NTI_BLUEZ_INSTALLED}
##nti-bluez: nti-glib \
##	${NTI_BLUEZ_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-bluez

endif	# HAVE_BLUEZ_CONFIG
