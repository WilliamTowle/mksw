# iucode-tool v0.8.3		[ since v0.8.3, c.2015-06-10 ]
# last mod WmT, 2015-06-10	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_IUCODE_TOOL_CONFIG},y)
HAVE_IUCODE_TOOL_CONFIG:=y

#DESCRLIST+= "'nti-iucode-tool' -- iucode-tool"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${IUCODE_TOOL_VERSION},)
IUCODE_TOOL_VERSION=0.8.3
endif
IUCODE_TOOL_SRC=${SOURCES}/i/iucode-tool_${IUCODE_TOOL_VERSION}.orig.tar.bz2

URLS+= http://http.debian.net/debian/pool/contrib/i/iucode-tool/iucode-tool_0.8.3.orig.tar.bz2

##include ${CFG_ROOT}/buildtools/yasm/v1.2.0.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.11.08.mak
#include ${CFG_ROOT}/audvid/lame/v3.99.5.mak

NTI_IUCODE_TOOL_TEMP=nti-iucode-tool-${IUCODE_TOOL_VERSION}

NTI_IUCODE_TOOL_EXTRACTED=${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}/configure
NTI_IUCODE_TOOL_CONFIGURED=${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}/config.log
NTI_IUCODE_TOOL_BUILT=${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}/iucode_tool
NTI_IUCODE_TOOL_INSTALLED=${NTI_TC_ROOT}/usr/sbin/iucode_tool


## ,-----
## |	Extract
## +-----

${NTI_IUCODE_TOOL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/iucode-tool-${IUCODE_TOOL_VERSION} ] || rm -rf ${EXTTEMP}/iucode-tool-${IUCODE_TOOL_VERSION}
	[ ! -d ${EXTTEMP}/iucode_tool-${IUCODE_TOOL_VERSION} ] || rm -rf ${EXTTEMP}/iucode-tool-${IUCODE_TOOL_VERSION}
	bzcat ${IUCODE_TOOL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}
	#mv ${EXTTEMP}/iucode-tool-${IUCODE_TOOL_VERSION} ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}
	mv ${EXTTEMP}/iucode_tool-${IUCODE_TOOL_VERSION} ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_IUCODE_TOOL_CONFIGURED}: ${NTI_IUCODE_TOOL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP} || exit 1 ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_IUCODE_TOOL_BUILT}: ${NTI_IUCODE_TOOL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_IUCODE_TOOL_INSTALLED}: ${NTI_IUCODE_TOOL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_IUCODE_TOOL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-iucode-tool
nti-iucode-tool: ${NTI_IUCODE_TOOL_INSTALLED}

ALL_NTI_TARGETS+= nti-iucode-tool

endif	# HAVE_IUCODE_TOOL_CONFIG
