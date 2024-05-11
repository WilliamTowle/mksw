# rxvt v2.7.10			[ since v2.7.10, c.2013-04-27 ]
# last mod WmT, 2014-02-16	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_RXVT_CONFIG},y)
HAVE_RXVT_CONFIG:=y

#DESCRLIST+= "'cui-rxvt' -- rxvt"

ifeq (${RXVT_VERSION},)
RXVT_VERSION=2.7.10
endif

RXVT_SRC=${SOURCES}/r/rxvt-${RXVT_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/rxvt/rxvt-dev/2.7.10/rxvt-2.7.10.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Frxvt%2Ffiles%2Frxvt-dev%2F2.7.10%2F&ts=1483713799&use_mirror=vorboss
URLS+= http://downloads.sourceforge.net/project/rxvt/rxvt-dev/${RXVT_VERSION}/rxvt-${RXVT_VERSION}.tar.gz?use_mirror=ignum

# X11R7.5 or R7.7?
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.5.0.mak
include ${CFG_ROOT}/x11-r7.5/libXrender/v0.9.5.mak
include ${CFG_ROOT}/x11-r7.5/libXfixes/v4.0.4.mak

NTI_RXVT_TEMP=nti-rxvt-${RXVT_VERSION}
NTI_RXVT_EXTRACTED=${EXTTEMP}/${NTI_RXVT_TEMP}/configure
NTI_RXVT_CONFIGURED=${EXTTEMP}/${NTI_RXVT_TEMP}/config.log
NTI_RXVT_BUILT=${EXTTEMP}/${NTI_RXVT_TEMP}/src/rxvt
NTI_RXVT_INSTALLED=${NTI_TC_ROOT}/usr/bin/rxvt


# ,-----
# |	Extract
# +-----

${NTI_RXVT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/rxvt-${RXVT_VERSION} ] || rm -rf ${EXTTEMP}/rxvt-${RXVT_VERSION}
	zcat ${RXVT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_RXVT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_RXVT_TEMP}
	mv ${EXTTEMP}/rxvt-${RXVT_VERSION} ${EXTTEMP}/${NTI_RXVT_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_RXVT_CONFIGURED}: ${NTI_RXVT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_RXVT_TEMP} || exit 1 ;\
		ac_x_header_dirs=${NTI_TC_ROOT}/usr/include \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-x \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib \
	)


# ,-----
# |	Build
# +-----

${NTI_RXVT_BUILT}: ${NTI_RXVT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_RXVT_TEMP} || exit 1 ;\
		make || exit 1 \
	)


# ,-----
# |	Install
# +-----


${NTI_RXVT_INSTALLED}: ${NTI_RXVT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_RXVT_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-rxvt
#nti-rxvt: nti-libX11 ${NTI_RXVT_INSTALLED}
nti-rxvt: nti-libX11 nti-libXfixes nti-libXrender \
	${NTI_RXVT_INSTALLED}

ALL_NTI_TARGETS+= nti-rxvt

endif	# HAVE_RXVT_CONFIG
