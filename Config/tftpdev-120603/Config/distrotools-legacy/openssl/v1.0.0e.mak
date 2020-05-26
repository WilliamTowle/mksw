# openssl v1.0.0e		[ since v0.9.7b, c.2003-05-28 ]
# last mod WmT, 2011-09-13	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_OPENSSL_CONFIG},y)
HAVE_OPENSSL_CONFIG:=y

DESCRLIST+= "'nti-openssl' -- openssl"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/misc/zlib/v1.2.5.mak

#OPENSSL_VER=1.0.0a
OPENSSL_VER=1.0.0e
OPENSSL_SRC=${SRCDIR}/o/openssl-${OPENSSL_VER}.tar.gz

URLS+= http://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz


# ,-----
# |	Extract
# +-----

NTI_OPENSSL_TEMP=nti-openssl-${OPENSSL_VER}

CTI_OPENSSL_TEMP=cti-openssl-${OPENSSL_VER}
CTI_OPENSSL_INSTTEMP=${CUI_TC_ROOT}/usr/${CTI_SPEC}/usr

CUI_OPENSSL_TEMP=cui-openssl-${OPENSSL_VER}
CUI_OPENSSL_INSTTEMP=${EXTTEMP}/insttemp


NTI_OPENSSL_EXTRACTED=${EXTTEMP}/${NTI_OPENSSL_TEMP}/Makefile

.PHONY: nti-openssl-extracted
nti-openssl-extracted: ${NTI_OPENSSL_EXTRACTED}

