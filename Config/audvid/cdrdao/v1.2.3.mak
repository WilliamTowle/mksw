# cdrdao v1.2.3			[ since v1.2.3, c.2015-12-15 ]
# last mod WmT, 2015-12-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_CDRDAO_CONFIG},y)
HAVE_CDRDAO_CONFIG:=y

#DESCRLIST+= "'nti-cdrdao' -- cdrdao"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CDRDAO_VERSION},)
#CDRDAO_VERSION=1.2.0
CDRDAO_VERSION=1.2.3
endif

CDRDAO_SRC=${SOURCES}/c/cdrdao-${CDRDAO_VERSION}.tar.bz2
#CDRDAO_SRC=${SOURCES}/c/cdrdao-${CDRDAO_VERSION}.tar.gz
URLS+= http://downloads.sourceforge.net/project/cdrdao/cdrdao/${CDRDAO_VERSION}/cdrdao-${CDRDAO_VERSION}.tar.bz2?use_mirror=kent
#URLS+= http://downloads.sourceforge.net/project/cdrdao/cdrdao/${CDRDAO_VERSION}/cdrdao-${CDRDAO_VERSION}.tar.gz?use_mirror=kent

## for v1.2.3 ... debian have v0.1, v0.3, v2
#CDRDAO_PATCHES=${SOURCES}/c/cdrdao_1.2.3-0.1.debian.tar.gz
#URLS+= http://http.debian.net/debian/pool/main/c/cdrdao/cdrdao_1.2.3-0.1.debian.tar.gz

#include ${CFG_ROOT}/audvid/lame/v3.99.5.mak

NTI_CDRDAO_TEMP=nti-cdrdao-${CDRDAO_VERSION}

NTI_CDRDAO_EXTRACTED=${EXTTEMP}/${NTI_CDRDAO_TEMP}/configure
NTI_CDRDAO_CONFIGURED=${EXTTEMP}/${NTI_CDRDAO_TEMP}/config.log
NTI_CDRDAO_BUILT=${EXTTEMP}/${NTI_CDRDAO_TEMP}/cdrdao
NTI_CDRDAO_INSTALLED=${NTI_TC_ROOT}/usr/bin/cdrdao


## ,-----
## |	Extract
## +-----

${NTI_CDRDAO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cdrdao-${CDRDAO_VERSION} ] || rm -rf ${EXTTEMP}/cdrdao-${CDRDAO_VERSION}
	bzcat ${CDRDAO_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${CDRDAO_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${CDRDAO_PATCHES},)
	( cd ${EXTTEMP}/cdrdao-${CDRDAO_VERSION} || exit 1 ;\
		zcat ${CDRDAO_PATCHES} | tar xvf - || exit 1 ;\
		for PF in debian/patches/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} || exit 1 ;\
			patch --batch -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_CDRDAO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CDRDAO_TEMP}
	mv ${EXTTEMP}/cdrdao-${CDRDAO_VERSION} ${EXTTEMP}/${NTI_CDRDAO_TEMP}


## ,-----
## |	Configure
## +-----

## linuxfromscratch: sets --mandir=/usr/share/man

${NTI_CDRDAO_CONFIGURED}: ${NTI_CDRDAO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CDRDAO_TEMP} || exit 1 ;\
		case ${CDRDAO_VERSION} in \
		1.2.3) \
			[ -r dao/ScsiIf-linux.cc.OLD ] || mv dao/ScsiIf-linux.cc dao/ScsiIf-linux.cc.OLD || exit 1 ;\
			cat dao/ScsiIf-linux.cc.OLD \
				| sed '/ioctl/a #include <sys/stat.h>' \
				> dao/ScsiIf-linux.cc || exit 1 \
		;; \
		esac ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)
#		CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
#		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \


## ,-----
## |	Build
## +-----

${NTI_CDRDAO_BUILT}: ${NTI_CDRDAO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CDRDAO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CDRDAO_INSTALLED}: ${NTI_CDRDAO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CDRDAO_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-cdrdao
nti-cdrdao: ${NTI_CDRDAO_INSTALLED}
#nti-cdrdao: nti-nasm \
#		nti-lame ${NTI_CDRDAO_INSTALLED}

ALL_NTI_TARGETS+= nti-cdrdao

endif	# HAVE_CDRDAO_CONFIG
