# AppConfig v1.66		[ since v?.?, c.????-??-?? ]
# last mod WmT, 2014-03-17	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_APPCONFIG_CONFIG},y)
HAVE_APPCONFIG_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${APPCONFIG_VERSION},)
APPCONFIG_VERSION=1.66
endif

APPCONFIG_SRC=${SOURCES}/a/AppConfig-${APPCONFIG_VERSION}.tar.gz
URLS+= http://search.cpan.org/CPAN/authors/id/A/AB/ABW/AppConfig-${APPCONFIG_VERSION}.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak

NTI_APPCONFIG_TEMP=nti-AppConfig-${APPCONFIG_VERSION}
NTI_APPCONFIG_EXTRACTED=${EXTTEMP}/${NTI_APPCONFIG_TEMP}/Makefile.PL
NTI_APPCONFIG_CONFIGURED=${EXTTEMP}/${NTI_APPCONFIG_TEMP}/Makefile
NTI_APPCONFIG_BUILT=${EXTTEMP}/${NTI_APPCONFIG_TEMP}/pm_to_blib
#NTI_APPCONFIG_INSTALLED=${NTI_TC_ROOT}/usr/lib64/perl5/auto/AppConfig
NTI_APPCONFIG_INSTALLED=${NTI_TC_ROOT}/usr/lib/perl5/site_perl/${PERL_VERSION}/AppConfig/Args.pm


## ,-----
## |	Extract
## +-----

${NTI_APPCONFIG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/AppConfig-${APPCONFIG_VERSION} ] || rm -rf ${EXTTEMP}/AppConfig-${APPCONFIG_VERSION}
	zcat ${APPCONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_APPCONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_APPCONFIG_TEMP}
	mv ${EXTTEMP}/AppConfig-${APPCONFIG_VERSION} ${EXTTEMP}/${NTI_APPCONFIG_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_APPCONFIG_CONFIGURED}: ${NTI_APPCONFIG_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_APPCONFIG_TEMP} || exit 1 ;\
		perl Makefile.PL PREFIX=${NTI_TC_ROOT}/usr \
	)


## ,-----
## |	Build
## +-----

${NTI_APPCONFIG_BUILT}: ${NTI_APPCONFIG_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_APPCONFIG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_APPCONFIG_INSTALLED}: ${NTI_APPCONFIG_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_APPCONFIG_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-appconfig
nti-appconfig: nti-perl ${NTI_APPCONFIG_INSTALLED}

ALL_NTI_TARGETS+= nti-appconfig

endif	# HAVE_APPCONFIG_CONFIG
