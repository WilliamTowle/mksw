# xbomb v2.2			[ since v2.2	2010-12-07 ]
# last mod WmT, 2010-12-07	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_XBOMB_CONFIG},y)
HAVE_XBOMB_CONFIG:=y

DESCRLIST+= "'nti-xbomb' -- xbomb"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

XBOMB_VER=2.2
XBOMB_SRC=${SRCDIR}/x/xbomb-2.2.tgz

URLS+= http://www.gedanken.demon.co.uk/download-xbomb/xbomb-2.2.tgz


## ,-----
## |	Extract
## +-----

NTI_XBOMB_TEMP=nti-xbomb-${XBOMB_VER}

NTI_XBOMB_EXTRACTED=${EXTTEMP}/${NTI_XBOMB_TEMP}/Makefile

.PHONY: nti-xbomb-extracted

nti-xbomb-extracted: ${NTI_XBOMB_EXTRACTED}
${NTI_XBOMB_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_XBOMB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XBOMB_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${XBOMB_SRC}
	mv ${EXTTEMP}/xbomb-${XBOMB_VER} ${EXTTEMP}/${NTI_XBOMB_TEMP}


## ,-----
## |	Configure
## +-----

NTI_XBOMB_CONFIGURED=${EXTTEMP}/${NTI_XBOMB_TEMP}/Makefile.OLD

.PHONY: nti-xbomb-configured

nti-xbomb-configured: nti-xbomb-extracted ${NTI_XBOMB_CONFIGURED}

${NTI_XBOMB_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_XBOMB_TEMP} || exit 1 ;\
#	  CFLAGS='-O2' \
#	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
#		./configure \
#			--prefix=${NTI_TC_ROOT}/usr/ \
#			|| exit 1 \
#	)
	( cd ${EXTTEMP}/${NTI_XBOMB_TEMP} || exit 1 ;\
		[ -r hiscore.c.OLD ] || mv hiscore.c hiscore.c.OLD || exit 1 ;\
		cat hiscore.c.OLD \
			| sed '/filenames[[]/	s%/var%'${NTI_TC_ROOT}'/var%g' \
			> hiscore.c || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc%'${NUI_CC_PREFIX}'cc%' \
			| sed '/^INSTDIR=/	s%/usr/local%'${NTI_TC_ROOT}'/usr/%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_XBOMB_BUILT=${EXTTEMP}/${NTI_XBOMB_TEMP}/xbomb

.PHONY: nti-xbomb-built
nti-xbomb-built: nti-xbomb-configured ${NTI_XBOMB_BUILT}

${NTI_XBOMB_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XBOMB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_XBOMB_INSTALLED=${NTI_TC_ROOT}/usr/bin/xbomb

.PHONY: nti-xbomb-installed

nti-xbomb-installed: nti-xbomb-built ${NTI_XBOMB_INSTALLED}

${NTI_XBOMB_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${NTI_TC_ROOT}/var/tmp
	( cd ${EXTTEMP}/${NTI_XBOMB_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xbomb
#nti-xbomb: nti-pkg-config nti-libX11 nti-libXaw nti-libXrender nti-xbomb-installed
nti-xbomb: nti-xbomb-installed

NTARGETS+= nti-xbomb

endif	# HAVE_XBOMB_CONFIG
