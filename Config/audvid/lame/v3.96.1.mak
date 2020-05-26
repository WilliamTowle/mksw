# lame v3.96.1			[ since v?.? ????-??-?? ]
# last mod WmT, 2012-10-24	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_LAME_CONFIG},y)
HAVE_LAME_CONFIG:=y

#DESCRLIST+= "'nti-lame' -- lame"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${LAME_VERSION},)
LAME_VERSION=3.96.1
#LAME_VERSION=3.98.2
#LAME_VERSION=3.98.3
endif
LAME_SRC=${SOURCES}/l/lame-${LAME_VERSION}.tar.gz
#LAME_SRC=${SOURCES}/l/lame-398-2.tar.gz

#URLS+= http://downloads.sourceforge.net/project/lame/lame/3.98.2/lame-398-2.tar.gz?use_mirror=ignum 
URLS+=http://downloads.sourceforge.net/project/lame/lame/3.98.3/lame-${LAME_VERSION}.tar.gz?use_mirror=surfnet

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

${NTI_LAME_CONFIGURED}: ${NTI_LAME_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LAME_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
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
nti-lame: ${NTI_LAME_INSTALLED}

ALL_NTI_TARGETS+= nti-lame

endif	# HAVE_LAME_CONFIG
