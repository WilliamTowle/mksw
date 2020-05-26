# id3tool v1.2a			[ since v1.2a, c.2009-09-01 ]
# last mod WmT, 2009-09-01	[ (c) and GPLv2 1999-2009 ]

DESCRLIST+= "'nti-id3tool' -- id3tool"

ID3TOOL_VER=1.2a
ID3TOOL_SRC=${SRCDIR}/i/id3tool-${ID3TOOL_VER}.tar.gz

URLS+=http://nekohako.xware.cx/id3tool/id3tool-1.2a.tar.gz


## ,-----
## |	Extract
## +-----

NTI_ID3TOOL_TEMP=nti-id3tool-${ID3TOOL_VER}

NTI_ID3TOOL_EXTRACTED=${EXTTEMP}/${NTI_ID3TOOL_TEMP}/Makefile

.PHONY: nti-id3tool-extracted

nti-id3tool-extracted: ${NTI_ID3TOOL_EXTRACTED}

${NTI_ID3TOOL_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_ID3TOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ID3TOOL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${ID3TOOL_SRC}
	mv ${EXTTEMP}/id3tool-${ID3TOOL_VER} ${EXTTEMP}/${NTI_ID3TOOL_TEMP}


## ,-----
## |	Configure
## +-----

NTI_ID3TOOL_CONFIGURED=${EXTTEMP}/${NTI_ID3TOOL_TEMP}/config.status

.PHONY: nti-id3tool-configured

nti-id3tool-configured: nti-id3tool-extracted ${NTI_ID3TOOL_CONFIGURED}

${NTI_ID3TOOL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ID3TOOL_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${HTC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_ID3TOOL_BUILT=${EXTTEMP}/${NTI_ID3TOOL_TEMP}/id3tool

.PHONY: nti-id3tool-built
nti-id3tool-built: nti-id3tool-configured ${NTI_ID3TOOL_BUILT}

${NTI_ID3TOOL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ID3TOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_ID3TOOL_INSTALLED=${HTC_ROOT}/usr/sbin/id3tool

.PHONY: nti-id3tool-installed

nti-id3tool-installed: nti-id3tool-built ${NTI_ID3TOOL_INSTALLED}

${NTI_ID3TOOL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ID3TOOL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-id3tool
nti-id3tool: nti-id3tool-installed

TARGETS+= nti-id3tool
