# z80asm v1.8			[ EARLIEST v1.8, c.2014-02-15 ]
# last mod WmT, 2014-02-15	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_Z80ASM_CONFIG},y)
HAVE_Z80ASM_CONFIG:=y

#DESCRLIST+= "'nti-z80asm' -- z80asm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${Z80ASM_VERSION},)
Z80ASM_VERSION=1.8
endif
Z80ASM_SRC=${SOURCES}/z/z80asm-${Z80ASM_VERSION}.tar.gz

#URLS+= http://download.savannah.gnu.org/releases/z80asm/z80asm-1.8.tar.gz
URLS+= http://download.savannah.nongnu.org/releases/z80asm/z80asm-1.8.tar.gz

#include ${CFG_ROOT}/buildtools/m4/v1.4.16.mak

NTI_Z80ASM_TEMP=nti-z80asm-${Z80ASM_VERSION}

NTI_Z80ASM_EXTRACTED=${EXTTEMP}/${NTI_Z80ASM_TEMP}/VERSION
NTI_Z80ASM_CONFIGURED=${EXTTEMP}/${NTI_Z80ASM_TEMP}/Makefile.OLD
NTI_Z80ASM_BUILT=${EXTTEMP}/${NTI_Z80ASM_TEMP}/z80asm
NTI_Z80ASM_INSTALLED=${NTI_TC_ROOT}/usr/bin/z80asm


## ,-----
## |	Extract
## +-----

${NTI_Z80ASM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/z80asm-${Z80ASM_VERSION} ] || rm -rf ${EXTTEMP}/z80asm-${Z80ASM_VERSION}
	zcat ${Z80ASM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_Z80ASM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_Z80ASM_TEMP}
	mv ${EXTTEMP}/z80asm-${Z80ASM_VERSION} ${EXTTEMP}/${NTI_Z80ASM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_Z80ASM_CONFIGURED}: ${NTI_Z80ASM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_Z80ASM_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed 's%^CC%'${NTI_GCC}'%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_Z80ASM_BUILT}: ${NTI_Z80ASM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_Z80ASM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_Z80ASM_INSTALLED}: ${NTI_Z80ASM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_Z80ASM_TEMP} || exit 1 ;\
		mkdir -p `dirname ${NTI_Z80ASM_INSTALLED}` ;\
		cp z80asm ${NTI_Z80ASM_INSTALLED} \
	)
#		make install

##

.PHONY: nti-z80asm
nti-z80asm: ${NTI_Z80ASM_INSTALLED}

ALL_NTI_TARGETS+= nti-z80asm

endif	# HAVE_Z80ASM_CONFIG
