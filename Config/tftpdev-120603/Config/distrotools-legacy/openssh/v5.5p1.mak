# openssh v5.5p1		[ since v3.6.1p2, c.2003-06-05 ]
# last mod WmT, 2010-07-16	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_OPENSSH_CONFIG},y)
HAVE_OPENSSH_CONFIG:=y

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/distrotools-legacy/openssl/v1.0.0a.mak
include ${CFG_ROOT}/distrotools-legacy/zlib/v1.2.5.mak

DESCRLIST+= "'nti-openssh' -- openssh"

OPENSSH_VER=5.5p1
OPENSSH_SRC=${SRCDIR}/o/openssh-5.5p1.tar.gz

URLS+=ftp://ftp.mirrorservice.org/pub/OpenBSD/OpenSSH/portable/openssh-5.5p1.tar.gz

## ,-----
## |	package extract
## +-----


NTI_OPENSSH_TEMP=nti-openssh-${OPENSSH_VER}

CUI_OPENSSH_TEMP=cui-openssh-${OPENSSH_VER}
CUI_OPENSSH_INSTTEMP=${EXTTEMP}/insttemp


NTI_OPENSSH_EXTRACTED=${EXTTEMP}/${NTI_OPENSSH_TEMP}/Makefile

.PHONY: nti-openssh-extracted
nti-openssh-extracted: ${NTI_OPENSSH_EXTRACTED}

${NTI_OPENSSH_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_OPENSSH_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENSSH_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${OPENSSH_SRC}
	mv ${EXTTEMP}/openssh-${OPENSSH_VER} ${EXTTEMP}/${NTI_OPENSSH_TEMP}


CUI_OPENSSH_EXTRACTED=${EXTTEMP}/${CUI_OPENSSH_TEMP}/Makefile

.PHONY: cui-openssh-extracted
cui-openssh-extracted: ${CUI_OPENSSH_EXTRACTED}

${CUI_OPENSSH_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_OPENSSH_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_OPENSSH_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${OPENSSH_SRC}
	mv ${EXTTEMP}/openssh-${OPENSSH_VER} ${EXTTEMP}/${CUI_OPENSSH_TEMP}

## ,-----
## |	package configure
## +-----


NTI_OPENSSH_CONFIGURED=${EXTTEMP}/${NTI_OPENSSH_TEMP}/config.status

.PHONY: nti-openssh-configured
nti-openssh-configured: nti-openssh-extracted ${NTI_OPENSSH_CONFIGURED}

${NTI_OPENSSH_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure \
			  --prefix=${HTC_ROOT}/usr \
			  || exit 1 \
	)


CUI_OPENSSH_CONFIGURED=${EXTTEMP}/${CUI_OPENSSH_TEMP}/config.status

.PHONY: cui-openssh-configured
cui-openssh-configured: cui-openssh-extracted ${CUI_OPENSSH_CONFIGURED}

${CUI_OPENSSH_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSH_TEMP} || exit 1 ;\
		CC=${CTI_GCC} \
		  CFLAGS='-O2' \
		  ./configure \
			--prefix=/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			--with-x=no \
			|| exit 1 \
	)

## ,-----
## |	package build
## +-----


NTI_OPENSSH_BUILT=${EXTTEMP}/${NTI_OPENSSH_TEMP}/sftp

.PHONY: nti-openssh-built
nti-openssh-built: nti-openssh-configured ${NTI_OPENSSH_BUILT}

${NTI_OPENSSH_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		make \
	)


CUI_OPENSSH_BUILT=${EXTTEMP}/${CUI_OPENSSH_TEMP}/sftp

.PHONY: cui-openssh-built
cui-openssh-built: cui-openssh-configured ${CUI_OPENSSH_BUILT}

${CUI_OPENSSH_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSH_TEMP} || exit 1 ;\
		make \
	)

## ,-----
## |	package install
## +-----


NTI_OPENSSH_INSTALLED=${HTC_ROOT}/usr/bin/sftp

.PHONY: nti-openssh-installed
nti-openssh-installed: nti-openssh-built ${NTI_OPENSSH_INSTALLED}

${NTI_OPENSSH_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSH_TEMP} || exit 1 ;\
		make install || exit 1 \
	)


CUI_OPENSSH_INSTALLED=${CUI_OPENSSH_INSTTEMP}/usr/bin/sftp

.PHONY: cui-openssh-installed
cui-openssh-installed: cui-openssh-built ${CUI_OPENSSH_INSTALLED}

${CUI_OPENSSH_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_OPENSSH_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_OPENSSH_INSTTEMP} install || exit 1 \
	)

.PHONY: nti-openssh
nti-openssh: nti-zlib nti-openssh-installed

.PHONY: cui-openssh
cui-openssh: cti-cross-gcc cti-zlib cti-openssl cui-uClibc-rt cui-zlib cui-openssh-installed


TARGETS+= cui-openssh

endif	# HAVE_OPENSSH_CONFIG
