# memtest86 v3.5		[ since v3.0, c.2003-07-05 ]
# last mod WmT, 2011-01-13	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_MEMTEST86_CONFIG},y)
HAVE_MEMTEST86_CONFIG:=y

DESCRLIST+= "'nti-memtest86' -- memtest86"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak

MEMTEST86_VER=3.5
MEMTEST86_SRC=${SRCDIR}/m/memtest86-${MEMTEST86_VER}.tar.gz

URLS+=http://www.memtest86.com/memtest86-3.5.tar.gz

## ,-----
## |	Extract
## +-----

NTI_MEMTEST86_TEMP=nti-memtest86-${MEMTEST86_VER}

NTI_MEMTEST86_EXTRACTED=${EXTTEMP}/${NTI_MEMTEST86_TEMP}/Makefile

.PHONY: nti-memtest86-extracted
nti-memtest86-extracted: ${NTI_MEMTEST86_EXTRACTED}

${NTI_MEMTEST86_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${NTI_MEMTEST86_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MEMTEST86_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${MEMTEST86_SRC}
	mv ${EXTTEMP}/memtest86-${MEMTEST86_VER} ${EXTTEMP}/${NTI_MEMTEST86_TEMP}


## ,-----
## |	Configure
## +-----

NTI_MEMTEST86_CONFIGURED=${EXTTEMP}/${NTI_MEMTEST86_TEMP}/Makefile.OLD

.PHONY: nti-memtest86-configured
nti-memtest86-configured: nti-memtest86-extracted ${NTI_MEMTEST86_CONFIGURED}

${NTI_MEMTEST86_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC=/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^CC=/		s%$$%\nLD='$(shell echo ${NTI_GCC} | sed 's/gcc$$/ld/')'%' \
			| sed '/^AS=/		s%as%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/as/')'%' \
			| sed '/^	/	s%objcopy%'$(shell echo ${NTI_GCC} | sed 's/gcc$$/objcopy/')'%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

NTI_MEMTEST86_BUILT=${EXTTEMP}/${NTI_MEMTEST86_TEMP}/memtest.bin

.PHONY: nti-memtest86-built
nti-memtest86-built: nti-memtest86-configured ${NTI_MEMTEST86_BUILT}

${NTI_MEMTEST86_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		make memtest.bin \
	)


## ,-----
## |	Install
## +-----

NTI_MEMTEST86_INSTALLED=${NTI_TC_ROOT}/usr/lib/memtest86/memtest.bin

.PHONY: nti-memtest86-installed
nti-memtest86-installed: nti-memtest86-built ${NTI_MEMTEST86_INSTALLED}

${NTI_MEMTEST86_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${NTI_MEMTEST86_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib/memtest86 || exit 1 ;\
		cp memtest.bin ${NTI_TC_ROOT}/usr/lib/memtest86/ \
	)

.PHONY: nti-memtest86
nti-memtest86: nti-native-gcc nti-memtest86-installed

NTARGETS+= nti-memtest86

endif	# HAVE_MEMTEST86_CONFIG
