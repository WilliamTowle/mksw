# libusb v0.1.12		[ since v0.1.12, c.2011-06-15 ]
# last mod WmT, 2011-06-16	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LIBUSB_CONFIG},y)
HAVE_LIBUSB_CONFIG:=y

DESCRLIST+= "'nti-libusb' -- libusb"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
ifeq (${ACTION},buildc)
include ${CFG_ROOT}/ENV/target.mak
endif

ifeq (${ACTION},buildn)
ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif
else
ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
endif
endif
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

LIBUSB_VER=0.1.12
LIBUSB_SRC=${SRCDIR}/l/libusb-0.1.12.tar.gz

URLS+= http://prdownloads.sourceforge.net/libusb/libusb-0.1.12.tar.gz


# ,-----
# |	Extract
# +-----

NTI_LIBUSB_TEMP=nti-libusb-${LIBUSB_VER}

NTI_LIBUSB_EXTRACTED=${EXTTEMP}/${NTI_LIBUSB_TEMP}/configure

.PHONY: nti-libusb-extracted

nti-libusb-extracted: ${NTI_LIBUSB_EXTRACTED}

${NTI_LIBUSB_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBUSB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBUSB_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBUSB_SRC}
	mv ${EXTTEMP}/libusb-${LIBUSB_VER} ${EXTTEMP}/${NTI_LIBUSB_TEMP}

##

CTI_LIBUSB_TEMP=cti-libusb-${LIBUSB_VER}

CTI_LIBUSB_EXTRACTED=${EXTTEMP}/${CTI_LIBUSB_TEMP}/configure

.PHONY: cti-libusb-extracted

cti-libusb-extracted: ${CTI_LIBUSB_EXTRACTED}

${CTI_LIBUSB_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_LIBUSB_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBUSB_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBUSB_SRC}
	mv ${EXTTEMP}/libusb-${LIBUSB_VER} ${EXTTEMP}/${CTI_LIBUSB_TEMP}


# ,-----
# |	Configure
# +-----

NTI_LIBUSB_CONFIGURED=${EXTTEMP}/${NTI_LIBUSB_TEMP}/config.status

.PHONY: nti-libusb-configured

nti-libusb-configured: nti-libusb-extracted ${NTI_LIBUSB_CONFIGURED}

${NTI_LIBUSB_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
	  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-largefile \
			|| exit 1 \
	)

##

CTI_LIBUSB_CONFIGURED=${EXTTEMP}/${CTI_LIBUSB_TEMP}/config.status

.PHONY: cti-libusb-configured

cti-libusb-configured: cti-libusb-extracted ${CTI_LIBUSB_CONFIGURED}

${CTI_LIBUSB_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LIBUSB_TEMP} || exit 1 ;\
	  CC=${CTI_GCC} \
	  CFLAGS='-O2' \
	  LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_CPU}-linux \
			|| exit 1 \
	)
#[--host was]			--host=${CTI_SPEC} \


# ,-----
# |	Build
# +-----

NTI_LIBUSB_BUILT=${EXTTEMP}/${NTI_LIBUSB_TEMP}/.libs/libusbpp.a

.PHONY: nti-libusb-built
nti-libusb-built: nti-libusb-configured ${NTI_LIBUSB_BUILT}

${NTI_LIBUSB_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
		make \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${NTI_SPEC}-libtool \
	)

##

CTI_LIBUSB_BUILT=${EXTTEMP}/${CTI_LIBUSB_TEMP}/.libs/libusbpp.a

.PHONY: cti-libusb-built
cti-libusb-built: cti-libusb-configured ${CTI_LIBUSB_BUILT}

${CTI_LIBUSB_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LIBUSB_TEMP} || exit 1 ;\
		make \
		  LIBTOOL=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-libtool \
	)


# ,-----
# |	Install
# +-----

NTI_LIBUSB_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/libusb.pc

.PHONY: nti-libusb-installed

nti-libusb-installed: nti-libusb-built ${NTI_LIBUSB_INSTALLED}

${NTI_LIBUSB_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBUSB_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libusb
nti-libusb: nti-native-gcc nti-libtool nti-libusb-installed

NTARGETS+= nti-libusb

##

.PHONY: cti-libusb
#cti-libusb: cti-cross-gcc cti-cross-libtool cti-libusb-configured
cti-libusb: cti-cross-gcc cti-cross-libtool cti-libusb-built
#cti-libusb: cti-cross-gcc cti-cross-libtool cti-libusb-installed

CTARGETS+= cti-libusb

endif	# HAVE_LIBUSB_CONFIG
