# perl v1.18.2			[ since v5.6.1, c.2003-03-19 ]
# last mod WmT, 2014-01-20	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_PERL_CONFIG},y)
HAVE_PERL_CONFIG:=y

#DESCRLIST+= "'nti-perl' -- perl"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PERL_VERSION},)
#PERL_VERSION=5.16.2
PERL_VERSION=5.18.2
endif
PERL_SRC=${SOURCES}/p/perl-${PERL_VERSION}.tar.gz

URLS+= http://www.cpan.org/src/5.0/perl-${PERL_VERSION}.tar.gz

NTI_PERL_TEMP=nti-perl-${PERL_VERSION}

NTI_PERL_EXTRACTED=${EXTTEMP}/${NTI_PERL_TEMP}/README
NTI_PERL_CONFIGURED=${EXTTEMP}/${NTI_PERL_TEMP}/Makefile
NTI_PERL_BUILT=${EXTTEMP}/${NTI_PERL_TEMP}/perl
NTI_PERL_INSTALLED=${NTI_TC_ROOT}/usr/bin/perl

## ,-----
## |	Extract
## +-----

${NTI_PERL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/perl-${PERL_VERSION} ] || rm -rf ${EXTTEMP}/perl-${PERL_VERSION}
	zcat ${PERL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PERL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PERL_TEMP}
	mv ${EXTTEMP}/perl-${PERL_VERSION} ${EXTTEMP}/${NTI_PERL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PERL_CONFIGURED}: ${NTI_PERL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PERL_TEMP} || exit 1 ;\
		./Configure -des -Dprefix=${NTI_TC_ROOT}/usr \
			-Dcc=`which gcc` \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PERL_BUILT}: ${NTI_PERL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PERL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PERL_INSTALLED}: ${NTI_PERL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PERL_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-perl
nti-perl: ${NTI_PERL_INSTALLED}

ALL_NTI_TARGETS+= nti-perl

endif	# HAVE_PERL_CONFIG
