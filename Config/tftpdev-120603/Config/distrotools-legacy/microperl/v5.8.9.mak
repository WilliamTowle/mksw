# microperl v5.8.9		[ since v5.6.1, c.2003-03-19 ]
# last mod WmT, 2010-06-08	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_MICROPERL_CONFIG},y)
HAVE_MICROPERL_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

DESCRLIST+= "'cui-microperl' -- microperl"

CUI_MICROPERL_VER:=5.8.9
CUI_MICROPERL_SRC=${SRCDIR}/p/perl-${CUI_MICROPERL_VER}.tar.bz2
CUI_MICROPERL_PATCHES=

URLS+=http://ftp.funet.fi/pub/CPAN/src/perl-${CUI_MICROPERL_VER}.tar.bz2

#CUI_MICROPERL_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_MICROPERL_TEMP=cui-microperl-${CUI_MICROPERL_VER}
CUI_MICROPERL_INSTTEMP=${EXTTEMP}/insttemp

CUI_MICROPERL_EXTRACTED=${EXTTEMP}/${CUI_MICROPERL_TEMP}/configure

.PHONY: cui-microperl-extracted

cui-microperl-extracted: ${CUI_MICROPERL_EXTRACTED}

${CUI_MICROPERL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_MICROPERL_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_MICROPERL_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${CUI_MICROPERL_SRC}
ifneq (${CUI_MICROPERL_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_MICROPERL_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_MICROPERL_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/perl-${CUI_MICROPERL_VER} ${EXTTEMP}/${CUI_MICROPERL_TEMP}


# ,-----
# |	Configure
# +-----

CUI_MICROPERL_CONFIGURED=${EXTTEMP}/${CUI_MICROPERL_TEMP}/GNUmakefile

.PHONY: cui-microperl-configured

cui-microperl-configured: cui-microperl-extracted ${CUI_MICROPERL_CONFIGURED}

${CUI_MICROPERL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_MICROPERL_TEMP} || exit 1 ;\
		cp Makefile.micro GNUmakefile || exit 1 \
	)



# ,-----
# |	Build
# +-----

CUI_MICROPERL_BUILT=${EXTTEMP}/${CUI_MICROPERL_TEMP}/microperl

.PHONY: cui-microperl-built
cui-microperl-built: cui-microperl-configured ${CUI_MICROPERL_BUILT}

${CUI_MICROPERL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_MICROPERL_TEMP} || exit 1 ;\
		make CC=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-gcc || exit 1 \
	) || exit 1



# ,-----
# |	Install
# +-----

CUI_MICROPERL_INSTALLED=${CUI_MICROPERL_INSTTEMP}/bin/microperl

.PHONY: cui-microperl-installed

cui-microperl-installed: cui-microperl-built ${CUI_MICROPERL_INSTALLED}

${CUI_MICROPERL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_MICROPERL_INSTTEMP}
	( cd ${EXTTEMP}/${CUI_MICROPERL_TEMP} || exit 1 ;\
		mkdir -p ${CUI_MICROPERL_INSTTEMP}/usr/bin/ || exit 1 ;\
		mkdir -p ${CUI_MICROPERL_INSTTEMP}/usr/lib/perl5/perl-5.9/ || exit 1 ;\
		cp -dpf microperl ${CUI_MICROPERL_INSTTEMP}/usr/bin/microperl ;\
		cp -r lib/* ${CUI_MICROPERL_INSTTEMP}/usr/lib/perl5/perl-5.9 || exit 1 \
	) || exit 1


.PHONY: cui-microperl
cui-microperl: cti-cross-gcc cui-uClibc-rt cui-microperl-installed

TARGETS+= cui-microperl

endif	# HAVE_MICROPERL_CONFIG
