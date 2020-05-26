## xz-utils v5.0.6		[ since v5.0.5, c.2014-01-08 ]
## last mod WmT, 2014-09-17	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_XZ_CONFIG},y)
HAVE_XZ_CONFIG:=y

#DESCRLIST+= "'nti-xz' -- xz"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${XZ_VERSION},)
#XZ_VERSION=5.0.5
XZ_VERSION=5.0.6
endif

XZ_SRC=${SOURCES}/x/xz-${XZ_VERSION}.tar.bz2
URLS+= http://tukaani.org/xz/xz-${XZ_VERSION}.tar.bz2

NTI_XZ_TEMP=nti-xz-${XZ_VERSION}

NTI_XZ_EXTRACTED=${EXTTEMP}/${NTI_XZ_TEMP}/configure
NTI_XZ_CONFIGURED=${EXTTEMP}/${NTI_XZ_TEMP}/config.log
NTI_XZ_BUILT=${EXTTEMP}/${NTI_XZ_TEMP}/src/xz/xz
NTI_XZ_INSTALLED=${NTI_TC_ROOT}/usr/bin/xz


## ,-----
## |	Extract
## +-----

${NTI_XZ_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xz-${XZ_VERSION} ] || rm -rf ${EXTTEMP}/xz-${XZ_VERSION}
	bzcat ${XZ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XZ_TEMP}
	mv ${EXTTEMP}/xz-${XZ_VERSION} ${EXTTEMP}/${NTI_XZ_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XZ_CONFIGURED}: ${NTI_XZ_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XZ_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_XZ_BUILT}: ${NTI_XZ_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XZ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XZ_INSTALLED}: ${NTI_XZ_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XZ_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-xz
nti-xz: ${NTI_XZ_INSTALLED}

ALL_NTI_TARGETS+= nti-xz

endif	# HAVE_XZ_CONFIG
