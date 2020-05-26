# nasm v2.13rc21		[ since v0.98.35, c.2002-10-21 ]
# last mod WmT, 2017-04-21	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_NASM_CONFIG},y)
HAVE_NASM_CONFIG:=y

#DESCRLIST+= "'nti-nasm' -- nasm"

ifeq (${NASM_VERSION},)
#NASM_VERSION=2.09.04
#NASM_VERSION=2.09.10
#NASM_VERSION=2.10.03
NASM_VERSION=2.13rc21
endif
NASM_SRC=${SOURCES}/n/nasm-${NASM_VERSION}.tar.bz2

NTI_NASM_TEMP=nti-nasm-${NASM_VERSION}
NTI_NASM_EXTRACTED=${EXTTEMP}/${NTI_NASM_TEMP}/configure
NTI_NASM_CONFIGURED=${EXTTEMP}/${NTI_NASM_TEMP}/config.status
NTI_NASM_BUILT=${EXTTEMP}/${NTI_NASM_TEMP}/nasm
NTI_NASM_INSTALLED=${NTI_TC_ROOT}/usr/bin/nasm

URLS+=http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.bz2


# ,-----
# |	Extract
# +-----

${NTI_NASM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_NASM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NASM_TEMP}
	bzcat ${NASM_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/nasm-${NASM_VERSION} ${EXTTEMP}/${NTI_NASM_TEMP}


# ,-----
# |	Configure
# +-----


${NTI_NASM_CONFIGURED}: ${NTI_NASM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		CC=/usr/bin/gcc \
		  CFLAGS='-O2' \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
		case ${NASM_VERSION} in \
		2.09.*|2.10.*) \
			[ -r config.h.OLD ] || mv config.h config.h.OLD || exit 1 ;\
			cat config.h.OLD \
				| sed '/HAVE_STRLCPY/	{ s/.*undef/#define/ ; s/ \*\/// }' \
				> config.h \
		;; \
		2.12|2.13*)	;; \
		*) \
			echo "Unexpected NASM_VERSION ${NASM_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


# ,-----
# |	Build
# +-----

${NTI_NASM_BUILT}: ${NTI_NASM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_NASM_INSTALLED}: ${NTI_NASM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_NASM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-nasm
nti-nasm: ${NTI_NASM_INSTALLED}

ALL_NTI_TARGETS+= nti-nasm
#NTARGETS+= nti-native-gcc nti-nasm

endif	# HAVE_NASM_CONFIG
