# mp3cut v0.8			[ since v0.8, 2010-01-21 ]
# last mod WmT, 2010-01-21	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MP3CUT_CONFIG},y)
HAVE_MP3CUT_CONFIG:=y

DESCRLIST+= "'nti-mp3cut' -- mp3cut"

MP3CUT_VER=0.8
MP3CUT_SRC=${SRCDIR}/m/mp3cut-0.8.tgz

URLS+= http://scara.com/mp3cut/mp3cut-0.8.tgz

##	package extract

NTI_MP3CUT_TEMP=nti-mp3cut-${MP3CUT_VER}

NTI_MP3CUT_EXTRACTED=${EXTTEMP}/${NTI_MP3CUT_TEMP}/Makefile

.PHONY: nti-mp3cut-extracted

nti-mp3cut-extracted: ${NTI_MP3CUT_EXTRACTED}

${NTI_MP3CUT_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_MP3CUT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MP3CUT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MP3CUT_SRC}
	mv ${EXTTEMP}/mp3cut-0.8 ${EXTTEMP}/${NTI_MP3CUT_TEMP}

##	package configure

NTI_MP3CUT_CONFIGURED=${EXTTEMP}/${NTI_MP3CUT_TEMP}/Makefile.OLD

.PHONY: nti-mp3cut-configured

nti-mp3cut-configured: nti-mp3cut-extracted ${NTI_MP3CUT_CONFIGURED}

${NTI_MP3CUT_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MP3CUT_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		( echo "RM=/bin/rm" ; cat Makefile.OLD \
		) > Makefile || exit 1 \
	)

##	package build

NTI_MP3CUT_BUILT=${EXTTEMP}/${NTI_MP3CUT_TEMP}/mp3cut

.PHONY: nti-mp3cut-built
nti-mp3cut-built: nti-mp3cut-configured ${NTI_MP3CUT_BUILT}

${NTI_MP3CUT_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MP3CUT_TEMP} || exit 1 ;\
		make \
	)

##	package install

NTI_MP3CUT_INSTALLED=${HTC_ROOT}/usr/bin/mp3cut

.PHONY: nti-mp3cut-installed

nti-mp3cut-installed: nti-mp3cut-built ${NTI_MP3CUT_INSTALLED}

${NTI_MP3CUT_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${HTC_ROOT}/usr/bin
	( cd ${EXTTEMP}/${NTI_MP3CUT_TEMP} || exit 1 ;\
		cp mp3cut ${HTC_ROOT}/usr/bin/ \
	)

.PHONY: nti-mp3cut
nti-mp3cut: nti-mp3cut-installed

TARGETS+=nti-mp3cut

endif	# HAVE_MP3CUT_CONFIG
