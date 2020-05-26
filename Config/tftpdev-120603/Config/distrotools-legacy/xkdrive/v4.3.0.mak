# xkdrive v4.3.0		[ since v4.3.0, c.2006-06-08 ]
# last mod WmT, 2011-09-21	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_XKDRIVE_CONFIG},y)
HAVE_XKDRIVE_CONFIG:=y

DESCRLIST+= "'cui-xkdrive' -- kdrive"

include ${CFG_ROOT}/ENV/ifbuild.env
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
include ${CFG_ROOT}/distrotools-legacy/uClibc-rt/v${CTI_UCLIBC_DEV_VER}.mak
endif



CUI_XKDRIVE_VER:=4.3.0
CUI_XKDRIVE_SRC:=
CUI_XKDRIVE_PATCHES:=

CUI_XKDRIVE_SRC+=${SRCDIR}/x/X430src-1.tgz
CUI_XKDRIVE_SRC+=${SRCDIR}/x/X430src-2.tgz
CUI_XKDRIVE_SRC+=${SRCDIR}/x/X430src-3.tgz
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/X430src-1.tgz
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/X430src-2.tgz
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/X430src-3.tgz

CUI_XKDRIVE_PATCHES+=${SRCDIR}/k/kdrive-4.3.0-gentoo-0.5.tar.bz2
URLS+=http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/kdrive-4.3.0-gentoo-0.5.tar.bz2


# ,-----
# |	Extract
# +-----

CUI_XKDRIVE_TEMP=cui-xkdrive-${CUI_XKDRIVE_VER}
CUI_XKDRIVE_INSTTEMP=${EXTTEMP}/insttemp

CUI_XKDRIVE_EXTRACTED=${EXTTEMP}/${CUI_XKDRIVE_TEMP}/programs/xwininfo/xwininfo.c

.PHONY: cui-xkdrive-extracted

cui-xkdrive-extracted: ${CUI_XKDRIVE_EXTRACTED}

${CUI_XKDRIVE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_XKDRIVE_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_XKDRIVE_TEMP}
	make -C ${TOPLEV} extract ARCHIVES="$(strip ${CUI_XKDRIVE_SRC})"
ifneq (${CUI_XKDRIVE_PATCHES},)
	echo "*** (PATCHING) ***"
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_XKDRIVE_PATCHES} ; do \
			make -C ../ extract ARCHIVES=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d xc -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/xc ${EXTTEMP}/${CUI_XKDRIVE_TEMP}


# ,-----
# |	Configure
# +-----

CUI_XKDRIVE_CONFIGURED=${EXTTEMP}/${CUI_XKDRIVE_TEMP}/config/cf/kdrive.cf.OLD

.PHONY: cui-xkdrive-configured

cui-xkdrive-configured: cui-xkdrive-extracted ${CUI_XKDRIVE_CONFIGURED}

${CUI_XKDRIVE_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_XKDRIVE_TEMP} || exit 1 ;\
		(	echo '#define CrossCompiling YES' ;\
			echo "#define HostCcCmd ${NTI_GCC}" ;\
			echo "#define CrossCcCmd ${CTI_GCC}" ;\
			echo '#define HasCplusplus NO' ;\
			\
			echo '#define KDriveXServer YES' ;\
			echo '#define TinyXServer YES' ;\
			echo '#define XfbdevServer NO' ;\
			echo '#define XvesaServer YES' ;\
			echo '#define BuildDPMS NO' ;\
			\
			echo '#define HasZlib NO' ;\
			echo '#define BuildBuiltinFonts YES' ;\
			echo '#define Build75Dpi YES' ;\
			echo '#define CompressAllFonts NO' ;\
			echo '#define GzipFontCompression NO' \
			) >config/cf/host.def || exit 1 ;\
		\
		[ -r config/imake/Makefile.ini.OLD ] || mv config/imake/Makefile.ini config/imake/Makefile.ini.OLD || exit 1 ;\
		cat config/imake/Makefile.ini.OLD \
			| sed '/^CC *=/ s%cc%'${NTI_GCC}'%' \
			> config/imake/Makefile.ini || exit 1 ;\
		\
		[ -r config/cf/cross.def.OLD ] || mv config/cf/cross.def config/cf/cross.def.OLD || exit 1 ;\
		cat config/cf/cross.def.OLD \
			| sed '/#if 0/	{ s%^%/* % ; s%$$% */% }' \
			| sed '/#endif/	{ s%^%/* % ; s%$$% */% }' \
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
			| sed '/LdPostLib/ { s%^%/* % ; s%$$% */% }' \
			> config/cf/cross.def || exit 1 ;\
		\
		[ -r config/cf/cross.rules.OLD ] || mv config/cf/cross.rules config/cf/cross.rules.OLD || exit 1 ;\
		cat config/cf/cross.rules.OLD \
			| sed '/define HostCcCmd/ s%cc%'${NTI_GCC}'%' \
			> config/cf/cross.rules || exit 1 ;\
		\
		[ -r config/cf/linux.cf.OLD ] || mv config/cf/linux.cf config/cf/linux.cf.OLD || exit 1 ;\
		cat config/cf/linux.cf.OLD \
			| sed '/define CcCmd/ s%gcc.*%${NTI_GCC}%' \
			> config/cf/linux.cf || exit 1 ;\
		\
		[ -r config/cf/xf86site.def.OLD ] || mv config/cf/xf86site.def config/cf/xf86site.def.OLD || exit 1 ;\
		cat config/cf/xf86site.def.OLD \
			| sed '/define BuildServersOnly/ { s%^% */\n% ; s%$$%\n/*% }' \
			> config/cf/xf86site.def || exit 1 ;\
		\
		touch config/cf/kdrive.cf.OLD \
	)

