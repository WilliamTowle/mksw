# make v3.81			[ EARLIEST v3.81, c. 2005-11-29 ]
# last mod WmT, 2011-10-05	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MAKE_CONFIG},y)
HAVE_MAKE_CONFIG:=y

DESCRLIST+= "'nti-make' -- make"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


MAKE_VER=3.81
MAKE_SRC=${SRCDIR}/m/make-3.81.tar.bz2

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/make/make-3.81.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_MAKE_TEMP=nti-make-${MAKE_VER}

NTI_MAKE_EXTRACTED=${EXTTEMP}/${NTI_MAKE_TEMP}/Makefile

.PHONY: nti-make-extracted
nti-make-extracted: ${NTI_MAKE_EXTRACTED}

${NTI_MAKE_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MAKE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MAKE_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MAKE_SRC}
	mv ${EXTTEMP}/make-${MAKE_VER} ${EXTTEMP}/${NTI_MAKE_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MAKE_CONFIGURED=${EXTTEMP}/${NTI_MAKE_TEMP}/config.status

.PHONY: nti-make-configured
nti-make-configured: nti-make-extracted ${NTI_MAKE_CONFIGURED}

${NTI_MAKE_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_MAKE_BUILT=${EXTTEMP}/${NTI_MAKE_TEMP}/make

.PHONY: nti-make-built
nti-make-built: nti-make-configured ${NTI_MAKE_BUILT}

${NTI_MAKE_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_MAKE_INSTALLED=${NTI_TC_ROOT}/usr/bin/make

.PHONY: nti-make-installed
nti-make-installed: nti-make-built ${NTI_MAKE_INSTALLED}

${NTI_MAKE_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MAKE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-make
nti-make: nti-make-installed

NTARGETS+= nti-make

endif	# HAVE_MAKE_CONFIG
