# gdbm v1.8.3			[ since v1.8.3 c.2010-06-29 ]
# last mod WmT, 2010-06-29	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_GDBM_CONFIG},y)
HAVE_GDBM_CONFIG:=y

DESCRLIST+= "'nti-gdbm' -- gdbm"

include ${CFG_ROOT}/ENV/native.mak

include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak

GDBM_VER=1.8.3
GDBM_SRC=${SRCDIR}/g/gdbm-1.8.3.tar.gz

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gdbm/gdbm-1.8.3.tar.gz


##	package extract

NTI_GDBM_TEMP=nti-gdbm-${GDBM_VER}

NTI_GDBM_EXTRACTED=${EXTTEMP}/${NTI_GDBM_TEMP}/configure

.PHONY: nti-gdbm-extracted

nti-gdbm-extracted: ${NTI_GDBM_EXTRACTED}
${NTI_GDBM_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_GDBM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GDBM_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${GDBM_SRC}
	mv ${EXTTEMP}/gdbm-${GDBM_VER} ${EXTTEMP}/${NTI_GDBM_TEMP}

##	package configure

NTI_GDBM_CONFIGURED=${EXTTEMP}/${NTI_GDBM_TEMP}/config.status

.PHONY: nti-gdbm-configured

nti-gdbm-configured: nti-gdbm-extracted ${NTI_GDBM_CONFIGURED}

${NTI_GDBM_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GDBM_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed	'/^	/	s/ -o $$(BINOWN)//' \
			| sed	'/^	/	s/ -g $$(BINGRP)//' \
			> Makefile.in || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure \
			  --prefix=${HTC_ROOT}/usr/ \
			  || exit 1 \
	)


##	package build

NTI_GDBM_BUILT=${EXTTEMP}/${NTI_GDBM_TEMP}/.libs/libgdbm_compat.a

.PHONY: nti-gdbm-built
nti-gdbm-built: nti-gdbm-configured ${NTI_GDBM_BUILT}

${NTI_GDBM_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GDBM_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_GDBM_INSTALLED=${HTC_ROOT}/usr/lib/libgdbm.a

.PHONY: nti-gdbm-installed

nti-gdbm-installed: nti-gdbm-built ${NTI_GDBM_INSTALLED}

${NTI_GDBM_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GDBM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-gdbm
nti-gdbm: nti-native-gcc nti-gdbm-installed

TARGETS+= nti-gdbm

endif	# HAVE_GDBM_CONFIG
