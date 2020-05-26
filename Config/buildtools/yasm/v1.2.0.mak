# yasm v1.2.0			[ since v1.2.0, c.2003-03-10 ]
# last mod WmT, 2013-03-10	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_YASM_CONFIG},y)
HAVE_YASM_CONFIG:=y

#DESCRLIST+= "'nti-yasm' -- yasm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${YASM_VERSION},)
YASM_VERSION=1.2.0
endif
YASM_SRC=${SOURCES}/y/yasm-${YASM_VERSION}.tar.gz

URLS+= http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz

NTI_YASM_TEMP=nti-yasm-${YASM_VERSION}
NTI_YASM_EXTRACTED=${EXTTEMP}/${NTI_YASM_TEMP}/configure
NTI_YASM_CONFIGURED=${EXTTEMP}/${NTI_YASM_TEMP}/config.status
NTI_YASM_BUILT=${EXTTEMP}/${NTI_YASM_TEMP}/yasm
NTI_YASM_INSTALLED=${NTI_TC_ROOT}/usr/bin/yasm


# ,-----
# |	Extract
# +-----

${NTI_YASM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_YASM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_YASM_TEMP}
	zcat ${YASM_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/yasm-${YASM_VERSION} ${EXTTEMP}/${NTI_YASM_TEMP}


# ,-----
# |	Configure
# +-----


${NTI_YASM_CONFIGURED}: ${NTI_YASM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_YASM_TEMP} || exit 1 ;\
	  CC=/usr/bin/gcc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 ;\
		[ -r config.h.OLD ] || mv config.h config.h.OLD || exit 1 ;\
		cat config.h.OLD \
			| sed '/HAVE_STRLCPY/	{ s/.*undef/#define/ ; s/ \*\/// }' \
			> config.h \
	)


# ,-----
# |	Build
# +-----

${NTI_YASM_BUILT}: ${NTI_YASM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_YASM_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

${NTI_YASM_INSTALLED}: ${NTI_YASM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_YASM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-yasm
nti-yasm: ${NTI_YASM_INSTALLED}

ALL_NTI_TARGETS+= nti-yasm
#NTARGETS+= nti-native-gcc nti-yasm

endif	# HAVE_YASM_CONFIG
