# bash v4.3			[ since v?.? ????-??-?? ]
# last mod WmT, 2014-11-14	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_BASH_CONFIG},y)
HAVE_BASH_CONFIG:=y

#DESCRLIST+= "'nti-bash' -- bash"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${BASH_VERSION},)
#BASH_VERSION=4.2
BASH_VERSION=4.3
endif
BASH_SRC=${SOURCES}/b/bash-${BASH_VERSION}.tar.gz
#NATIVE_BASH_PATCHES=${SOURCES}/b/bash43-025

URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/bash/bash-4.3.tar.gz
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/bash/bash-4.3-patches/bash43-025

NTI_BASH_TEMP=nti-bash-${BASH_VERSION}

NTI_BASH_EXTRACTED=${EXTTEMP}/${NTI_BASH_TEMP}/COPYING
NTI_BASH_CONFIGURED=${EXTTEMP}/${NTI_BASH_TEMP}/config.log
NTI_BASH_BUILT=${EXTTEMP}/${NTI_BASH_TEMP}/bash
NTI_BASH_INSTALLED=${NTI_TC_ROOT}/bin/bash


## ,-----
## |	Extract
## +-----

${NTI_BASH_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bash-${BASH_VERSION} ] || rm -rf ${EXTTEMP}/bash-${BASH_VERSION}
	zcat ${BASH_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${NATIVE_BASH_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${NATIVE_BASH_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			patch --batch -d bash-${BASH_VERSION} -Np0 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_BASH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BASH_TEMP}
	mv ${EXTTEMP}/bash-${BASH_VERSION} ${EXTTEMP}/${NTI_BASH_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_BASH_CONFIGURED}: ${NTI_BASH_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BASH_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BASH_BUILT}: ${NTI_BASH_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BASH_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BASH_INSTALLED}: ${NTI_BASH_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BASH_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-bash
nti-bash: ${NTI_BASH_INSTALLED}

ALL_NTI_TARGETS+= nti-bash

endif	# HAVE_BASH_CONFIG
