# XML::Parser v2.44		[ since v2.41, c.2013-04-22 ]
# last mod WmT, 2015-10-23	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_XML_PARSER_CONFIG},y)
HAVE_XML_PARSER_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-XML-Parser' -- XML-Parser (perl power tools)"

ifeq (${XML_PARSER_VERSION},)
#XML_PARSER_VERSION=2.41
XML_PARSER_VERSION=2.44
endif

XML_PARSER_SRC=${SOURCES}/x/XML-Parser-${XML_PARSER_VERSION}.tar.gz
URLS+= http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-${XML_PARSER_VERSION}.tar.gz

include ${CFG_ROOT}/perl/perl/v5.22.0.mak
include ${CFG_ROOT}/misc/expat/v2.1.0.mak

NTI_XML_PARSER_TEMP=nti-XML-Parser-${XML_PARSER_VERSION}

NTI_XML_PARSER_EXTRACTED=${EXTTEMP}/${NTI_XML_PARSER_TEMP}/README
NTI_XML_PARSER_CONFIGURED=${EXTTEMP}/${NTI_XML_PARSER_TEMP}/.configured
NTI_XML_PARSER_BUILT=${EXTTEMP}/${NTI_XML_PARSER_TEMP}/Makefile
ifeq ($(shell uname -m),x86_64)
NTI_XML_PARSER_INSTALLED=${NTI_TC_ROOT}/usr/lib64/perl5/auto/XML
else	# Slax v6.1.2
NTI_XML_PARSER_INSTALLED=${NTI_TC_ROOT}/usr/lib/perl5/site_perl/${PERL_VERSION}/i686-linux/auto/XML
endif

## ,-----
## |	Extract
## +-----

${NTI_XML_PARSER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/XML-Parser-${XML_PARSER_VERSION} ] || rm -rf ${EXTTEMP}/XML-Parser-${XML_PARSER_VERSION}
	zcat ${XML_PARSER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XML_PARSER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XML_PARSER_TEMP}
	mv ${EXTTEMP}/XML-Parser-${XML_PARSER_VERSION} ${EXTTEMP}/${NTI_XML_PARSER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XML_PARSER_CONFIGURED}: ${NTI_XML_PARSER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XML_PARSER_TEMP} || exit 1 ;\
		touch ${NTI_XML_PARSER_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_XML_PARSER_BUILT}: ${NTI_XML_PARSER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XML_PARSER_TEMP} || exit 1 ;\
		perl Makefile.PL \
			PREFIX=${NTI_TC_ROOT}/usr \
			EXPATINCPATH=${NTI_TC_ROOT}/usr/include \
			EXPATLIBPATH=${NTI_TC_ROOT}/usr/lib \
			|| exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_XML_PARSER_INSTALLED}: ${NTI_XML_PARSER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XML_PARSER_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-XML-Parser
nti-XML-Parser: nti-perl nti-expat ${NTI_XML_PARSER_INSTALLED}

ALL_NTI_TARGETS+= nti-XML-Parser

endif	# HAVE_XML_PARSER_CONFIG
