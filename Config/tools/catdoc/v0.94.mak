# catdoc v0.94			[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2012-12-24	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_CATDOC_CONFIG},y)
HAVE_CATDOC_CONFIG:=y

#DESCRLIST+= "'nti-catdoc' -- catdoc"

#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${CATDOC_VERSION},)
CATDOC_VERSION=0.94
endif

CATDOC_SRC=${SOURCES}/c/catdoc-${CATDOC_VERSION}.tar.gz
URLS+= http://ftp.wagner.pp.ru/pub/catdoc/catdoc-${CATDOC_VERSION}.tar.gz

NTI_CATDOC_TEMP=nti-catdoc-${CATDOC_VERSION}

NTI_CATDOC_EXTRACTED=${EXTTEMP}/${NTI_CATDOC_TEMP}/README
NTI_CATDOC_CONFIGURED=${EXTTEMP}/${NTI_CATDOC_TEMP}/config.log
NTI_CATDOC_BUILT=${EXTTEMP}/${NTI_CATDOC_TEMP}/src/catdoc
NTI_CATDOC_INSTALLED=${NTI_TC_ROOT}/usr/bin/catdoc


## ,-----
## |	Extract
## +-----

${NTI_CATDOC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/catdoc-${CATDOC_VERSION} ] || rm -rf ${EXTTEMP}/catdoc-${CATDOC_VERSION}
	zcat ${CATDOC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CATDOC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CATDOC_TEMP}
	mv ${EXTTEMP}/catdoc-${CATDOC_VERSION} ${EXTTEMP}/${NTI_CATDOC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CATDOC_CONFIGURED}: ${NTI_CATDOC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CATDOC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_CATDOC_BUILT}: ${NTI_CATDOC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CATDOC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CATDOC_INSTALLED}: ${NTI_CATDOC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CATDOC_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-catdoc
nti-catdoc: ${NTI_CATDOC_INSTALLED}

ALL_NTI_TARGETS+= nti-catdoc

endif	# HAVE_CATDOC_CONFIG
