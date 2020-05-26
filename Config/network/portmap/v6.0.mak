# portmap v6.0			[ since v6.0, 2010-05-06 ]
# last mod WmT, 2013-02-25	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_PORTMAP_CONFIG},y)
HAVE_PORTMAP_CONFIG:=y

#DESCRLIST+= "'nti-portmap' -- portmap"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PORTMAP_VERSION},)
PORTMAP_VERSION=6.0
endif

include ${CFG_ROOT}/network/tcp-wrappers/v7.6.mak

#PORTMAP_SRC=${SOURCES}/p/portmap-${PORTMAP_VERSION}.tar.bz2
PORTMAP_SRC=${SOURCES}/p/portmap_${PORTMAP_VERSION}.orig.tar.gz
#URLS+=http://neil.brown.name/portmap/portmap-${PORTMAP_VER}.tgz
URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/p/portmap/portmap_${PORTMAP_VERSION}.orig.tar.gz

NTI_PORTMAP_TEMP=nti-portmap-${PORTMAP_VERSION}

NTI_PORTMAP_EXTRACTED=${EXTTEMP}/${NTI_PORTMAP_TEMP}/README
NTI_PORTMAP_CONFIGURED=${EXTTEMP}/${NTI_PORTMAP_TEMP}/Makefile.OLD
NTI_PORTMAP_BUILT=${EXTTEMP}/${NTI_PORTMAP_TEMP}/portmap
NTI_PORTMAP_INSTALLED=${NTI_TC_ROOT}/sbin/portmap


## ,-----
## |	Extract
## +-----

${NTI_PORTMAP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/portmap-${PORTMAP_VERSION} ] || rm -rf ${EXTTEMP}/portmap-${PORTMAP_VERSION}
	zcat ${PORTMAP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PORTMAP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PORTMAP_TEMP}
	mv ${EXTTEMP}/portmap_${PORTMAP_VERSION} ${EXTTEMP}/${NTI_PORTMAP_TEMP}
	#mv ${EXTTEMP}/portmap-${PORTMAP_VERSION} ${EXTTEMP}/${NTI_PORTMAP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PORTMAP_CONFIGURED}: ${NTI_PORTMAP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PORTMAP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/Beginning/ s%$$%\nCC='${NTI_GCC}'\n%' \
			| sed '/+=.*pie/ s/^/# /' \
			| sed '/CFLAGS.*O2/	s%$$%\nCFLAGS	+= -I'${NTI_TC_ROOT}'/usr/include\nLDFLAGS	+= -L'${NTI_TC_ROOT}'/usr/lib%' \
			| sed '/^	install/	{ s/-o root // ; s/-g root// }' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_PORTMAP_BUILT}: ${NTI_PORTMAP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PORTMAP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PORTMAP_INSTALLED}: ${NTI_PORTMAP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_PORTMAP_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/sbin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/share/man/man8 ;\
		make install BASEDIR=${NTI_TC_ROOT} \
	)

##

.PHONY: nti-portmap
nti-portmap: nti-tcp-wrappers ${NTI_PORTMAP_INSTALLED}

ALL_NTI_TARGETS+= nti-portmap

endif	# HAVE_PORTMAP_CONFIG
