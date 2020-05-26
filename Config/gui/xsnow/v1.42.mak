# xsnow v1.42			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XSNOW_CONFIG},y)
HAVE_XSNOW_CONFIG:=y

#DESCRLIST+= "'nti-xsnow' -- xsnow"
include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XSNOW_VERSION},)
XSNOW_VERSION=1.42
endif

XSNOW_SRC=${SOURCES}/x/xsnow-${XSNOW_VERSION}.tar.gz
URLS+= http://dropmix.xs4all.nl/rick/Xsnow/xsnow-${XSNOW_VERSION}.tar.gz

ifeq (${XSNOW_NEEDS_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak
endif

NTI_XSNOW_TEMP=nti-xsnow-${XSNOW_VERSION}

NTI_XSNOW_EXTRACTED=${EXTTEMP}/${NTI_XSNOW_TEMP}/README
NTI_XSNOW_CONFIGURED=${EXTTEMP}/${NTI_XSNOW_TEMP}/Makefile.OLD
NTI_XSNOW_BUILT=${EXTTEMP}/${NTI_XSNOW_TEMP}/xsnow
NTI_XSNOW_INSTALLED=${NTI_TC_ROOT}/usr/X11R6/bin/xsnow


## ,-----
## |	Extract
## +-----

${NTI_XSNOW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xsnow-${XSNOW_VERSION} ] || rm -rf ${EXTTEMP}/xsnow-${XSNOW_VERSION}
	zcat ${XSNOW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XSNOW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XSNOW_TEMP}
	mv ${EXTTEMP}/xsnow-${XSNOW_VERSION} ${EXTTEMP}/${NTI_XSNOW_TEMP}


## ,-----
## |	Configure
## +-----

# 1. Fix up the desired paths
# 2. Remove the default dependency list - it's platform-specific

${NTI_XSNOW_CONFIGURED}: ${NTI_XSNOW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XSNOW_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/BINDIR =/	s%/usr%'${NTI_TC_ROOT}'/usr%' \
			| sed '/ INCROOT =/	s%=.*%= '${NTI_TC_ROOT}'/usr/include%' \
			| sed '/ USRLIBDIR =/	s%=.*%= '${NTI_TC_ROOT}'/usr/lib%' \
			| sed '/DO NOT DELETE/,$$	d' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_XSNOW_BUILT}: ${NTI_XSNOW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XSNOW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XSNOW_INSTALLED}: ${NTI_XSNOW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XSNOW_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-xsnow
ifeq (${XSNOW_NEEDS_X11},true)
nti-xsnow: nti-libX11 nti-libXpm \
	${NTI_XSNOW_INSTALLED}
else
nti-xsnow: \
	${NTI_XSNOW_INSTALLED}
endif


ALL_NTI_TARGETS+= nti-xsnow

endif	# HAVE_XSNOW_CONFIG
