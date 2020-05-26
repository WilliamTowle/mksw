# bouncing vUNKNOWN		[ since vUNKNOWN, 2010-12-07 ]
# last mod WmT, 2010-12-07	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_BOUNCING_CONFIG},y)
HAVE_BOUNCING_CONFIG:=y

DESCRLIST+= "'nti-bouncing' -- bouncing"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
endif

ifeq (${ACTION},buildn)
include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#include ${CFG_ROOT}/gui/SDL_mixer/v1.2.11.mak
endif

BOUNCING_VER=UNKNOWN
BOUNCING_SRC=${SRCDIR}/s/SDL_bouncing.zip

URLS+= http://gpwiki.org/images/2/2c/SDL_bouncing.zip


## ,-----
## |	Extract
## +-----

NTI_BOUNCING_TEMP=nti-bouncing-${BOUNCING_VER}

NTI_BOUNCING_EXTRACTED=${EXTTEMP}/${NTI_BOUNCING_TEMP}/configure

.PHONY: nti-bouncing-extracted

nti-bouncing-extracted: ${NTI_BOUNCING_EXTRACTED}
${NTI_BOUNCING_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_BOUNCING_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BOUNCING_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${BOUNCING_SRC}
	mv ${EXTTEMP}/bouncing ${EXTTEMP}/${NTI_BOUNCING_TEMP}


## ,-----
## |	Configure
## +-----

NTI_BOUNCING_CONFIGURED=${EXTTEMP}/${NTI_BOUNCING_TEMP}/config.status

.PHONY: nti-bouncing-configured

nti-bouncing-configured: nti-bouncing-extracted ${NTI_BOUNCING_CONFIGURED}

${NTI_BOUNCING_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BOUNCING_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[ 	?]*=/	s%g*cc%'${NTI_GCC}'%' \
			| sed '/^C/		s%`sdl-config %`'${NTI_TC_ROOT}'/usr/bin/sdl-config %' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_BOUNCING_BUILT=${EXTTEMP}/${NTI_BOUNCING_TEMP}/bouncing

.PHONY: nti-bouncing-built
nti-bouncing-built: nti-bouncing-configured ${NTI_BOUNCING_BUILT}

${NTI_BOUNCING_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BOUNCING_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_BOUNCING_INSTALLED=${NTI_TC_ROOT}/usr/bin/bouncing

.PHONY: nti-bouncing-installed

nti-bouncing-installed: nti-bouncing-built ${NTI_BOUNCING_INSTALLED}

${NTI_BOUNCING_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${NTI_TC_ROOT}/usr/bin
	( cd ${EXTTEMP}/${NTI_BOUNCING_TEMP} || exit 1 ;\
		cp bouncing ${NTI_TC_ROOT}/usr/bin/ || exit 1 \
	)

.PHONY: nti-bouncing
nti-bouncing: nti-SDL nti-bouncing-installed

NTARGETS+= nti-bouncing

endif	# HAVE_BOUNCING_CONFIG
