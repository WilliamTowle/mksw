# openbox v3.5.0		[ since v0.70.1, c.2013-04-29 ]
# last mod WmT, 2013-04-29	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_OPENBOX_CONFIG},y)
HAVE_OPENBOX_CONFIG:=y

#DESCRLIST+= "'cui-openbox' -- openbox"

ifeq (${OPENBOX_VERSION},)
OPENBOX_VERSION=3.5.0
endif

OPENBOX_SRC=${SOURCES}/o/openbox-${OPENBOX_VERSION}.tar.gz
URLS+= http://openbox.org/dist/openbox/openbox-3.5.0.tar.gz

## X11R7.5 or R7.6/7.7?
#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
##include ${CFG_ROOT}/gui/libX11/v1.4.0.mak

NTI_OPENBOX_TEMP=nti-openbox-${OPENBOX_VERSION}
NTI_OPENBOX_EXTRACTED=${EXTTEMP}/${NTI_OPENBOX_TEMP}/Makefile
NTI_OPENBOX_CONFIGURED=${EXTTEMP}/${NTI_OPENBOX_TEMP}/config.log
NTI_OPENBOX_BUILT=${EXTTEMP}/${NTI_OPENBOX_TEMP}/openbox
NTI_OPENBOX_INSTALLED=${NTI_TC_ROOT}/usr/bin/openbox


# ,-----
# |	Extract
# +-----

${NTI_OPENBOX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/openbox-${OPENBOX_VERSION} ] || rm -rf ${EXTTEMP}/openbox-${OPENBOX_VERSION}
	zcat ${OPENBOX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPENBOX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENBOX_TEMP}
	mv ${EXTTEMP}/openbox-${OPENBOX_VERSION} ${EXTTEMP}/${NTI_OPENBOX_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_OPENBOX_CONFIGURED}: ${NTI_OPENBOX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_OPENBOX_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
	)


# ,-----
# |	Build
# +-----

${NTI_OPENBOX_BUILT}: ${NTI_OPENBOX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_OPENBOX_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_OPENBOX_INSTALLED}: ${NTI_OPENBOX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_OPENBOX_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-openbox
nti-openbox: ${NTI_OPENBOX_INSTALLED}
#nti-openbox: nti-libX11 ${NTI_OPENBOX_INSTALLED}

ALL_NTI_TARGETS+= nti-openbox

endif	# HAVE_OPENBOX_CONFIG
