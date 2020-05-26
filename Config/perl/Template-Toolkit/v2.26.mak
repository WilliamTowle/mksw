# Template-Toolkit v2.26	[ since v?.?, c.????-??-?? ]
# last mod WmT, 2016-10-03	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_TEMPLATE_TOOLKIT_CONFIG},y)
HAVE_TEMPLATE_TOOLKIT_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TEMPLATE_TOOLKIT},)
#TEMPLATE_TOOLKIT_VERSION=2.22
TEMPLATE_TOOLKIT_VERSION=2.26
endif

TEMPLATE_TOOLKIT_SRC=${SOURCES}/t/Template-Toolkit-2.26.tar.gz
URLS+= http://search.cpan.org/CPAN/authors/id/A/AB/ABW/Template-Toolkit-${TEMPLATE_TOOLKIT_VERSION}.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak

NTI_TEMPLATE_TOOLKIT_TEMP=nti-Template-Toolkit-${TEMPLATE_TOOLKIT_VERSION}

NTI_TEMPLATE_TOOLKIT_EXTRACTED=${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP}/Makefile.PL
NTI_TEMPLATE_TOOLKIT_CONFIGURED=${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP}/Makefile
NTI_TEMPLATE_TOOLKIT_BUILT=${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP}/pm_to_blib
ifeq ($(shell uname -m),x86_64)
NTI_TEMPLATE_TOOLKIT_INSTALLED=${NTI_TC_ROOT}/usr/lib64/perl5/auto/Template
else	# Slax v6.1.2
NTI_TEMPLATE_TOOLKIT_INSTALLED=${NTI_TC_ROOT}/usr/lib/perl5/site_perl/5.10.0/i486-linux-thread-multi/auto/Template
endif


## ,-----
## |	Extract
## +-----

${NTI_TEMPLATE_TOOLKIT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/Template-Toolkit-${TEMPLATE_TOOLKIT_VERSION} ] || rm -rf ${EXTTEMP}/Template-Toolkit-${TEMPLATE_TOOLKIT_VERSION}
	zcat ${TEMPLATE_TOOLKIT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP}
	mv ${EXTTEMP}/Template-Toolkit-${TEMPLATE_TOOLKIT_VERSION} ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TEMPLATE_TOOLKIT_CONFIGURED}: ${NTI_TEMPLATE_TOOLKIT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP} || exit 1 ;\
		yes '' | perl Makefile.PL PREFIX=${NTI_TC_ROOT}/usr \
	)


## ,-----
## |	Build
## +-----

${NTI_TEMPLATE_TOOLKIT_BUILT}: ${NTI_TEMPLATE_TOOLKIT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TEMPLATE_TOOLKIT_INSTALLED}: ${NTI_TEMPLATE_TOOLKIT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TEMPLATE_TOOLKIT_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-template-toolkit
nti-template-toolkit: nti-perl ${NTI_TEMPLATE_TOOLKIT_INSTALLED}

ALL_NTI_TARGETS+= nti-template-toolkit

endif	# HAVE_TEMPLATE_TOOLKIT_CONFIG
