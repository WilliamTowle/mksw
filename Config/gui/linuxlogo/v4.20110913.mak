## linuxlogo v4.20110913		[ since v4.20110913, c. 2011-09-15 ]
## last mod WmT, 2011-09-15	[ (c) and GPLv2 1999-2011 ]
#
#ifneq (${HAVE_LINUXLOGO_CONFIG},y)
#HAVE_LINUXLOGO_CONFIG:=y
#
#DESCRLIST+= "'nti-linuxlogo' -- linuxlogo"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
#endif
#
#ifneq (${HAVE_NATIVE_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_NATIVE_GCC_VER}.mak
#endif
#ifneq (${HAVE_CROSS_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
#endif
#
#
##include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
###include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
##include ${CFG_ROOT}/gui/libICE/v1.0.5.mak
##include ${CFG_ROOT}/gui/libSM/v1.1.0.mak
##include ${CFG_ROOT}/gui/libX11/v1.2.2.mak
##include ${CFG_ROOT}/gui/libXaw/v1.0.6.mak
##include ${CFG_ROOT}/gui/libXmu/v1.0.4.mak
##include ${CFG_ROOT}/gui/libXrender/v0.9.4.mak
#
#
#
### ,-----
### |	Extract
### +-----
#
#NTI_LINUXLOGO_TEMP=nti-linuxlogo-${LINUXLOGO_VER}
#
#.PHONY: nti-linuxlogo-extracted
#nti-linuxlogo-extracted: ${NTI_LINUXLOGO_EXTRACTED}
#
#${NTI_LINUXLOGO_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${LINUXLOGO_SRC}
#	mv ${EXTTEMP}/linuxlogo-${LINUXLOGO_VER} ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#.PHONY: nti-linuxlogo-configured
#nti-linuxlogo-configured: nti-linuxlogo-extracted ${NTI_LINUXLOGO_CONFIGURED}
#
#${NTI_LINUXLOGO_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
#	)
#
#
### ,-----
### |	Build
### +-----
#
#.PHONY: nti-linuxlogo-built
#nti-linuxlogo-built: nti-linuxlogo-configured ${NTI_LINUXLOGO_BUILT}
#
#${NTI_LINUXLOGO_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
#		make \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#.PHONY: nti-linuxlogo-installed
#nti-linuxlogo-installed: nti-linuxlogo-built ${NTI_LINUXLOGO_INSTALLED}
#
#${NTI_LINUXLOGO_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: nti-linuxlogo
#nti-linuxlogo: nti-native-gcc nti-linuxlogo-installed
#
#NTARGETS+= nti-linuxlogo
#
#endif	# HAVE_LINUXLOGO_CONFIG


# linuxlogo v2.12		[ since v2.8, c. 2006-02-06 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LINUXLOGO_CONFIG},y)
HAVE_LINUXLOGO_CONFIG:=y

#DESCRLIST+= "'nti-linuxlogo' -- linuxlogo"
#DESCRLIST+= "'cti-linuxlogo' -- linuxlogo"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#
#include ${CFG_ROOT}/gui/libXdmcp/v1.0.3.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.5.mak
##include ${CFG_ROOT}/gui/libXau/v1.0.6.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
##include ${CFG_ROOT}/gui/libXt/v1.0.9.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
##include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.0.mak
##include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.1.mak
#include ${CFG_ROOT}/gui/x11proto-input/v2.0.mak
##include ${CFG_ROOT}/gui/x11proto-input/v2.0.1.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.4.mak
##include ${CFG_ROOT}/gui/x11proto-kb/v1.0.5.mak
#include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.0.mak
##include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.1.mak

ifeq (${LINUXLOGO_VERSION},)
LINUXLOGO_VERSION=4.20110913
endif

LINUXLOGO_SRC=${SOURCES}/l/linuxlogo-${LINUXLOGO_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/linuxlogo/linuxlogo/linuxlogo-4.20110913/linuxlogo-4.20110913.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flinuxlogo%2Ffiles%2Flinuxlogo%2Flinuxlogo-4.20110913%2F&ts=1316075922&use_mirror=netcologne'

NTI_LINUXLOGO_TEMP=nti-linuxlogo-${LINUXLOGO_VERSION}

NTI_LINUXLOGO_EXTRACTED=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/configure
NTI_LINUXLOGO_CONFIGURED=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/config.status
NTI_LINUXLOGO_BUILT=${EXTTEMP}/${NTI_LINUXLOGO_TEMP}/linuxlogo
NTI_LINUXLOGO_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/linuxlogo


## ,-----
## |	Extract
## +-----

${NTI_LINUXLOGO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION} ] || rm -rf ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION}
	zcat ${LINUXLOGO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}
	mv ${EXTTEMP}/linuxlogo-${LINUXLOGO_VERSION} ${EXTTEMP}/${NTI_LINUXLOGO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LINUXLOGO_CONFIGURED}: ${NTI_LINUXLOGO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			|| exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_LINUXLOGO_BUILT}: ${NTI_LINUXLOGO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LINUXLOGO_INSTALLED}: ${NTI_LINUXLOGO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LINUXLOGO_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-linuxlogo
nti-linuxlogo: ${NTI_LINUXLOGO_INSTALLED}

ALL_NTI_TARGETS+= nti-linuxlogo

endif	# HAVE_LINUXLOGO_CONFIG
