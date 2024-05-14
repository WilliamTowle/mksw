# nasm v2.16			[ since v0.98.35, c.2002-10-21 ]
# last mod WmT, 2023-10-19	[ (c) and GPLv2 1999-2023 ]

ifneq (${HAVE_NASM_CONFIG},y)
HAVE_NASM_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${NASM_VERSION},)
#NASM_VERSION=2.07
#NASM_VERSION=2.08.01
#NASM_VERSION=2.09.10	# also .09.04
#NASM_VERSION=2.10.03
#NASM_VERSION=2.11.02
#NASM_VERSION=2.11.06
#NASM_VERSION=2.11.08
#NASM_VERSION=2.13rc21
#NASM_VERSION=2.14rc15
NASM_VERSION=2.16
endif

NASM_SRC=${DIR_DOWNLOADS}/n/nasm-${NASM_VERSION}.tar.bz2
NASM_URL=http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.bz2

NTI_NASM_TEMP=${DIR_EXTTEMP}/nti-nasm-${NASM_VERSION}

NTI_NASM_EXTRACTED=${NTI_NASM_TEMP}/configure
NTI_NASM_CONFIGURED=${NTI_NASM_TEMP}/config.status
NTI_NASM_BUILT=${NTI_NASM_TEMP}/nasm
NTI_NASM_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/nasm


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-nasm-uriurl:
	@echo "${NASM_SRC} ${NASM_URL}"

show-all-uriurl:: show-nti-nasm-uriurl


${NTI_NASM_EXTRACTED}: | nti-sanity ${NASM_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_NASM_TEMP} ARCHIVES=${NASM_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_NASM_CONFIGURED}: ${NTI_NASM_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure \
			  --prefix=${DIR_NTI_TOOLCHAIN}/usr \
			  || exit 1 ;\
		case ${NASM_VERSION} in \
		2.09.*|2.10.*) \
			[ -r config.h.OLD ] || mv config.h config.h.OLD || exit 1 ;\
			cat config.h.OLD \
				| sed '/HAVE_STRLCPY/	{ s/.*undef/#define/ ; s/ \*\/// }' \
				> config.h \
		;; \
		2.12|2.13|2.13*rc*|2.14*rc*|2.16)	;; \
		*) \
			echo "Unexpected NASM_VERSION ${NASM_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


${NTI_NASM_BUILT}: ${NTI_NASM_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_NASM_TEMP} && make )


${NTI_NASM_INSTALLED}: ${NTI_NASM_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_NASM_TEMP} && make install )

#

USAGE_TEXT+= "'nti-nasm' - build nasm for NTI toolchain"

.PHONY: nti-nasm
nti-nasm: ${NTI_NASM_INSTALLED}


all-nti-targets:: nti-nasm


endif	## HAVE_NASM_CONFIG
