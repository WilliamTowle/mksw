## sdparm v1.06			[ since v1.06, c.2010-11-16 ]
## last mod WmT, 2010-11-16	[ (c) and GPLv2 1999-2010 ]
#
#ifneq (${HAVE_SDPARM_CONFIG},y)
#HAVE_SDPARM_CONFIG:=y
#
#DESCRLIST+= "'nti-sdparm' -- sdparm"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/ENV/native.mak
##else
##include ${CFG_ROOT}/ENV/target.mak
#endif
#
#
#SDPARM_VER=1.06
#SDPARM_SRC=${SRCDIR}/s/sdparm-1.06.tgz
#
#URLS+= http://sg.danny.cz/sg/p/sdparm-1.06.tgz
#
#
### ,-----
### |	Extract
### +-----
#
#NTI_SDPARM_TEMP=nti-sdparm-${SDPARM_VER}
#
#NTI_SDPARM_EXTRACTED=${EXTTEMP}/${NTI_SDPARM_TEMP}/configure
#
#.PHONY: nti-sdparm-extracted
#
#nti-sdparm-extracted: ${NTI_SDPARM_EXTRACTED}
#
#${NTI_SDPARM_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_SDPARM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDPARM_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${SDPARM_SRC}
#	mv ${EXTTEMP}/sdparm-${SDPARM_VER} ${EXTTEMP}/${NTI_SDPARM_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#NTI_SDPARM_CONFIGURED=${EXTTEMP}/${NTI_SDPARM_TEMP}/config.status
#
#.PHONY: nti-sdparm-configured
#
#nti-sdparm-configured: nti-sdparm-extracted ${NTI_SDPARM_CONFIGURED}
#
#${NTI_SDPARM_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
#	  CFLAGS='-O2' \
#		./configure \
#			--prefix=${NTI_TC_ROOT}/usr \
#			|| exit 1 \
#	)
#
#
### ,-----
### |	Build
### +-----
#
#NTI_SDPARM_BUILT=${EXTTEMP}/${NTI_SDPARM_TEMP}/faked
#
#.PHONY: nti-sdparm-built
#nti-sdparm-built: nti-sdparm-configured ${NTI_SDPARM_BUILT}
#
#${NTI_SDPARM_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
#		make \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#NTI_SDPARM_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked
#
#.PHONY: nti-sdparm-installed
#
#nti-sdparm-installed: nti-sdparm-built ${NTI_SDPARM_INSTALLED}
#
#${NTI_SDPARM_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: nti-sdparm
#nti-sdparm: nti-sdparm-installed
#
#NTARGETS+= nti-sdparm
#
#endif	# HAVE_SDPARM_CONFIG


ifneq (${HAVE_SDPARM_CONFIG},y)
HAVE_SDPARM_CONFIG:=y

#DESCRLIST+= "'nti-sdparm' -- sdparm"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak
# unzip? xzcat? 

ifeq (${SDPARM_VERSION},)
#SDPARM_VERSION=1.06
SDPARM_VERSION=1.10
endif

SDPARM_SRC=${SOURCES}/s/sdparm-${SDPARM_VERSION}.tgz
#URLS+= http://sg.danny.cz/sg/p/sdparm-1.06.tgz
URLS+= http://sg.danny.cz/sg/p/sdparm-${SDPARM_VERSION}.tgz

#include ${CFG_ROOT}/misc/libiconv/v1.12.mak
#include ${CFG_ROOT}/misc/libiconv/v1.14.mak

NTI_SDPARM_TEMP=nti-sdparm-${SDPARM_VERSION}

NTI_SDPARM_EXTRACTED=${EXTTEMP}/${NTI_SDPARM_TEMP}/README
NTI_SDPARM_CONFIGURED=${EXTTEMP}/${NTI_SDPARM_TEMP}/config.status
NTI_SDPARM_BUILT=${EXTTEMP}/${NTI_SDPARM_TEMP}/src/sdparm
NTI_SDPARM_INSTALLED=${NTI_TC_ROOT}/usr/bin/sdparm


## ,-----
## |	Extract
## +-----

${NTI_SDPARM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/sdparm-${SDPARM_VERSION} ] || rm -rf ${EXTTEMP}/sdparm-${SDPARM_VERSION}
	#bzcat ${SDPARM_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${SDPARM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SDPARM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SDPARM_TEMP}
	mv ${EXTTEMP}/sdparm-${SDPARM_VERSION} ${EXTTEMP}/${NTI_SDPARM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SDPARM_CONFIGURED}: ${NTI_SDPARM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SDPARM_BUILT}: ${NTI_SDPARM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_SDPARM_INSTALLED}: ${NTI_SDPARM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_SDPARM_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-sdparm
nti-sdparm: \
	${NTI_SDPARM_INSTALLED}

ALL_NTI_TARGETS+= nti-sdparm

endif	# HAVE_SDPARM_CONFIG
