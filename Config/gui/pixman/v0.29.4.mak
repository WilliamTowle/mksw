# pixman v0.29.4		[ since v0.21.8, c. 2011-09-23 ]
# last mod WmT, 2015-10-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_PIXMAN_CONFIG},y)
HAVE_PIXMAN_CONFIG:=y

#DESCRLIST+= "'nti-pixman' -- pixman"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PIXMAN_VERSION},)
# XOrg's X server requires v>=0.21.8
#PIXMAN_VERSION=0.21.8
#PIXMAN_VERSION=0.28.2
PIXMAN_VERSION=0.29.4
endif

PIXMAN_SRC=${SOURCES}/p/pixman-${PIXMAN_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/pixman-${PIXMAN_VERSION}.tar.bz2
# http://cairographics.org/releases/pixman-0.28.2.tar.gz

NTI_PIXMAN_TEMP=nti-pixman-${PIXMAN_VERSION}

NTI_PIXMAN_EXTRACTED=${EXTTEMP}/${NTI_PIXMAN_TEMP}/README
NTI_PIXMAN_CONFIGURED=${EXTTEMP}/${NTI_PIXMAN_TEMP}/config.log
NTI_PIXMAN_BUILT=${EXTTEMP}/${NTI_PIXMAN_TEMP}/pixman
NTI_PIXMAN_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/pixman-1.pc


## ,-----
## |	Extract
## +-----

${NTI_PIXMAN_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/pixman-${PIXMAN_VERSION} ] || rm -rf ${EXTTEMP}/pixman-${PIXMAN_VERSION}
	bzcat ${PIXMAN_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PIXMAN_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PIXMAN_TEMP}
	mv ${EXTTEMP}/pixman-${PIXMAN_VERSION} ${EXTTEMP}/${NTI_PIXMAN_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PIXMAN_CONFIGURED}: ${NTI_PIXMAN_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PIXMAN_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --enable-shared --disable-static \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PIXMAN_BUILT}: ${NTI_PIXMAN_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PIXMAN_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PIXMAN_INSTALLED}: ${NTI_PIXMAN_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PIXMAN_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_PIXMAN_INSTALLED} ` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/pixman-1.pc ${NTI_PIXMAN_INSTALLED} \

##

.PHONY: nti-pixman
nti-pixman: ${NTI_PIXMAN_INSTALLED}

ALL_NTI_TARGETS+= nti-pixman

endif	# HAVE_PIXMAN_CONFIG
