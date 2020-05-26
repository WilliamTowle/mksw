# unfs3 v0.9.22			[ since v0.9.19, c.2007-12-09 ]
# last mod WmT, 2013-02-21	[ (c) and GPLv2 1999-2013* ]

#ifneq (${HAVE_UNFS3_CONFIG},y)
#HAVE_UNFS3_CONFIG:=y
#
##DESCRLIST+= "'nti-unfs3' -- unfs3"
#
#UNFS3_VER=0.9.22
#UNFS3_SRC=${SRCDIR}/u/unfs3-0.9.22.tar.gz
#
#URLS+=http://downloads.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz?use_mirror=garr
#
#
## ,-----
## |	Extract
## +-----
#
#NTI_UNFS3_TEMP=nti-unfs3-${UNFS3_VER}
#
#NTI_UNFS3_EXTRACTED=${EXTTEMP}/${NTI_UNFS3_TEMP}/configure
#
#.PHONY: nti-unfs3-extracted
#nti-unfs3-extracted: ${NTI_UNFS3_EXTRACTED}
#
#${NTI_UNFS3_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_UNFS3_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UNFS3_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${UNFS3_SRC}
#	mv ${EXTTEMP}/unfs3-${UNFS3_VER} ${EXTTEMP}/${NTI_UNFS3_TEMP}
#
#
## ,-----
## |	Configure
## +-----
#
#NTI_UNFS3_CONFIGURED=${EXTTEMP}/${NTI_UNFS3_TEMP}/config.status
#
#.PHONY: nti-unfs3-configured
#nti-unfs3-configured: nti-unfs3-extracted ${NTI_UNFS3_CONFIGURED}
#
#${NTI_UNFS3_CONFIGURED}: ${NTI_UNFS3_EXTRACTED}
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
#		CC=${NTI_GCC} \
#		  ./configure \
#			--prefix=${NTI_TC_ROOT}/usr \
#			--exec-prefix=${NTI_TC_ROOT} \
#			|| exit 1 \
#	)
#
#
## ,-----
## |	Build
## +-----
#
#NTI_UNFS3_BUILT=${EXTTEMP}/${NTI_UNFS3_TEMP}/unfsd
#
#.PHONY: nti-unfs3-built
#nti-unfs3-built: nti-unfs3-configured ${NTI_UNFS3_BUILT}
#
#${NTI_UNFS3_BUILT}: ${NTI_UNFS3_CONFIGURED}
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
#		make \
#	)
#
#
## ,-----
## |	Install
## +-----
#
#NTI_UNFS3_INSTALLED=${NTI_TC_ROOT}/sbin/unfsd
#
#.PHONY: nti-unfs3-installed
#nti-unfs3-installed: nti-unfs3-built ${NTI_UNFS3_INSTALLED}
#
#${NTI_UNFS3_INSTALLED}: ${NTI_TC_ROOT}
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: nti-unfs3
#nti-unfs3: nti-native-gcc nti-unfs3-installed
#
#NTARGETS+= nti-unfs3
#
#endif	# HAVE_UNFS3_CONFIG

# unfs3 v2.4.4			[ EARLIEST v2.4.4, 2013-02-21 ]
# last mod WmT, 2013-02-21	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_UNFS3_CONFIG},y)
HAVE_UNFS3_CONFIG:=y

#DESCRLIST+= "'nti-unfs3' -- unfs3"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${UNFS3_VERSION},)
UNFS3_VERSION=0.9.22
endif

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

UNFS3_SRC=${SOURCES}/u/unfs3-${UNFS3_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz?use_mirror=garr

NTI_UNFS3_TEMP=nti-unfs3-${UNFS3_VERSION}

NTI_UNFS3_EXTRACTED=${EXTTEMP}/${NTI_UNFS3_TEMP}/configure
NTI_UNFS3_CONFIGURED=${EXTTEMP}/${NTI_UNFS3_TEMP}/config.status
NTI_UNFS3_BUILT=${EXTTEMP}/${NTI_UNFS3_TEMP}/unfsd
NTI_UNFS3_INSTALLED=${NTI_TC_ROOT}/sbin/unfsd


## ,-----
## |	Extract
## +-----

${NTI_UNFS3_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/unfs3-${UNFS3_VERSION} ] || rm -rf ${EXTTEMP}/unfs3-${UNFS3_VERSION}
	zcat ${UNFS3_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UNFS3_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UNFS3_TEMP}
	mv ${EXTTEMP}/unfs3-${UNFS3_VERSION} ${EXTTEMP}/${NTI_UNFS3_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UNFS3_CONFIGURED}: ${NTI_UNFS3_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--exec-prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_UNFS3_BUILT}: ${NTI_UNFS3_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_UNFS3_INSTALLED}: ${NTI_UNFS3_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UNFS3_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-unfs3
nti-unfs3: ${NTI_UNFS3_INSTALLED}
#nti-unfs3: nti-libtool ${NTI_UNFS3_INSTALLED}

ALL_NTI_TARGETS+= nti-unfs3

endif	# HAVE_UNFS3_CONFIG
