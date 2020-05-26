# ascii 3.10			[ EARLIEST v3.6, c.2004-01-13 ]
# last mod WmT, 2010-10-14	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_ASCII_CONFIG},y)
HAVE_ASCII_CONFIG:=y

DESCRLIST+= "'nti-ascii' -- ascii"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


#ASCII_VER=3.9
ASCII_VER=3.10
ASCII_SRC=${SRCDIR}/a/ascii-${ASCII_VER}.tar.gz

URLS+= http://www.catb.org/~esr/ascii/ascii-${ASCII_VER}.tar.gz


## ,-----
## |	Extract
## +-----

NTI_ASCII_TEMP=nti-ascii-${ASCII_VER}

NTI_ASCII_EXTRACTED=${EXTTEMP}/${NTI_ASCII_TEMP}/configure

.PHONY: nti-ascii-extracted
nti-ascii-extracted: ${NTI_ASCII_EXTRACTED}

${NTI_ASCII_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${NTI_ASCII_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ASCII_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${ASCII_SRC}
	mv ${EXTTEMP}/ascii-${ASCII_VER} ${EXTTEMP}/${NTI_ASCII_TEMP}


## ,-----
## |	Configure
## +-----

NTI_ASCII_CONFIGURED=${EXTTEMP}/${NTI_ASCII_TEMP}/Makefile.OLD

.PHONY: nti-ascii-configured
nti-ascii-configured: nti-ascii-extracted ${NTI_ASCII_CONFIGURED}

${NTI_ASCII_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_ASCII_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS[ 	]*/ s%^%CC='${NUI_CC_PREFIX}'cc\n%' \
			| sed '/^	/	s%$$(DESTDIR)%$$(DESTDIR)/'${NTI_TC_ROOT}'%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_ASCII_BUILT=${EXTTEMP}/${NTI_ASCII_TEMP}/ascii

.PHONY: nti-ascii-built
nti-ascii-built: nti-ascii-configured ${NTI_ASCII_BUILT}

${NTI_ASCII_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_ASCII_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_ASCII_INSTALLED=${NTI_TC_ROOT}/usr/bin/ascii

.PHONY: nti-ascii-installed
nti-ascii-installed: nti-ascii-built ${NTI_ASCII_INSTALLED}

${NTI_ASCII_INSTALLED}: ${NTI_ASCII_BUILT}
	echo "*** $@ (INSTALL) ***"
	for SUBDIR in usr/bin usr/share/man/man1 ; do \
		mkdir -p ${NTI_TC_ROOT}/$${SUBDIR}/ || exit 1 ;\
	done
	( cd ${EXTTEMP}/${NTI_ASCII_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: nti-ascii
nti-ascii: nti-ascii-installed

NTARGETS+= nti-ascii

endif	# HAVE_ASCII_CONFIG
