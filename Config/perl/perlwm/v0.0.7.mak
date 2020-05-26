# perlwm v0.0.7			[ since v0.0.7, c.2017-04-19 ]
# last mod WmT, 2017-04-19	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_PERLWM_CONFIG},y)
HAVE_PERLWM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-perlwm' -- perlwm (perl power tools)"

ifeq (${PERLWM_VERSION},)
PERLWM_VERSION=0.0.7
endif

PERLWM_SRC=${SOURCES}/p/perlwm-${PERLWM_VERSION}.tar.gz
URLS+= "https://downloads.sourceforge.net/project/perlwm/perlwm/0.0.7/perlwm-0.0.7.tar.gz?r=http%3A%2F%2Fperlwm.sourceforge.net%2Fcode.html&ts=1492601964&use_mirror=ayera"

##include ${CFG_ROOT}/perl/perl/v5.18.2.mak
#include ${CFG_ROOT}/perl/perl/v5.18.4.mak

NTI_PERLWM_TEMP=nti-perlwm-${PERLWM_VERSION}

NTI_PERLWM_EXTRACTED=${EXTTEMP}/${NTI_PERLWM_TEMP}/README
NTI_PERLWM_CONFIGURED=${EXTTEMP}/${NTI_PERLWM_TEMP}/Makefile.PL.OLD
NTI_PERLWM_BUILT=${EXTTEMP}/${NTI_PERLWM_TEMP}/Makefile
NTI_PERLWM_INSTALLED=${NTI_TC_ROOT}/usr/local/bin/perlwm

## ,-----
## |	Extract
## +-----

${NTI_PERLWM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/perlwm-${PERLWM_VERSION} ] || rm -rf ${EXTTEMP}/perlwm-${PERLWM_VERSION}
	zcat ${PERLWM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PERLWM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PERLWM_TEMP}
	mv ${EXTTEMP}/perlwm-${PERLWM_VERSION} ${EXTTEMP}/${NTI_PERLWM_TEMP}


## ,-----
## |	Configure
## +-----

# Dummy 'configure'

${NTI_PERLWM_CONFIGURED}: ${NTI_PERLWM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PERLWM_TEMP} || exit 1 ;\
		cp Makefile.PL Makefile.PL.OLD \
	)


## ,-----
## |	Build
## +-----

${NTI_PERLWM_BUILT}: ${NTI_PERLWM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PERLWM_TEMP} || exit 1 ;\
		perl Makefile.PL PREFIX=${NTI_TC_ROOT}/usr/local || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_PERLWM_INSTALLED}: ${NTI_PERLWM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PERLWM_TEMP} || exit 1 ;\
		make install \
	)

##

#.PHONY: nti-perlwm
#nti-perlwm: nti-perl ${NTI_PERLWM_INSTALLED}
.PHONY: nti-perlwm
nti-perlwm: ${NTI_PERLWM_INSTALLED}

ALL_NTI_TARGETS+= nti-perlwm

endif	# HAVE_PERLWM_CONFIG