${NTI_OPENSSL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_OPENSSL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENSSL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${OPENSSL_SRC}
	mv ${EXTTEMP}/openssl-${OPENSSL_VER} ${EXTTEMP}/${NTI_OPENSSL_TEMP}

##

CTI_OPENSSL_EXTRACTED=${EXTTEMP}/${CTI_OPENSSL_TEMP}/Makefile

.PHONY: cti-openssl-extracted
cti-openssl-extracted: ${CTI_OPENSSL_EXTRACTED}

${CTI_OPENSSL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CTI_OPENSSL_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_OPENSSL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${OPENSSL_SRC}
	mv ${EXTTEMP}/openssl-${OPENSSL_VER} ${EXTTEMP}/${CTI_OPENSSL_TEMP}


##

CUI_OPENSSL_EXTRACTED=${EXTTEMP}/${CUI_OPENSSL_TEMP}/Makefile

.PHONY: cui-openssl-extracted
cui-openssl-extracted: ${CUI_OPENSSL_EXTRACTED}

${CUI_OPENSSL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_OPENSSL_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_OPENSSL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${OPENSSL_SRC}
	mv ${EXTTEMP}/openssl-${OPENSSL_VER} ${EXTTEMP}/${CUI_OPENSSL_TEMP}


# ,-----
# |	Configure
# +-----

NTI_OPENSSL_CONFIGURED=${EXTTEMP}/${NTI_OPENSSL_TEMP}/Makefile.OLD

.PHONY: nti-openssl-configured
nti-openssl-configured: nti-openssl-extracted ${NTI_OPENSSL_CONFIGURED}

${NTI_OPENSSL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[= ]/	s%g*cc%'${NTI_GCC}'%' \
			| sed '/^AR[= ]/	s%ar%'`echo ${NTI_GCC} | sed 's/gcc$$/ar/'`'%' \
			| sed '/^NM[= ]/	s%nm%'`echo ${NTI_GCC} | sed 's/gcc$$/nm/'`'%' \
			| sed '/^RANLIB[= ]/	s%/.*%'`echo ${NTI_GCC} | sed 's/gcc$$/ranlib/'`'%' \
			| sed '/^INSTALLTOP[= ]/ s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^OPENSSLDIR[= ]/ s%/usr.*%'${NTI_TC_ROOT}'/usr/local/ssl%' \
			| sed '/^PROCESSOR *=/ s/=.*/='${NUI_CPU}'/' \
			> Makefile \
	)

##

#CTI_OPENSSL_CONFIGURED=${EXTTEMP}/${CTI_OPENSSL_TEMP}/Makefile.OLD
CTI_OPENSSL_CONFIGURED=${EXTTEMP}/${CTI_OPENSSL_TEMP}/crypto/bio/bss_file.c.OLD

.PHONY: cti-openssl-configured
cti-openssl-configured: cti-openssl-extracted ${CTI_OPENSSL_CONFIGURED}

${CTI_OPENSSL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_OPENSSL_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[= ]/	s%g*cc%'${CTI_GCC}'%' \
			| sed '/^AR[= ]/	s%ar%'`echo ${CTI_GCC} | sed 's/gcc$$/ar/'`'%' \
			| sed '/^NM[= ]/	s%nm%'`echo ${CTI_GCC} | sed 's/gcc$$/nm/'`'%' \
			| sed '/^RANLIB[= ]/	s%/.*%'`echo ${CTI_GCC} | sed 's/gcc$$/ranlib/'`'%' \
			| sed '/^INSTALL_PREFIX[= ]/	s%$$%'${CTI_OPENSSL_INSTTEMP}'%' \
			| sed '/^PROCESSOR *=/ s/=.*/='${CTI_CPU}'/' \
			| sed '/^	/	s%\$$(INSTALLTOP)/\$$(LIBDIR)/pkgconfig%/usr/lib/'${CTI_SPEC}'-pkgconfig/%' \
			> Makefile ;\
		[ -r crypto/bio/bss_file.c.OLD ] || mv crypto/bio/bss_file.c crypto/bio/bss_file.c.OLD || exit 1 ;\
		cat crypto/bio/bss_file.c.OLD \
			| sed '/define _FILE_OFFSET_BITS/ s/64/32/' \
			> crypto/bio/bss_file.c \
	)


##

CUI_OPENSSL_CONFIGURED=${EXTTEMP}/${CUI_OPENSSL_TEMP}/crypto/bio/bss_file.c.OLD

.PHONY: cui-openssl-configured
cui-openssl-configured: cui-openssl-extracted ${CUI_OPENSSL_CONFIGURED}

${CUI_OPENSSL_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSL_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC[= ]/	s%g*cc%'${CTI_GCC}'%' \
			| sed '/^AR[= ]/	s%ar%'`echo ${CTI_GCC} | sed 's/gcc$$/ar/'`'%' \
			| sed '/^NM[= ]/	s%nm%'`echo ${CTI_GCC} | sed 's/gcc$$/nm/'`'%' \
			| sed '/^RANLIB[= ]/	s%/.*%'`echo ${CTI_GCC} | sed 's/gcc$$/ranlib/'`'%' \
			| sed '/^INSTALL_PREFIX[= ]/	s%$$%'${CUI_OPENSSL_INSTTEMP}'%' \
			| sed '/^PROCESSOR *=/ s/=.*/='${CTI_CPU}'/' \
			| sed '/^	/	s%\$$(INSTALLTOP)/\$$(LIBDIR)/pkgconfig%/usr/lib/'${CTI_SPEC}'-pkgconfig/%' \
			> Makefile ;\
		[ -r crypto/bio/bss_file.c.OLD ] || mv crypto/bio/bss_file.c crypto/bio/bss_file.c.OLD || exit 1 ;\
		cat crypto/bio/bss_file.c.OLD \
			| sed '/define _FILE_OFFSET_BITS/ s/64/32/' \
			> crypto/bio/bss_file.c \
	)


# ,-----
# |	Build
# +-----

NTI_OPENSSL_BUILT=${EXTTEMP}/${NTI_OPENSSL_TEMP}/libssl.pc

.PHONY: nti-openssl-built
nti-openssl-built: nti-openssl-configured ${NTI_OPENSSL_BUILT}

${NTI_OPENSSL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		make \
	)

##

CTI_OPENSSL_BUILT=${EXTTEMP}/${CTI_OPENSSL_TEMP}/libssl.pc

.PHONY: cti-openssl-built
cti-openssl-built: cti-openssl-configured ${CTI_OPENSSL_BUILT}

${CTI_OPENSSL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_OPENSSL_TEMP} || exit 1 ;\
		make \
	)

##

CUI_OPENSSL_BUILT=${EXTTEMP}/${CUI_OPENSSL_TEMP}/libssl.pc

.PHONY: cui-openssl-built
cui-openssl-built: cui-openssl-configured ${CUI_OPENSSL_BUILT}

${CUI_OPENSSL_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSL_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

NTI_OPENSSL_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/openssl.pc

.PHONY: nti-openssl-installed
nti-openssl-installed: nti-openssl-built ${NTI_OPENSSL_INSTALLED}

${NTI_OPENSSL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

##

CTI_OPENSSL_INSTALLED=${CTI_TC_ROOT}/usr/lib/${CTI_SPEC}-pkgconfig/openssl.pc

.PHONY: cti-openssl-installed
cti-openssl-installed: cti-openssl-built ${CTI_OPENSSL_INSTALLED}

${CTI_OPENSSL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_OPENSSL_TEMP} || exit 1 ;\
		make INSTALL_PREFIX=${CTI_TC_ROOT} INSTALLTOP=/usr/${CTI_SPEC}/usr install || exit 1 \
	)

##

CUI_OPENSSL_INSTALLED=${CUI_OPENSSL_INSTTEMP}/usr/lib/pkgconfig/openssl.pc

.PHONY: cui-openssl-installed
cui-openssl-installed: cui-openssl-built ${CUI_OPENSSL_INSTALLED}

${CUI_OPENSSL_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSL_TEMP} || exit 1 ;\
		make INSTALL_PREFIX=${CUI_OPENSSL_INSTTEMP} install || exit 1 \
	)

##

.PHONY: nti-openssl
nti-openssl: nti-native-gcc nti-zlib nti-openssl-installed

NTARGETS+= nti-openssl

.PHONY: cti-openssl
cti-openssl: cti-cross-gcc cti-openssl-installed

.PHONY: cui-openssl
cui-openssl: cti-cross-gcc cui-openssl-installed

CTARGETS+= cui-openssl

endif	# HAVE_OPENSSL_CONFIG
