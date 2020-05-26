# ppt v0.14			[ since v0.14, c.2006-04-03 ]
# last mod WmT, 2014-03-17	[ (c) and GPLv2 1999-2014 ]

#ifneq (${HAVE_MICROPERL_PPT_CONFIG},y)
#HAVE_MICROPERL_PPT_CONFIG:=y
#
#DESCRLIST+= "'cui-microperl-ppt' -- microperl-ppt"
#
### TODO: fails to find strict.pm -- looking where native perl would?
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak
#
#CUI_MICROPERL_PPT_VER:=0.14
#CUI_MICROPERL_PPT_SRC=${SRCDIR}/p/ppt-0.14.tar.gz
#CUI_MICROPERL_PPT_PATCHES=
#
#URLS+=http://search.cpan.org/CPAN/authors/id/C/CW/CWEST/ppt-0.14.tar.gz
#
##CUI_MICROPERL_PPT_PATCHES+=
##URLS+=
#
#
## ,-----
## |	Extract
## +-----
#
#CUI_MICROPERL_PPT_TEMP=cui-microperl-ppt-${CUI_MICROPERL_PPT_VER}
#CUI_MICROPERL_PPT_INSTTEMP=${EXTTEMP}/insttemp
#
#CUI_MICROPERL_PPT_EXTRACTED=${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP}/Makefile.PL
#
#.PHONY: cui-microperl-ppt-extracted
#
#cui-microperl-ppt-extracted: ${CUI_MICROPERL_PPT_EXTRACTED}
#
#${CUI_MICROPERL_PPT_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP}
#	make -C ${TOPLEV} extract ARCHIVE=${CUI_MICROPERL_PPT_SRC}
#ifneq (${CUI_MICROPERL_PPT_PATCHES},)
#	( cd ${EXTTEMP} || exit 1 ;\
#		for PATCHSRC in ${CUI_MICROPERL_PPT_PATCHES} ; do \
#			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
#		done ;\
#		for PF in patch/*patch ; do \
#			echo "*** PATCHING -- $${PF} ***" ;\
#			grep '+++' $${PF} ;\
#			patch --batch -d gcc-${CUI_MICROPERL_PPT_VER} -Np1 < $${PF} ;\
#			rm -f $${PF} ;\
#		done \
#	)
#endif
#	mv ${EXTTEMP}/ppt-${CUI_MICROPERL_PPT_VER} ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP}
#
#
## ,-----
## |	Configure
## +-----
#
#CUI_MICROPERL_PPT_CONFIGURED=${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP}/Makefile.PL.OLD
#
#.PHONY: cui-microperl-ppt-configured
#
#cui-microperl-ppt-configured: cui-microperl-ppt-extracted ${CUI_MICROPERL_PPT_CONFIGURED}
#
#${CUI_MICROPERL_PPT_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP} || exit 1 ;\
#		cp Makefile.PL Makefile.PL.OLD \
#	)
#
#
#
## ,-----
## |	Build
## +-----
#
#CUI_MICROPERL_PPT_BUILT=${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP}/Makefile
#
#.PHONY: cui-microperl-ppt-built
#cui-microperl-ppt-built: cui-microperl-ppt-configured ${CUI_MICROPERL_PPT_BUILT}
#
#${CUI_MICROPERL_PPT_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP} || exit 1 ;\
#		perl Makefile.PL || exit 1 \
#	) || exit 1
#
#
## ,-----
## |	Install
## +-----
#
#CUI_MICROPERL_PPT_INSTALLED=${CUI_MICROPERL_PPT_INSTTEMP}/usr/local/ppt
#
#.PHONY: cui-microperl-ppt-installed
#
#cui-microperl-ppt-installed: cui-microperl-ppt-built ${CUI_MICROPERL_PPT_INSTALLED}
#
#${CUI_MICROPERL_PPT_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CUI_MICROPERL_PPT_TEMP} || exit 1 ;\
#		make install DESTDIR=${CUI_MICROPERL_PPT_INSTTEMP} \
#	) || exit 1
#
#
#.PHONY: cui-microperl
#cui-microperl-ppt: cti-cross-gcc cui-uClibc-rt cui-microperl-ppt-installed
#
#TARGETS+= cui-microperl-ppt
#
#endif	# HAVE_MICROPERL_PPT_CONFIG

ifneq (${HAVE_PPT_CONFIG},y)
HAVE_PPT_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-ppt' -- ppt (perl power tools)"

ifeq (${PPT_VERSION},)
PPT_VERSION=0.14
endif

PPT_SRC=${SOURCES}/p/ppt-0.14.tar.gz
URLS+= http://search.cpan.org/CPAN/authors/id/C/CW/CWEST/ppt-0.14.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
include ${CFG_ROOT}/perl/perl/v5.18.4.mak

NTI_PPT_TEMP=nti-ppt-${PPT_VERSION}

NTI_PPT_EXTRACTED=${EXTTEMP}/${NTI_PPT_TEMP}/README
NTI_PPT_CONFIGURED=${EXTTEMP}/${NTI_PPT_TEMP}/Makefile.PL.OLD
NTI_PPT_BUILT=${EXTTEMP}/${NTI_PPT_TEMP}/Makefile
NTI_PPT_INSTALLED=${NTI_TC_ROOT}/usr/local/bin/ppt

## ,-----
## |	Extract
## +-----

${NTI_PPT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ppt-${PPT_VERSION} ] || rm -rf ${EXTTEMP}/ppt-${PPT_VERSION}
	zcat ${PPT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PPT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PPT_TEMP}
	mv ${EXTTEMP}/ppt-${PPT_VERSION} ${EXTTEMP}/${NTI_PPT_TEMP}


## ,-----
## |	Configure
## +-----

# Dummy 'configure'

${NTI_PPT_CONFIGURED}: ${NTI_PPT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PPT_TEMP} || exit 1 ;\
		cp Makefile.PL Makefile.PL.OLD \
	)


## ,-----
## |	Build
## +-----

${NTI_PPT_BUILT}: ${NTI_PPT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PPT_TEMP} || exit 1 ;\
		perl Makefile.PL PREFIX=${NTI_TC_ROOT}/usr/local || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_PPT_INSTALLED}: ${NTI_PPT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PPT_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ppt
nti-ppt: nti-perl ${NTI_PPT_INSTALLED}

ALL_NTI_TARGETS+= nti-ppt

endif	# HAVE_PPT_CONFIG
