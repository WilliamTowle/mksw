# ethtool v2.6.39		[ since v2.6.39, c.2011-06-29 ]
# last mod WmT, 2011-06-27	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_ETHTOOL_CONFIG},y)
HAVE_ETHTOOL_CONFIG:=y

DESCRLIST+= "'nti-ethtool' -- ethtool"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

ifneq (${HAVE_NATIVE_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
endif

#ifneq (${HAVE_CROSS_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
#endif


ETHTOOL_VER=2.6.39
ETHTOOL_SRC=${SRCDIR}/e/ethtool-2.6.39.tar.bz2

URLS+= http://www.kernel.org/pub/software/network/ethtool/ethtool-2.6.39.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_ETHTOOL_TEMP=nti-ethtool-${ETHTOOL_VER}

NTI_ETHTOOL_EXTRACTED=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/configure.in

.PHONY: nti-ethtool-extracted
nti-ethtool-extracted: ${NTI_ETHTOOL_EXTRACTED}

${NTI_ETHTOOL_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_ETHTOOL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ETHTOOL_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${ETHTOOL_SRC}
	mv ${EXTTEMP}/ethtool-${ETHTOOL_VER} ${EXTTEMP}/${NTI_ETHTOOL_TEMP}


## ,-----
## |	Configure
## +-----

NTI_ETHTOOL_CONFIGURED=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/config.status

.PHONY: nti-ethtool-configured
nti-ethtool-configured: nti-ethtool-extracted ${NTI_ETHTOOL_CONFIGURED}

${NTI_ETHTOOL_CONFIGURED}: ${NTI_ETHTOOL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  ./configure \
		  	--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_ETHTOOL_BUILT=${EXTTEMP}/${NTI_ETHTOOL_TEMP}/tftp/tftp

.PHONY: nti-ethtool-built
nti-ethtool-built: nti-ethtool-configured ${NTI_ETHTOOL_BUILT}

${NTI_ETHTOOL_BUILT}: ${NTI_ETHTOOL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_ETHTOOL_INSTALLED=${NTI_TC_ROOT}/sbin/in.tftpd

.PHONY: nti-ethtool-installed
nti-ethtool-installed: nti-ethtool-built ${NTI_ETHTOOL_INSTALLED}

${NTI_ETHTOOL_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ETHTOOL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-ethtool
nti-ethtool: nti-native-gcc nti-ethtool-installed

NTARGETS+= nti-ethtool

endif	# HAVE_ETHTOOL_CONFIG
