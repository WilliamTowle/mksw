# libviper v1.4.6		[ since v1.4.6, c.2017-03-28 ]
# last mod WmT, 2017-03-28	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBVIPER_CONFIG},y)
HAVE_LIBVIPER_CONFIG:=y

#DESCRLIST+= "'cti-libviper' -- libviper"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


ifeq (${LIBVIPER_VERSION},)
LIBVIPER_VERSION:=1.4.6
endif

LIBVIPER_SRC=${SOURCES}/l/libviper-${LIBVIPER_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/libviper/libviper-1.4.6.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibviper%2F%3Fsource%3Drecommended&ts=1490691817&use_mirror=netcologne"


include ${CFG_ROOT}/tui/gpm/v1.20.7.mak

NTI_LIBVIPER_TEMP=nti-libviper-${LIBVIPER_VERSION}

NTI_LIBVIPER_EXTRACTED=${EXTTEMP}/${NTI_LIBVIPER_TEMP}/LICENSE
NTI_LIBVIPER_CONFIGURED=${EXTTEMP}/${NTI_LIBVIPER_TEMP}/Makefile.OLD
NTI_LIBVIPER_BUILT=${EXTTEMP}/${NTI_LIBVIPER_TEMP}/libviper.so
NTI_LIBVIPER_INSTALLED=${NTI_TC_ROOT}/usr/local/lib/libviper.so


## ,-----
## |	Extract
## +-----

${NTI_LIBVIPER_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/libviper-${LIBVIPER_VERSION} ] || rm -rf ${EXTTEMP}/libviper-${LIBVIPER_VERSION}
	[ ! -d ${EXTTEMP}/libviper ] || rm -rf ${EXTTEMP}/libviper
	zcat ${LIBVIPER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBVIPER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBVIPER_TEMP}
	#mv ${EXTTEMP}/libviper-${LIBVIPER_VERSION} ${EXTTEMP}/${NTI_LIBVIPER_TEMP}
	mv ${EXTTEMP}/libviper ${EXTTEMP}/${NTI_LIBVIPER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBVIPER_CONFIGURED}: ${NTI_LIBVIPER_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVIPER_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC = '${NTI_GCC}'\n%' \
			| sed '/^	/	s/g*cc/$$(CC)/' \
			| sed 's/PKG_CFG/PKG_CFLAGS/' \
			| sed '/^PKG_CFLAGS/	s%=%= -I'${NTI_TC_ROOT}'/usr/include%' \
			| sed '/^prefix/	s%^%DESTDIR = '${NTI_TC_ROOT}'\n%' \
			| sed '/^	/	s%$$(includedir)/*%$$(DESTDIR)$$(includedir)/%' \
			| sed '/^	/	s%$$(libdir)/*%$$(DESTDIR)$$(libdir)/%' \
			| sed '/ldconfig/	{ s/^	/	-/ ; s%-ldconfig%-/sbin/ldconfig% }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBVIPER_BUILT}: ${NTI_LIBVIPER_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVIPER_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBVIPER_INSTALLED}: ${NTI_LIBVIPER_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBVIPER_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/include/' || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/lib/' || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libviper
#nti-libviper: nti-libtool nti-pkg-config \
#	${NTI_LIBVIPER_INSTALLED}
nti-libviper: nti-gpm ${NTI_LIBVIPER_INSTALLED}

ALL_NTI_TARGETS+= nti-libviper

endif	# HAVE_LIBVIPER_CONFIG
