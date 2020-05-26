# binutils v2.22		[ EARLIEST v?.??, c.????-??-?? ]
# last mod WmT, 2012-10-23	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_BINUTILS_CONFIG},y)
HAVE_BINUTILS_CONFIG:=y

#DESCRLIST+= "'nti-binutils' -- binutils"

# TODO: should reference 'ENV/buildtype.mak'
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${BINUTILS_VERSION},)
BINUTILS_VERSION=2.22
endif
BINUTILS_SRC=${SOURCES}/b/binutils-${BINUTILS_VERSION}.tar.bz2

URLS+= http://mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2

NTI_BINUTILS_TEMP=nti-binutils-${BINUTILS_VERSION}

NTI_BINUTILS_EXTRACTED=${EXTTEMP}/${NTI_BINUTILS_TEMP}/README
NTI_BINUTILS_CONFIGURED=${EXTTEMP}/${NTI_BINUTILS_TEMP}/config.status
NTI_BINUTILS_BUILT=${EXTTEMP}/${NTI_BINUTILS_TEMP}/binutils/ar
NTI_BINUTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/ar

## ,-----
## |	Extract
## +-----

${NTI_BINUTILS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/binutils-${BINUTILS_VERSION} ] || rm -rf ${EXTTEMP}/binutils-${BINUTILS_VERSION}
	bzcat ${BINUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BINUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BINUTILS_TEMP}
	mv ${EXTTEMP}/binutils-${BINUTILS_VERSION} ${EXTTEMP}/${NTI_BINUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BINUTILS_CONFIGURED}: ${NTI_BINUTILS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BINUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BINUTILS_BUILT}: ${NTI_BINUTILS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BINUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BINUTILS_INSTALLED}: ${NTI_BINUTILS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BINUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-binutils
nti-binutils: ${NTI_BINUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-binutils

endif	# HAVE_BINUTILS_CONFIG
