# linetd v1.4			[ since v1.4, c.2009-07-27 ]
# last mod WmT, 2011-05-24	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LINETD_CONFIG},y)
HAVE_LINETD_CONFIG:=y

DESCRLIST+= "'nti-linetd' -- linetd"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

LINETD_VER=1.4
LINETD_SRC=${SRCDIR}/l/linetd-1.4.tar.gz

URLS+=http://welz.org.za/projects/linetd/linetd-1.4.tar.gz


## ,-----
## |	Extract
## +-----

NTI_LINETD_TEMP=nti-linetd-${LINETD_VER}

NTI_LINETD_EXTRACTED=${EXTTEMP}/${NTI_LINETD_TEMP}/Makefile

.PHONY: nti-linetd-extracted
nti-linetd-extracted: ${NTI_LINETD_EXTRACTED}

${NTI_LINETD_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LINETD_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINETD_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LINETD_SRC}
	mv ${EXTTEMP}/linetd-${LINETD_VER} ${EXTTEMP}/${NTI_LINETD_TEMP}


## ,-----
## |	Configure
## +-----

NTI_LINETD_CONFIGURED=${EXTTEMP}/${NTI_LINETD_TEMP}/Makefile.OLD

.PHONY: nti-linetd-configured
nti-linetd-configured: nti-linetd-extracted ${NTI_LINETD_CONFIGURED}

${NTI_LINETD_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_LINETD_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^	/	s%gcc%'${NTI_GCC}'%' \
			| sed 's%/usr/local/%$${DESTDIR}/$${INSTROOT}/usr/%' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_LINETD_BUILT=${EXTTEMP}/${NTI_LINETD_TEMP}/linetd

.PHONY: nti-linetd-built
nti-linetd-built: nti-linetd-configured ${NTI_LINETD_BUILT}

${NTI_LINETD_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_LINETD_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_LINETD_INSTALLED=${NTI_TC_ROOT}/usr/sbin/linetd

.PHONY: nti-linetd-installed
nti-linetd-installed: nti-linetd-built ${NTI_LINETD_INSTALLED}

${NTI_LINETD_INSTALLED}:
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${NTI_LINETD_TEMP} || exit 1 ;\
		make install DESTDIR='' INSTROOT=${NTI_TC_ROOT} \
	)

.PHONY: nti-linetd
nti-linetd: nti-linetd-installed

NTARGETS+= nti-linetd

endif #HAVE_LINETD_CONFIG
