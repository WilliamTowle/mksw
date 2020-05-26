# coreutils v5.97		[ EARLIEST v5.0, c.2003-04-06 ]
# last mod WmT, 2010-08-23	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_COREUTILS_CONFIG},y)
HAVE_COREUTILS_CONFIG:=y

DESCRLIST+= "'nti-coreutils' -- coreutils"

## TODO: needs headers, libraries at runtime

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak

COREUTILS_VER:=5.97
COREUTILS_SRC=${SRCDIR}/c/coreutils-5.97.tar.bz2
COREUTILS_PATCHES=

URLS+=http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/coreutils/coreutils-5.97.tar.bz2


# ,-----
# |	Extract
# +-----

NTI_COREUTILS_TEMP=nti-coreutils-${COREUTILS_VER}
NTI_COREUTILS_INSTTEMP=${NTI_TC_ROOT}/

NTI_COREUTILS_EXTRACTED=${EXTTEMP}/${NTI_COREUTILS_TEMP}/configure

.PHONY: nti-coreutils-extracted

nti-coreutils-extracted: ${NTI_COREUTILS_EXTRACTED}

${NTI_COREUTILS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${NTI_COREUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_COREUTILS_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${COREUTILS_SRC}
ifneq (${COREUTILS_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${COREUTILS_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${COREUTILS_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/coreutils-${COREUTILS_VER} ${EXTTEMP}/${NTI_COREUTILS_TEMP}


# ,-----
# |	Configure
# +-----

NTI_COREUTILS_CONFIGURED=${EXTTEMP}/${NTI_COREUTILS_TEMP}/config.status

.PHONY: nti-coreutils-configured

nti-coreutils-configured: nti-coreutils-extracted ${NTI_COREUTILS_CONFIGURED}

${NTI_COREUTILS_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
	  CC=${NUI_CC_PREFIX}cc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  --without-included-regex \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

NTI_COREUTILS_BUILT=${EXTTEMP}/${NTI_COREUTILS_TEMP}/src/df

.PHONY: nti-coreutils-built
nti-coreutils-built: nti-coreutils-configured ${NTI_COREUTILS_BUILT}

${NTI_COREUTILS_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1




# ,-----
# |	Install
# +-----

NTI_COREUTILS_INSTALLED=${NTI_COREUTILS_INSTTEMP}/usr/bin/df

.PHONY: nti-coreutils-installed

nti-coreutils-installed: nti-coreutils-built ${NTI_COREUTILS_INSTALLED}

${NTI_COREUTILS_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
		make install || exit 1 \
	) || exit 1


.PHONY: nti-coreutils
nti-coreutils: nti-coreutils-installed

TARGETS+= nti-coreutils

endif	# HAVE_COREUTILS_CONFIG
