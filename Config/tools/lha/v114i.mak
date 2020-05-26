# lha v114i			[ EARLIEST v?.?? ]
# last mod WmT, 2012-12-23	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_LHA_CONFIG},y)
HAVE_LHA_CONFIG:=y

#DESCRLIST+= "'nti-lha' -- lha"

#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LHA_VERSION},)
LHA_VERSION=114i
endif

#LHA_SRC=${SOURCES}/l/lha-${LHA_VERSION}.tar.gz
LHA_SRC=${SOURCES}/l/lha_1.14i.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/multiverse/l/lha/lha_1.14i.orig.tar.gz

NTI_LHA_TEMP=nti-lha-${LHA_VERSION}

NTI_LHA_EXTRACTED=${EXTTEMP}/${NTI_LHA_TEMP}/src/lha.h
NTI_LHA_CONFIGURED=${EXTTEMP}/${NTI_LHA_TEMP}/Makefile.OLD
NTI_LHA_BUILT=${EXTTEMP}/${NTI_LHA_TEMP}/src/lha
NTI_LHA_INSTALLED=${NTI_TC_ROOT}/usr/bin/lha


## ,-----
## |	Extract
## +-----

${NTI_LHA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/lha-${LHA_VERSION} ] || rm -rf ${EXTTEMP}/lha-${LHA_VERSION}
	[ ! -d ${EXTTEMP}/lha-1.14i.orig ] || rm -rf ${EXTTEMP}/lha-1.14i.orig
	zcat ${LHA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LHA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LHA_TEMP}
	#mv ${EXTTEMP}/lha-${LHA_VERSION} ${EXTTEMP}/${NTI_LHA_TEMP}
	mv ${EXTTEMP}/lha-1.14i.orig ${EXTTEMP}/${NTI_LHA_TEMP}


## ,-----
## |	Configure
## +-----

# TODO: adapt CC= in Makefile to suit selected compiler

${NTI_LHA_CONFIGURED}: ${NTI_LHA_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^[A-Z]*DIR/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_LHA_BUILT}: ${NTI_LHA_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LHA_INSTALLED}: ${NTI_LHA_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/bin ;\
		mkdir -p ${NTI_TC_ROOT}/usr/man/mann ;\
		make install || exit 1 \
	)

##

.PHONY: nti-lha
nti-lha: ${NTI_LHA_INSTALLED}

ALL_NTI_TARGETS+= nti-lha

endif	# HAVE_LHA_CONFIG
