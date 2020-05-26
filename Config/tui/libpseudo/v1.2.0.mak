# libpseudo v1.2.0		[ since v1.2.0, c.2017-03-28 ]
# last mod WmT, 2017-03-28	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBPSEUDO_CONFIG},y)
HAVE_LIBPSEUDO_CONFIG:=y

#DESCRLIST+= "'cti-libpseudo' -- libpseudo"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


ifeq (${LIBPSEUDO_VERSION},)
LIBPSEUDO_VERSION:=1.2.0
endif

LIBPSEUDO_SRC=${SOURCES}/l/libpseudo-${LIBPSEUDO_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/libpseudo/libpseudo-1.2.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibpseudo%2F%3Fsource%3Drecommended&ts=1490689869&use_mirror=kent"


NTI_LIBPSEUDO_TEMP=nti-libpseudo-${LIBPSEUDO_VERSION}

NTI_LIBPSEUDO_EXTRACTED=${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}/LICENSE
NTI_LIBPSEUDO_CONFIGURED=${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}/Makefile.OLD
NTI_LIBPSEUDO_BUILT=${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}/libpseudo.so
NTI_LIBPSEUDO_INSTALLED=${NTI_TC_ROOT}/usr/local/lib/libpseudo.so


## ,-----
## |	Extract
## +-----

${NTI_LIBPSEUDO_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/libpseudo-${LIBPSEUDO_VERSION} ] || rm -rf ${EXTTEMP}/libpseudo-${LIBPSEUDO_VERSION}
	[ ! -d ${EXTTEMP}/libpseudo ] || rm -rf ${EXTTEMP}/libpseudo
	zcat ${LIBPSEUDO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}
	#mv ${EXTTEMP}/libpseudo-${LIBPSEUDO_VERSION} ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}
	mv ${EXTTEMP}/libpseudo ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBPSEUDO_CONFIGURED}: ${NTI_LIBPSEUDO_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC = '${NTI_GCC}'\n%' \
			| sed '/^prefix/	s%^%DESTDIR = '${NTI_TC_ROOT}'\n%' \
			| sed '/^	/	s/g*cc/$$(CC)/' \
			| sed '/^	/	s%$$(includedir)/*%$$(DESTDIR)$$(includedir)/%' \
			| sed '/^	/	s%$$(libdir)/*%$$(DESTDIR)$$(libdir)/%' \
			| sed '/^	/	s%/usr/local/lib%$$(DESTDIR)$$(libdir)%' \
			| sed '/ldconfig/	{ s/^	/	-/ ; s%-ldconfig%-/sbin/ldconfig% }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBPSEUDO_BUILT}: ${NTI_LIBPSEUDO_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBPSEUDO_INSTALLED}: ${NTI_LIBPSEUDO_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBPSEUDO_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/include/' || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}'/usr/local/lib/' || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libpseudo
#nti-libpseudo: nti-libtool nti-pkg-config \
#	${NTI_LIBPSEUDO_INSTALLED}
nti-libpseudo: ${NTI_LIBPSEUDO_INSTALLED}

ALL_NTI_TARGETS+= nti-libpseudo

endif	# HAVE_LIBPSEUDO_CONFIG
