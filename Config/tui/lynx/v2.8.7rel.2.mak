# lynx v2.8.7rel.2		[ since v2.8.4, c.2003-06-04 ]
# last mod WmT, 2015-01-08	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LYNX_CONFIG},y)
HAVE_LYNX_CONFIG:=y

#DESCRLIST+= "'nti-lynx' -- lynx"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LYNX_VERSION},)
#LYNX_VERSION=2.8.6
#LYNX_VERSION=2.8.7
LYNX_VERSION=2.8.7rel.2
endif
LYNX_SRC=${SOURCES}/l/lynx${LYNX_VERSION}.tar.bz2

#URLS+= http://lynx.isc.org/gnumatic/lynx-${LYNX_VERSION}.tar.gz
URLS+= http://lynx.isc.org/lynx${LYNX_VERSION}/lynx${LYNX_VERSION}.tar.bz2

NTI_LYNX_TEMP=nti-lynx-${LYNX_VERSION}

NTI_LYNX_EXTRACTED=${EXTTEMP}/${NTI_LYNX_TEMP}/README
NTI_LYNX_CONFIGURED=${EXTTEMP}/${NTI_LYNX_TEMP}/lynx.cfg.OLD
NTI_LYNX_BUILT=${EXTTEMP}/${NTI_LYNX_TEMP}/lynx
NTI_LYNX_INSTALLED=${NTI_TC_ROOT}/usr/bin/lynx


## ,-----
## |	Extract
## +-----

${NTI_LYNX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lynx-2-8-7 ] || rm -rf ${EXTTEMP}/lynx-2-8-7
	#[ ! -d ${EXTTEMP}/lynx-${LYNX_VERSION} ] || rm -rf ${EXTTEMP}/lynx-${LYNX_VERSION}
	bzcat ${LYNX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LYNX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LYNX_TEMP}
	mv ${EXTTEMP}/lynx2-8-7 ${EXTTEMP}/${NTI_LYNX_TEMP}
#	mv ${EXTTEMP}/lynx-${LYNX_VERSION} ${EXTTEMP}/${NTI_LYNX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LYNX_CONFIGURED}: ${NTI_LYNX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LYNX_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 ;\
		[ -r lynx.cfg.OLD ] || mv lynx.cfg lynx.cfg.OLD || exit 1 ;\
		cat lynx.cfg.OLD \
			| sed '/^#*COLOR:0/	{ s/^#// ; s/[a-z].*/white:black/ }' \
			| sed '/^#*COLOR:1/	{ s/^#// ; s/[a-z].*/brown:black/ }' \
			| sed '/^#*COLOR:2/	{ s/^#// ; s/[a-z].*/yellow:blue/ }' \
			| sed '/^#*COLOR:3/	{ s/^#// ; s/[a-z].*/green:black/ }' \
			| sed '/^#*COLOR:4/	{ s/^#// ; s/[a-z].*/yellow:black/ }' \
			| sed '/^#*COLOR:5/	{ s/^#// ; s/[a-z].*/blue:black/ }' \
			| sed '/^#*COLOR:6/	{ s/^#// ; s/[a-z].*/brightmagenta:black/ }' \
			> lynx.cfg \
	)


## ,-----
## |	Build
## +-----

${NTI_LYNX_BUILT}: ${NTI_LYNX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LYNX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LYNX_INSTALLED}: ${NTI_LYNX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LYNX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-lynx
nti-lynx: ${NTI_LYNX_INSTALLED}

ALL_NTI_TARGETS+= nti-lynx

endif	# HAVE_LYNX_CONFIG
