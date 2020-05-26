# fMSX v'30'			[ EARLIEST v0.5.0, c.2012-12-25 ]
# last mod WmT, 2017-04-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_FMSX_CONFIG},y)
HAVE_FMSX_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-fmsx' -- fMSX"

#include ${CFG_ROOT}/tools/unzip/v60.mak

ifeq (${FMSX_VERSION},)
#FMSX_VERSION=27
#FMSX_VERSION=30
FMSX_VERSION=351
endif

#FMSX_SRC=${SOURCES}/f/fMSX${FMSX_VERSION}.tar.Z
FMSX_SRC=${SOURCES}/f/fMSX${FMSX_VERSION}.zip

#URLS+= http://www.mavetju.org/download/adopted/fMSX${FMSX_VERSION}.tar.Z
URLS+= http://fms.komkon.org/fMSX/fMSX${FMSX_VERSION}.zip

#ifeq (${FMSX_VERSION},27)
FMSX_PATCHES=${SOURCES}/f/fmsx-sdl-2.7.0.40src.tar.gz
URLS+= http://home.kabelfoon.nl/~vincentd/download/fmsx-sdl-2.7.0.40src.tar.gz
#endif


NTI_FMSX_TEMP=nti-fMSX-${FMSX_VERSION}

NTI_FMSX_EXTRACTED=${EXTTEMP}/${NTI_FMSX_TEMP}/fMSX.c
NTI_FMSX_CONFIGURED=${EXTTEMP}/${NTI_FMSX_TEMP}/Makefile.OLD
NTI_FMSX_BUILT=${EXTTEMP}/${NTI_FMSX_TEMP}/fMSX/Unix/fmsx
NTI_FMSX_INSTALLED=${NTI_TC_ROOT}/usr/bin/fmsx


## ,-----
## |	Extract
## +-----

${NTI_FMSX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/fMSX-${FMSX_VERSION} ] || rm -rf ${EXTTEMP}/fMSX-${FMSX_VERSION}
	#[ ! -d ${EXTTEMP}/MSX ] || rm -rf ${EXTTEMP}/MSX
	#zcat ${FMSX_SRC} | tar xvf - -C ${EXTTEMP}
	unzip ${FMSX_SRC} -d ${EXTTEMP}/fMSX-${FMSX_VERSION}
	[ ! -d ${EXTTEMP}/${NTI_FMSX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FMSX_TEMP}
	mv ${EXTTEMP}/fMSX-${FMSX_VERSION} ${EXTTEMP}/${NTI_FMSX_TEMP}
	#mv ${EXTTEMP}/MSX ${EXTTEMP}/${NTI_FMSX_TEMP}
ifneq (${FMSX_PATCHES},)
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		zcat ${FMSX_PATCHES} | tar xvf - ;\
		for FILE in fMSX/MSX.c fMSX/MSX.h Unix/SndUnix.c EMULib/Sound.h Unix/Unix.c fMSX/fMSX.c ; do \
			patch $${FILE} patch/`basename $${FILE}`.patch || echo "*** PATCHING: IGNORING ERRORS ***\n" ;\
		done ;\
	)
endif


## ,-----
## |	Configure
## +-----

${NTI_FMSX_CONFIGURED}: ${NTI_FMSX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		case ${FMSX_VERSION} in \
		27) \
			[ -r Patch.c.OLD ] || mv Patch.c Patch.c.OLD || exit 1 ;\
			cat Patch.c.OLD \
				| sed '/^static byte RdZ80/		s/RdZ80/_RdZ80/' \
				| sed '/^void PatchZ80(Z80 *R)/,/^}/	s/RdZ80/_RdZ80/' \
				> Patch.c ;\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^DEFINES/,/[^\\]$$/	s/-DZLIB//' \
				> Makefile \
		;; \
		30) \
			[ -r Patch.c.OLD ] || mv Patch.c Patch.c.OLD || exit 1 ;\
			cat Patch.c.OLD \
				| sed '/^static byte RdZ80/		s/RdZ80/_RdZ80/' \
				| sed '/^void PatchZ80(Z80 *R)/,/^}/	s/RdZ80/_RdZ80/' \
				> Patch.c ;\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^DEFINES/,/[^\\]$$/	s/-DZLIB//' \
				> Makefile \
		;; \
		351) \
			[ -r EMULib/Rules.gcc.OLD ] || mv EMULib/Rules.gcc EMULib/Rules.gcc.OLD || exit 1 ;\
			cat EMULib/Rules.gcc.OLD \
				| sed '/^DEFINES/,/[^\\]$$/	s/-DZLIB//' \
				> EMULib/Rules.gcc \
		;; \
		*) \
			echo "CONFIGURE/D: Unexpected FMSX_VERSION ${FMSX_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_FMSX_BUILT}: ${NTI_FMSX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		case ${FMSX_VERSION} in \
		27|30) \
			make || exit 1 \
		;; \
		351) \
			make -C fMSX/Unix || exit 1 \
		;; \
		*) \
			echo "BUILD/T: Unexpected FMSX_VERSION ${FMSX_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Install
## +-----

${NTI_FMSX_INSTALLED}: ${NTI_FMSX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FMSX_TEMP} || exit 1 ;\
		echo '...cp fMSX/Unix/fmsx SOMEWHERE' 1>&2 ;\
		exit 1 \
	)

##

.PHONY: nti-fmsx
#nti-fmsx: nti-unzip \
#	${NTI_FMSX_INSTALLED}
nti-fmsx: ${NTI_FMSX_INSTALLED}

ALL_NTI_TARGETS+= nti-fmsx

endif	# HAVE_FMSX_CONFIG
