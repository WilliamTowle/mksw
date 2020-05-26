# lame v3.99.5			[ since v?.? ????-??-?? ]
# last mod WmT, 2015-12-21	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_LAME_CONFIG},y)
HAVE_LAME_CONFIG:=y

#DESCRLIST+= "'nti-lame' -- lame"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LAME_VERSION},)
#LAME_VERSION=3.96.1
LAME_VERSION=3.99.5
endif
LAME_SRC=${SOURCES}/l/lame-${LAME_VERSION}.tar.gz
#LAME_SRC=${SOURCES}/l/lame-398-2.tar.gz

#URLS+=http://downloads.sourceforge.net/project/lame/lame/3.98.3/lame-${LAME_VERSION}.tar.gz?use_mirror=surfnet
URLS+= http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz?use_mirror=ignum

#include ${CFG_ROOT}/buildtools/nasm/v2.11.08.mak
include ${CFG_ROOT}/buildtools/nasm/v2.12.mak

NTI_LAME_TEMP=nti-lame-${LAME_VERSION}

NTI_LAME_EXTRACTED=${EXTTEMP}/${NTI_LAME_TEMP}/README
NTI_LAME_CONFIGURED=${EXTTEMP}/${NTI_LAME_TEMP}/config.log
NTI_LAME_BUILT=${EXTTEMP}/${NTI_LAME_TEMP}/frontend/lame
NTI_LAME_INSTALLED=${NTI_TC_ROOT}/usr/bin/lame


## ,-----
## |	Extract
## +-----

${NTI_LAME_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lame-${LAME_VERSION} ] || rm -rf ${EXTTEMP}/lame-${LAME_VERSION}
	zcat ${LAME_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LAME_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LAME_TEMP}
	mv ${EXTTEMP}/lame-${LAME_VERSION} ${EXTTEMP}/${NTI_LAME_TEMP}


## ,-----
## |	Configure
## +-----

# test `uname -m` to fix for gcc 4.9.0+ on 32-bit x86

${NTI_LAME_CONFIGURED}: ${NTI_LAME_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LAME_TEMP} || exit 1 ;\
		case $$(uname -m) in \
		i?86) \
			[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
			cat configure.OLD \
				| sed '/xmmintrin\.h/ d' \
				>configure ;\
			chmod a+x configure \
		;; \
		esac ;\
	  CFLAGS='-O2' \
	  CC=${NTI_GCC} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-nasm \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LAME_BUILT}: ${NTI_LAME_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LAME_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LAME_INSTALLED}: ${NTI_LAME_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LAME_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-lame
nti-lame: nti-nasm \
	${NTI_LAME_INSTALLED}

ALL_NTI_TARGETS+= nti-lame

endif	# HAVE_LAME_CONFIG
