# libusb v0.1.19		[ since v0.1.12, c.2011-06-15 ]
# last mod WmT, 2015-06-10	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBUSB_CONFIG},y)
HAVE_LIBUSB_CONFIG:=y

#DESCRLIST+= "'nti-libusb' -- libusb"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBUSB_VERSION},)
LIBUSB_VERSION=1.0.19
endif

LIBUSB_SRC=${SOURCES}/l/libusb-${LIBUSB_VERSION}.tar.bz2
URLS+= http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.19/libusb-${LIBUSB_VERSION}.tar.bz2?use_mirror=ignum

NTI_LIBUSB_TEMP=nti-libusb-${LIBUSB_VERSION}

NTI_LIBUSB_EXTRACTED=${EXTTEMP}/${NTI_LIBUSB_TEMP}/configure
NTI_LIBUSB_CONFIGURED=${EXTTEMP}/${NTI_LIBUSB_TEMP}/Makefile.OLD
NTI_LIBUSB_BUILT=${EXTTEMP}/${NTI_LIBUSB_TEMP}/libusb
NTI_LIBUSB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libusb-1.0.pc


## +-----
## |	Extract
## +-----

${NTI_LIBUSB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libusb-${LIBUSB_VERSION} ] || rm -rf ${EXTTEMP}/libusb-${LIBUSB_VERSION}
	#[ ! -d ${EXTTEMP}/libusb} ] || rm -rf ${EXTTEMP}/libusb-${LIBUSB_VERSION}
	bzcat ${LIBUSB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBUSB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBUSB_TEMP}
	mv ${EXTTEMP}/libusb-${LIBUSB_VERSION} ${EXTTEMP}/${NTI_LIBUSB_TEMP}
	#mv ${EXTTEMP}/libusb} ${EXTTEMP}/${NTI_LIBUSB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBUSB_CONFIGURED}: ${NTI_LIBUSB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-udev \
			|| exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^pkgconfigdir/	s%=.*%= '${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBUSB_BUILT}: ${NTI_LIBUSB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBUSB_INSTALLED}: ${NTI_LIBUSB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libusb
nti-libusb: ${NTI_LIBUSB_INSTALLED}

ALL_NTI_TARGETS+= nti-libusb

endif	# HAVE_LIBUSB_CONFIG
