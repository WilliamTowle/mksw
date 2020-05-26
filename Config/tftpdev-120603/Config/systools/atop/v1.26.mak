# atop 1.26			[ EARLIEST v1.12, c.2004-06-03 ]
# last mod WmT, 2011-04-04	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_ATOP_CONFIG},y)
HAVE_ATOP_CONFIG:=y

DESCRLIST+= "'nti-atop' -- atop"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


ATOP_VER=1.26
ATOP_SRC=${SRCDIR}/a/atop-1.26.tar.gz

URLS+= http://www.atoptool.nl/download/atop-1.26.tar.gz


## ,-----
## |	Extract
## +-----

NTI_ATOP_TEMP=nti-atop-${ATOP_VER}

NTI_ATOP_EXTRACTED=${EXTTEMP}/${NTI_ATOP_TEMP}/Makefile

.PHONY: nti-atop-extracted
nti-atop-extracted: ${NTI_ATOP_EXTRACTED}

${NTI_ATOP_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${NTI_ATOP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ATOP_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${ATOP_SRC}
	mv ${EXTTEMP}/atop-${ATOP_VER} ${EXTTEMP}/${NTI_ATOP_TEMP}


## ,-----
## |	Configure
## +-----

NTI_ATOP_CONFIGURED=${EXTTEMP}/${NTI_ATOP_TEMP}/Makefile.OLD

.PHONY: nti-atop-configured
nti-atop-configured: nti-atop-extracted ${NTI_ATOP_CONFIGURED}

${NTI_ATOP_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_ATOP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/CFLAGS/	s%^%CC='${NUI_CC_PREFIX}'cc\n%' \
			| sed '/^[A-Z]*[0-9]*PATH/ s%/%'${NTI_TC_ROOT}'/%' \
			| sed '/	.*chown/	s/^/#/' \
			> Makefile ;\
		rm -f atop \
	)


## ,-----
## |	Build
## +-----

NTI_ATOP_BUILT=${EXTTEMP}/${NTI_ATOP_TEMP}/atop

.PHONY: nti-atop-built
nti-atop-built: nti-atop-configured ${NTI_ATOP_BUILT}

${NTI_ATOP_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_ATOP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_ATOP_INSTALLED=${NTI_TC_ROOT}/usr/bin/atop

.PHONY: nti-atop-installed
nti-atop-installed: nti-atop-built ${NTI_ATOP_INSTALLED}

# 2011-04-04: Supplying DESTDIR=/ prevents `/sbin/chkconfig --add ...`
${NTI_ATOP_INSTALLED}: ${NTI_ATOP_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${NTI_ATOP_TEMP} || exit 1 ;\
		make install DESTDIR='/' || exit 1 \
	)

.PHONY: nti-atop
nti-atop: nti-atop-installed

NTARGETS+= nti-atop

endif	# HAVE_ATOP_CONFIG
