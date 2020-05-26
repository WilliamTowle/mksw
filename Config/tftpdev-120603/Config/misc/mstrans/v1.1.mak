# mstrans v1.1			[ since v1.1, c.2010-11-30 ]
# last mod WmT, 2010-11-30	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MSTRANS_CONFIG},y)
HAVE_MSTRANS_CONFIG:=y

DESCRLIST+= "'nti-mstrans' -- mstrans"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif


MSTRANS_VER=1.1
MSTRANS_SRC=${SRCDIR}/m/mstrans-1.1.tar.gz

URLS+= http://www.catb.org/~esr/mstrans/mstrans-1.1.tar.gz


## ,-----
## |	Extract
## +-----

NTI_MSTRANS_TEMP=nti-mstrans-${MSTRANS_VER}

NTI_MSTRANS_EXTRACTED=${EXTTEMP}/${NTI_MSTRANS_TEMP}/Makefile

.PHONY: nti-mstrans-extracted

nti-mstrans-extracted: ${NTI_MSTRANS_EXTRACTED}

${NTI_MSTRANS_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MSTRANS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MSTRANS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MSTRANS_SRC}
	mv ${EXTTEMP}/mstrans-${MSTRANS_VER} ${EXTTEMP}/${NTI_MSTRANS_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MSTRANS_CONFIGURED=${EXTTEMP}/${NTI_MSTRANS_TEMP}/Makefile.OLD

.PHONY: nti-mstrans-configured

nti-mstrans-configured: nti-mstrans-extracted ${NTI_MSTRANS_CONFIGURED}

${NTI_MSTRANS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MSTRANS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS/	s%^%CC='${NUI_CC_PREFIX}'cc\n%' \
			| sed '/^	/	s% /usr% '${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

NTI_MSTRANS_BUILT=${EXTTEMP}/${NTI_MSTRANS_TEMP}/faked

.PHONY: nti-mstrans-built
nti-mstrans-built: nti-mstrans-configured ${NTI_MSTRANS_BUILT}

${NTI_MSTRANS_BUILT}:
	echo "*** $@ (BUILT) ***"
	mkdir -p ${NTI_TC_ROOT}/usr/bin
	mkdir -p ${NTI_TC_ROOT}/usr/share/man/man1
	( cd ${EXTTEMP}/${NTI_MSTRANS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_MSTRANS_INSTALLED=${NTI_TC_ROOT}/usr/bin/faked

.PHONY: nti-mstrans-installed

nti-mstrans-installed: nti-mstrans-built ${NTI_MSTRANS_INSTALLED}

${NTI_MSTRANS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MSTRANS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mstrans
nti-mstrans: nti-mstrans-installed

NTARGETS+= nti-mstrans

endif	# HAVE_MSTRANS_CONFIG
