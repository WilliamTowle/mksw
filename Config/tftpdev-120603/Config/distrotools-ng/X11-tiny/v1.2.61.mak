# X11-tiny v1.2.61		[ since v5.9, c. 2005-02-07 ]
# last mod WmT, 2011-10-19	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_X11_TINY_CONFIG},y)
HAVE_X11_TINY_CONFIG:=y

DESCRLIST+= "'cui-X11-tiny' -- X11-tiny"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
else
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif

X11_TINY_VER=1.2.61
X11_TINY_SRC=${SRCDIR}/x/X11-tiny-1.2.61.tar.bz2

URLS+= http://distro.ibiblio.org/pub/linux/distributions/amigolinux/download/AmigoProjects/X11-tiny-1.2.61/X11-tiny-1.2.61.tar.bz2


## ,-----
## |	Extract
## +-----

CUI_X11_TINY_TEMP=cui-X11-tiny-${X11_TINY_VER}
CUI_X11_TINY_EXTRACTED=${EXTTEMP}/${CUI_X11_TINY_TEMP}/Makefile
CUI_X11_TINY_INSTTEMP=${EXTTEMP}/insttemp

##

.PHONY: cui-X11-tiny-extracted

cui-X11-tiny-extracted: ${CUI_X11_TINY_EXTRACTED}

${CUI_X11_TINY_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_X11_TINY_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_X11_TINY_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${X11_TINY_SRC}
	mv ${EXTTEMP}/X11-tiny-${X11_TINY_VER} ${EXTTEMP}/${CUI_X11_TINY_TEMP}


## ,-----
## |	Configure
## +-----

CUI_X11_TINY_CONFIGURED=${EXTTEMP}/${CUI_X11_TINY_TEMP}/config/cf/xf86site.def.OLD

.PHONY: cui-X11-tiny-configured

cui-X11-tiny-configured: cui-X11-tiny-extracted ${CUI_X11_TINY_CONFIGURED}

${CUI_X11_TINY_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_X11_TINY_TEMP} || exit 1 ;\
		[ -r config/imake/Makefile.ini.OLD ] || mv config/imake/Makefile.ini config/imake/Makefile.ini.OLD || exit 1 ;\
		cat config/imake/Makefile.ini.OLD \
			| sed '/^CC *=/ s%cc%'${NTI_GCC}'%' \
			> config/imake/Makefile.ini || exit 1 ;\
		\
		(	echo '#define CrossCompiling YES' ;\
			echo "#define HostCcCmd ${NTI_GCC}" ;\
			echo "#define CrossCcCmd ${CTI_GCC}" ;\
			\
			echo '#define KDriveXServer YES' ;\
			echo '#define TinyXServer YES' ;\
			echo '#define XfbdevServer NO' ;\
			echo '#define XvesaServer YES' ;\
			echo '#define BuildServersOnly YES' ;\
			echo '#define BuildDPMS NO' ;\
			\
			echo '#define HasZlib NO' ;\
			echo '#define CompressAllFonts NO' ;\
			echo '#define GzipFontCompression NO' \
			\
			) >config/cf/host.def || exit 1 ;\
		\
		[ -r config/cf/cross.def.OLD ] || mv config/cf/cross.def config/cf/cross.def.OLD || exit 1 ;\
		cat config/cf/cross.def.OLD \
			| sed '/undef i386/ s/undef/define/' \
			| sed '/define Arm32/ s/define/undef/' \
			| sed '/StandardDefines/ s/-D__arm__//' \
			| sed '/DX_LOCALE/ s/$$/ -DTOSHIBA_SMM=0/' \
			| sed '/CcCmd/ s%/.*%'${CTI_GCC}'%' \
			| sed '/StdIncDir/ s%/.*%'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include%' \
			| sed '/PostIncDir/ { s%^%/* % ; s%$$% */% }' \
			| sed '/HasCPlusplus/ s/YES/NO/' \
			| sed '/CplusplusCmd/ { s%^%/* % ; s%$$% */% }' \
			| sed '/RanlibCmd/ s%/.*%'`echo ${CTI_GCC} | sed 's/gcc$$/ranlib/'`'%' \
			| sed '/LdPostLib/ s%/.*%'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/lib%' \
			> config/cf/cross.def || exit 1 ;\
		\
		[ -r config/cf/linux.cf.OLD ] || mv config/cf/linux.cf config/cf/linux.cf.OLD || exit 1 ;\
		cat config/cf/linux.cf.OLD \
			| sed '/define CcCmd/ s%gcc.*%${NTI_GCC}%' \
			| sed '/define HasZlib/ s/YES/NO/' \
			> config/cf/linux.cf || exit 1 ;\
		\
		[ -r config/cf/xf86site.def.OLD ] || mv config/cf/xf86site.def config/cf/xf86site.def.OLD || exit 1 ;\
		cat config/cf/xf86site.def.OLD \
			| sed '/define BuildServersOnly/ { s%^% */\n% ; s%$$%\n/*% }' \
			> config/cf/xf86site.def || exit 1 \
	)



## ,-----
## |	Build
## +-----

CUI_X11_TINY_BUILT=${EXTTEMP}/${CUI_X11_TINY_TEMP}/X11-tiny

.PHONY: cui-X11-tiny-built
cui-X11-tiny-built: cui-X11-tiny-configured ${CUI_X11_TINY_BUILT}

${CUI_X11_TINY_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_X11_TINY_TEMP} || exit 1 ;\
		make World \
	)


## ,-----
## |	Install
## +-----

CUI_X11_TINY_INSTALLED=${CUI_X11_TINY_INSTTEMP}/usr/bin/X11-tiny

.PHONY: cui-X11-tiny-installed

cui-X11-tiny-installed: cui-X11-tiny-built ${CUI_X11_TINY_INSTALLED}

${CUI_X11_TINY_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	for SD in /usr/man /usr/info ; do \
		mkdir -p ${CUI_X11_TINY_INSTTEMP}/$${SD} || exit 1 ;\
	done
	( cd ${EXTTEMP}/${CUI_X11_TINY_TEMP} || exit 1 ;\
		make RM="echo NOT DOING rm" install DESTDIR=${CUI_X11_TINY_INSTTEMP} \
	)

##

.PHONY: cui-X11-tiny
cui-X11-tiny: cti-cross-gcc cui-X11-tiny-installed

CTARGETS+= cui-X11-tiny

endif	# HAVE_X11_TINY_CONFIG
