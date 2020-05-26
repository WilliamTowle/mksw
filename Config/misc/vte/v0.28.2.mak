# vte v0.28.2			[ earliest vB.02.16, 2013-04-29 ]
# last mod WmT, 2013-04-29	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_VTE_CONFIG},y)
HAVE_VTE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-vte' -- vte"

ifeq (${VTE_VERSION},)
VTE_VERSION=0.28.2
endif
VTE_SRC=${SOURCES}/v/vte_${VTE_VERSION}.orig.tar.bz2
#VTE_SRC=${SOURCES}/v/vte-${VTE_VERSION}.tar.bz2

URLS+= http://mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/v/vte/vte_0.28.2.orig.tar.bz2

include ${CFG_ROOT}/misc/glib/v2.30.0.mak
include ${CFG_ROOT}/misc/intltool/v0.37.1.mak

NTI_VTE_TEMP=nti-vte-${VTE_VERSION}

NTI_VTE_EXTRACTED=${EXTTEMP}/${NTI_VTVTEMP}/Makefile
NTI_VTE_CONFIGURED=${EXTTEMP}/${NTI_VTE_TEMP}/.configure.done
NTI_VTE_BUILT=${EXTTEMP}/${NTI_VTE_TEMP}/vte-runtime/src/vte.sh
NTI_VTE_INSTALLED=${NTI_TC_ROOT}/usr/lib/libvte.so


## ,-----
## |	Extract
## +-----

${NTI_VTE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/vte-${VTE_VERSION} ] || rm -rf ${EXTTEMP}/vte-${VTE_VERSION}
	bzcat ${VTE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VTE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VTE_TEMP}
	mv ${EXTTEMP}/vte-${VTE_VERSION} ${EXTTEMP}/${NTI_VTE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VTE_CONFIGURED}: ${NTI_VTE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_VTE_TEMP} || exit 1 ;\
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
	)
#		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

${NTI_VTE_BUILT}: ${NTI_VTE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_VTE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VTE_INSTALLED}: ${NTI_VTE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_VTE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-vte
nti-vte: nti-glib nti-intltool ${NTI_VTE_INSTALLED}

ALL_NTI_TARGETS+= nti-vte

endif	# HAVE_VTE_CONFIG