#			| sed '/define CcCmd/ s%/[^ ]*%'${CTI_GCC}'%' \
#			| sed '/define StdIncDir/ s%/[^ ]*%'${CTI_TC_ROOT}'/usr/'${CTI_SPEC}'/usr/include%' \
#			| sed '/define PostIncDir/ s%/[^ ]*%'${CTI_TC_ROOT}'/usr/lib/gcc-lib/'${CTI_SPEC}'/2.95.3/include%' \
#			| sed '/define HasCplusplus/ s/YES/NO/' \
#			| sed 's%/skiff/local%${CTI_TC_ROOT}%' \
#			| sed 's%arm-linux%'${CTI_SPEC}'%' \


#		[ -r config/cf/kdrive.cf.OLD ] || mv config/cf/kdrive.cf config/cf/kdrive.cf.OLD || exit 1 ;\
#		cat config/cf/kdrive.cf.OLD \
#			| sed '/define TinyXServer/ s/NO/YES/' \
#			| sed '/define XvesaServer/ s/NO/YES/' \
#			> config/cf/kdrive.cf || exit 1 \

#		[ -r config/cf/Imake.tmpl.OLD ] || mv config/cf/Imake.tmpl config/cf/Imake.tmpl.OLD || exit 1 ;\
#		cat config/cf/Imake.tmpl.OLD \
#			| sed '/define HostCcCmd/ { s%^%#endif\n% ; s%cc%'${NTI_GCC}'% ; s%$$%\n#if 0% }' \
#			> config/cf/Imake.tmpl || exit 1 ;\
#		\

# ,-----
# |	Build
# +-----

CUI_XKDRIVE_BUILT=${EXTTEMP}/${CUI_XKDRIVE_TEMP}/kdrive

.PHONY: cui-xkdrive-built
cui-xkdrive-built: cui-xkdrive-configured ${CUI_XKDRIVE_BUILT}

${CUI_XKDRIVE_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_XKDRIVE_TEMP} || exit 1 ;\
		make World \
	)

#			make CROSSCOMPILEDIR='' \
#				XCURSORGEN=${PWD}/exports/bin/xcursorgen \
#				World

#		make World CROSSCOMPILEDIR=${CTI_TC_ROOT}/usr/bin CC=${NTI_GCC} \

# ,-----
# |	Install
# +-----

CUI_XKDRIVE_INSTALLED=${CUI_XKDRIVE_INSTTEMP}/bin/kdrive

.PHONY: cui-xkdrive-installed

cui-xkdrive-installed: cui-xkdrive-built ${CUI_XKDRIVE_INSTALLED}

${CUI_XKDRIVE_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	mkdir -p ${CUI_XKDRIVE_INSTTEMP}
	( cd ${EXTTEMP}/${CUI_XKDRIVE_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_XKDRIVE_INSTTEMP} install \
	)


.PHONY: cui-xkdrive
cui-xkdrive: cti-cross-gcc cui-uClibc-rt cui-xkdrive-installed

CTARGETS+= cui-xkdrive

endif	# HAVE_XKDRIVE_CONFIG
