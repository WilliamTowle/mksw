# ms-sys v2.2.0			[ since v2.0.0, c.2004-06-07 ]
# last mod WmT, 2010-06-09	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MSSYS_CONFIG},y)
HAVE_MSSYS_CONFIG:=y

DESCRLIST+= "'nti-ms-sys' -- host-toolchain ms-sys"

#MSSYS_VER=2.1.4
#MSSYS_VER=2.1.5
MSSYS_VER=2.2.0
MSSYS_SRC=${SRCDIR}/m/ms-sys-${MSSYS_VER}.tar.gz

URLS+=http://downloads.sourceforge.net/project/ms-sys/ms-sys%20development/${MSSYS_VER}/ms-sys-${MSSYS_VER}.tar.gz?use_mirror=heanet

## ,-----
## |	package extract
## +-----

NTI_MSSYS_TEMP=nti-ms-sys-${MSSYS_VER}

NTI_MSSYS_EXTRACTED=${EXTTEMP}/${NTI_MSSYS_TEMP}/Makefile

.PHONY: nti-ms-sys-extracted
nti-ms-sys-extracted: ${NTI_MSSYS_EXTRACTED}

${NTI_MSSYS_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVES=${MSSYS_SRC}
	mv ${EXTTEMP}/ms-sys-${MSSYS_VER} ${EXTTEMP}/${NTI_MSSYS_TEMP}

## ,-----
## |	package configure
## +-----

NTI_MSSYS_CONFIGURED=${EXTTEMP}/${NTI_MSSYS_TEMP}/Makefile.OLD

.PHONY: nti-ms-sys-configured
nti-ms-sys-configured: nti-ms-sys-extracted ${NTI_MSSYS_CONFIGURED}

${NTI_MSSYS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MSSYS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/ s/?//' \
			| sed '/^EXTRA_/ s/^/#/' \
			| sed '/^PREFIX/ s%/usr/local%'${HTC_ROOT}'/usr%' \
			> Makefile || exit 1 \
	)

## ,-----
## |	package build
## +-----

NTI_MSSYS_BUILT=${EXTTEMP}/${NTI_MSSYS_TEMP}/src/cmp

.PHONY: nti-ms-sys-built
nti-ms-sys-built: nti-ms-sys-configured ${NTI_MSSYS_BUILT}

# NB. pre-2.1.4, may need LDFLAGS to contain "-lintl" (gettext)
${NTI_MSSYS_BUILT}: ${NTI_MSSYS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MSSYS_TEMP} || exit 1 ;\
		make \
	)

## ,-----
## |	package install
## +-----

NTI_MSSYS_INSTALLED=${HTC_ROOT}/usr/bin/cmp

.PHONY: nti-ms-sys-installed
nti-ms-sys-installed: nti-ms-sys-built ${NTI_MSSYS_INSTALLED}

${NTI_MSSYS_INSTALLED}: ${HTC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MSSYS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-ms-sys
nti-ms-sys: nti-ms-sys-installed

TARGETS+=nti-ms-sys

endif	# HAVE_MSSYS_CONFIG
