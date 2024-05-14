# ms-sys build rules		[ since v2.0.0, c.2004-06-07 ]
# last mod WmT, 2023-10-20	[ (c) and GPLv2 1999-2023 ]

ifneq (${HAVE_MS_SYS_CONFIG},y)
HAVE_MS_SYS_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${MS_SYS_VERSION},)
#MS_SYS_VERSION=2.1.4
#MS_SYS_VERSION=2.1.5
#MS_SYS_VERSION=2.2.0
MS_SYS_VERSION=2.8.0
endif

MS_SYS_SRC=${DIR_DOWNLOADS}/m/ms-sys-${MS_SYS_VERSION}.tar.gz
#MS_SYS_URL=http://downloads.sourceforge.net/project/ms-sys/ms-sys%20development/${MS_SYS_VERSION}/ms-sys-${MS_SYS_VERSION}.tar.gz?use_mirror=heanet
MS_SYS_URL=https://sourceforge.net/projects/ms-sys/files/ms-sys%20stable/${MS_SYS_VERSION}/ms-sys-${MS_SYS_VERSION}.tar.gz/download?use_mirror=altushost-swe&download=&failedmirror=deac-riga.dl.sourceforge.net


NTI_MS_SYS_TEMP=${DIR_EXTTEMP}/nti-ms-sys-${MS_SYS_VERSION}

NTI_MS_SYS_EXTRACTED=${NTI_MS_SYS_TEMP}/README
NTI_MS_SYS_CONFIGURED=${NTI_MS_SYS_TEMP}/.mksw-configured
NTI_MS_SYS_BUILT=${NTI_MS_SYS_TEMP}/build/bin/ms-sys
NTI_MS_SYS_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/ms-sys


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-ms-sys-uriurl:
	@echo "${MS_SYS_SRC} ${MS_SYS_URL}"

show-all-uriurl:: show-nti-ms-sys-uriurl


${NTI_MS_SYS_EXTRACTED}: | nti-sanity ${NTI_MS_SYS_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_MS_SYS_TEMP} ARCHIVES=${MS_SYS_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_MS_SYS_CONFIGURED}: ${NTI_MS_SYS_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_MS_SYS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/ { s/?// ; s%g*cc$$%'${NUI_HOST_GCC}'% }' \
			| sed '/^EXTRA_/ s/^/#/' \
			| sed '/^PREFIX/ s%/usr/local%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^	/	s%msgfmt %touch $$@ ; echo '**SKIP**' msgfmt %' \
			> Makefile || exit 1 \
		)
	touch ${NTI_MS_SYS_CONFIGURED}


${NTI_MS_SYS_BUILT}: ${NTI_MS_SYS_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_MS_SYS_TEMP} && make )


${NTI_MS_SYS_INSTALLED}: ${NTI_MS_SYS_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_MS_SYS_TEMP} && make install )

#

USAGE_TEXT+= "'nti-ms-sys' - build ms-sys for NTI toolchain"

.PHONY: nti-ms-sys
nti-ms-sys: ${NTI_MS_SYS_INSTALLED}


all-nti-targets:: nti-ms-sys


endif	## HAVE_MS_SYS_CONFIG
