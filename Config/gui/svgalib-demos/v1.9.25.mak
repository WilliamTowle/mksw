#	# svgalib-demos v1.4.3		[ since v1.4.3, c.2003-07-05 ]
#	# last mod WmT, 2010-06-16	[ (c) and GPLv2 1999-2011 ]
#	
#	ifneq (${HAVE_SVGALIB_DEMOS_CONFIG},y)
#	HAVE_SVGALIB_DEMOS_CONFIG:=y
#	
#	DESCRLIST+= "'cui-svgalib-demos' -- svgalib-demos"
#	DESCRLIST+= "'nti-svgalib-demos' -- svgalib-demos"
#	
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	include ${CFG_ROOT}/ENV/native.mak
#	include ${CFG_ROOT}/ENV/target.mak
#	
#	ifneq (${HAVE_CROSS_GCC_VER},)
#	include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
#	include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
#	endif
#	
#	include ${CFG_ROOT}/buildtools/make/v3.81.mak
#	include ${CFG_ROOT}/distrotools-legacy/svgalib/v1.4.3.mak
#	
#	SVGALIB_DEMOS_VER:=1.4.3
#	SVGALIB_DEMOS_SRC=${SRCDIR}/s/svgalib-1.4.3.tar.gz
#	SVGALIB_DEMOS_PATCHES=
#	
#	URLS+=http://www.svgalib.org/svgalib-1.4.3.tar.gz
#	
#	SVGALIB_DEMOS_PATCHES+=${SRCDIR}/s/svgalib-1.4.3-debian_fixes-1.patch
#	URLS+=http://www.linuxfromscratch.org/patches/downloads/svgalib/svgalib-1.4.3-debian_fixes-1.patch
#	
#	
#	# ,-----
#	# |	Extract
#	# +-----
#	
#	CUI_SVGALIB_DEMOS_TEMP=cui-svgalib-demos-${SVGALIB_DEMOS_VER}
#	CUI_SVGALIB_DEMOS_INSTTEMP=${EXTTEMP}/insttemp
#	
#	CUI_SVGALIB_DEMOS_EXTRACTED=${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP}/Makefile
#	
#	
#	NTI_SVGALIB_DEMOS_TEMP=nti-svgalib-demos-${SVGALIB_DEMOS_VER}
#	NTI_SVGALIB_DEMOS_INSTTEMP=${NTI_TC_ROOT}
#	
#	NTI_SVGALIB_DEMOS_EXTRACTED=${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP}/Makefile
#	
#	##
#	
#	.PHONY: cui-svgalib-demos-extracted
#	
#	cui-svgalib-demos-extracted: ${CUI_SVGALIB_DEMOS_EXTRACTED}
#	
#	${CUI_SVGALIB_DEMOS_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${SVGALIB_DEMOS_SRC}
#	ifneq (${SVGALIB_DEMOS_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PF in ${SVGALIB_DEMOS_PATCHES} ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d svgalib-${SVGALIB_DEMOS_VER} -Np1 < $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/svgalib-${SVGALIB_DEMOS_VER} ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP}
#	
#	##
#	
#	.PHONY: nti-svgalib-demos-extracted
#	
#	nti-svgalib-demos-extracted: ${NTI_SVGALIB_DEMOS_EXTRACTED}
#	
#	${NTI_SVGALIB_DEMOS_EXTRACTED}:
#		echo "*** $@ (EXTRACTED) ***"
#		[ ! -d ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP}
#		make -C ${TOPLEV} extract ARCHIVES=${SVGALIB_DEMOS_SRC}
#	ifneq (${SVGALIB_DEMOS_PATCHES},)
#		( cd ${EXTTEMP} || exit 1 ;\
#			for PF in ${SVGALIB_DEMOS_PATCHES} ; do \
#				echo "*** PATCHING -- $${PF} ***" ;\
#				grep '+++' $${PF} ;\
#				patch --batch -d svgalib-${SVGALIB_DEMOS_VER} -Np1 < $${PF} ;\
#			done \
#		)
#	endif
#		mv ${EXTTEMP}/svgalib-${SVGALIB_DEMOS_VER} ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP}
#	
#	
#	
#	# ,-----
#	# |	Configure
#	# +-----
#	
#	CUI_SVGALIB_DEMOS_CONFIGURED=${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP}/Makefile.cfg.OLD
#	
#	NTI_SVGALIB_DEMOS_CONFIGURED=${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP}/Makefile.cfg.OLD
#	
#	
#	##
#	
#	.PHONY: cui-svgalib-demos-configured
#	
#	cui-svgalib-demos-configured: cui-svgalib-demos-extracted ${CUI_SVGALIB_DEMOS_CONFIGURED}
#	
#	${CUI_SVGALIB_DEMOS_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			[ -r Makefile.cfg.OLD ] \
#				|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
#			cat Makefile.cfg.OLD \
#				| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
#				| sed '/^	*CC/ s%gcc%'${CTI_GCC}'%' \
#				| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
#				| sed '/^prefix/ s%/usr/local%%' \
#				| sed '/^INSTALLMAN/ s/^/#/' \
#				> Makefile.cfg || exit 1 ;\
#			[ -r demos/Makefile.OLD ] || mv demos/Makefile demos/Makefile.OLD ;\
#			cat demos/Makefile.OLD \
#				| sed '/^	chown/	s/^/#/' \
#				> demos/Makefile ;\
#			[ -r threeDKit/Makefile.OLD ] || mv threeDKit/Makefile threeDKit/Makefile.OLD ;\
#			cat threeDKit/Makefile.OLD \
#				| sed '/^	chown/	s/^/#/' \
#				> threeDKit/Makefile \
#		)
#	
#	##
#	
#	.PHONY: nti-svgalib-demos-configured
#	
#	nti-svgalib-demos-configured: nti-svgalib-demos-extracted ${NTI_SVGALIB_DEMOS_CONFIGURED}
#	
#	${NTI_SVGALIB_DEMOS_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#		( cd ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			[ -r Makefile.cfg.OLD ] \
#				|| mv Makefile.cfg Makefile.cfg.OLD || exit 1 ;\
#			cat Makefile.cfg.OLD \
#				| sed '/^ifndef CC/,/^$$/ { /if/ s/^/#/ }' \
#				| sed '/^	*CC/ s%gcc%'${NUI_CC_PREFIX}'cc -L'${NTI_TC_ROOT}'/usr/lib%' \
#				| sed '/^INCLUDE_FBDEV_DRIVER/ s/^/#/' \
#				| sed '/^prefix/ s%/usr/local%%' \
#				| sed '/^INSTALLMAN/ s/^/#/' \
#				> Makefile.cfg || exit 1 ;\
#			[ -r demos/Makefile.OLD ] || mv demos/Makefile demos/Makefile.OLD ;\
#			cat demos/Makefile.OLD \
#				| sed '/^	chown/	s/^/#/' \
#				> demos/Makefile ;\
#			[ -r threeDKit/Makefile.OLD ] || mv threeDKit/Makefile threeDKit/Makefile.OLD ;\
#			cat threeDKit/Makefile.OLD \
#				| sed '/^	chown/	s/^/#/' \
#				> threeDKit/Makefile \
#		)
#	
#	
#	
#	# ,-----
#	# |	Build
#	# +-----
#	
#	CUI_SVGALIB_DEMOS_BUILT=${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP}/threeDKit/plane
#	
#	NTI_SVGALIB_DEMOS_BUILT=${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP}/threeDKit/plane
#	
#	##
#	
#	.PHONY: cui-svgalib-demos-built
#	cui-svgalib-demos-built: cui-svgalib-demos-configured ${CUI_SVGALIB_DEMOS_BUILT}
#	
#	${CUI_SVGALIB_DEMOS_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			make TOPDIR=/ demoprogs || exit 1 \
#		) || exit 1
#	
#	##
#	
#	.PHONY: nti-svgalib-demos-built
#	nti-svgalib-demos-built: nti-svgalib-demos-configured ${NTI_SVGALIB_DEMOS_BUILT}
#	
#	${NTI_SVGALIB_DEMOS_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			make TOPDIR=/ demoprogs || exit 1 \
#		) || exit 1
#	
#	
#	# ,-----
#	# |	Install
#	# +-----
#	
#	CUI_SVGALIB_DEMOS_INSTALLED=${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin/plane
#	
#	NTI_SVGALIB_DEMOS_INSTALLED=${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin/plane
#	
#	
#	##
#	
#	.PHONY: cui-svgalib-demos-installed
#	
#	cui-svgalib-demos-installed: cui-svgalib-demos-built ${CUI_SVGALIB_DEMOS_INSTALLED}
#	
#	${CUI_SVGALIB_DEMOS_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		mkdir -p ${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin
#		( cd ${EXTTEMP}/${CUI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			case ${SVGALIB_DEMOS_VER} in \
#			1.4.3)	\
#				cp demos/fun ${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				[ -r demos/testgl ] && cp demos/testgl ${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				cp threeDKit/plane ${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				cp threeDKit/wrapdemo ${CUI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 \
#			;; \
#			*) \
#				echo "INSTALL: Unexpected SVGALIB_DEMOS_VER ${SVGALIB_DEMOS_VER}" 1>&2 ;\
#				exit 1 \
#			;; \
#			esac \
#		) || exit 1
#	
#	##
#	
#	.PHONY: nti-svgalib-demos-installed
#	
#	nti-svgalib-demos-installed: nti-svgalib-demos-built ${NTI_SVGALIB_DEMOS_INSTALLED}
#	
#	${NTI_SVGALIB_DEMOS_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		mkdir -p ${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin
#		( cd ${EXTTEMP}/${NTI_SVGALIB_DEMOS_TEMP} || exit 1 ;\
#			case ${SVGALIB_DEMOS_VER} in \
#			1.4.3)	\
#				cp demos/fun ${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				[ -r demos/testgl ] && cp demos/testgl ${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				cp threeDKit/plane ${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 ;\
#				cp threeDKit/wrapdemo ${NTI_SVGALIB_DEMOS_INSTTEMP}/usr/local/bin || exit 1 \
#			;; \
#			*) \
#				echo "INSTALL: Unexpected SVGALIB_DEMOS_VER ${SVGALIB_DEMOS_VER}" 1>&2 ;\
#				exit 1 \
#			;; \
#			esac \
#		) || exit 1
#	
#	##
#	
#	.PHONY: cui-svgalib-demos
#	
#	cui-svgalib-demos: cti-cross-gcc cti-svgalib cui-uClibc-rt cui-svgalib cui-svgalib-demos-installed
#	
#	CTARGETS+= cui-svgalib-demos
#	
#	.PHONY: nti-svgalib-demos
#	
#	nti-svgalib-demos: nti-make nti-svgalib nti-svgalib-demos-installed
#	
#	NTARGETS+= nti-svgalib-demos
#	
#	endif	# HAVE_SVGALIB_DEMOS_CONFIG
