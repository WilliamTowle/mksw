# mrxvt v0.5.4			[ since v0.5.4, c.2013-12-23 ]
# last mod WmT, 2014-02-23	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_MRXVT_CONFIG},y)
HAVE_MRXVT_CONFIG:=y

# NB. v0.5.4 has hardwired 'pkg-config' references

#DESCRLIST+= "'cui-mrxvt' -- mrxvt"

ifeq (${MRXVT_VERSION},)
MRXVT_VERSION=0.5.4
endif

MRXVT_SRC=${SOURCES}/m/mrxvt-${MRXVT_VERSION}.tar.gz
#URLS+= http://downloads.sourceforge.net/project/materm/mrxvt%20source/0.5.4/mrxvt-0.5.4.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmaterm%2Ffiles%2Fmrxvt%2520source%2F0.5.4%2F&ts=1483713875&use_mirror=kent
URLS+= http://downloads.sourceforge.net/project/materm/mrxvt%20source/${MRXVT_VERSION}/mrxvt-${MRXVT_VERSION}.tar.gz?use_mirror=ignum

# X11R7.5 or R7.6/7.7?
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak

NTI_MRXVT_TEMP=nti-mrxvt-${MRXVT_VERSION}
NTI_MRXVT_EXTRACTED=${EXTTEMP}/${NTI_MRXVT_TEMP}/configure
NTI_MRXVT_CONFIGURED=${EXTTEMP}/${NTI_MRXVT_TEMP}/config.log
NTI_MRXVT_BUILT=${EXTTEMP}/${NTI_MRXVT_TEMP}/src/mrxvt
NTI_MRXVT_INSTALLED=${NTI_TC_ROOT}/usr/bin/mrxvt


# ,-----
# |	Extract
# +-----

${NTI_MRXVT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/mrxvt-${MRXVT_VERSION} ] || rm -rf ${EXTTEMP}/mrxvt-${MRXVT_VERSION}
	zcat ${MRXVT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MRXVT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MRXVT_TEMP}
	mv ${EXTTEMP}/mrxvt-${MRXVT_VERSION} ${EXTTEMP}/${NTI_MRXVT_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_MRXVT_CONFIGURED}: ${NTI_MRXVT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MRXVT_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		LD_LIBRARY_PATH=${NTI_TC_ROOT}/usr/lib \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--with-x \
			--x-includes=${NTI_TC_ROOT}/usr/include \
			--x-libraries=${NTI_TC_ROOT}/usr/lib \
			--enable-minimal \
			--enable-menubar \
			--disable-xpm \
			--disable-jpeg \
			--disable-png \
	)
#		PKGCONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


# ,-----
# |	Build
# +-----

${NTI_MRXVT_BUILT}: ${NTI_MRXVT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MRXVT_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----


${NTI_MRXVT_INSTALLED}: ${NTI_MRXVT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MRXVT_TEMP} || exit 1 ;\
		make install \
			|| exit 1 \
	)

.PHONY: nti-mrxvt
nti-mrxvt: nti-libX11 ${NTI_MRXVT_INSTALLED}

ALL_NTI_TARGETS+= nti-mrxvt

endif	# HAVE_MRXVT_CONFIG
