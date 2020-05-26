# sysstat 10.0.0		[ EARLIEST v4.1.7, c.2003-10-06 ]
# last mod WmT, 2011-04-04	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_SYSSTAT_CONFIG},y)
HAVE_SYSSTAT_CONFIG:=y

DESCRLIST+= "'nti-sysstat' -- sysstat"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak


SYSSTAT_VER=10.0.0
SYSSTAT_SRC=${SRCDIR}/s/sysstat-${SYSSTAT_VER}.tar.gz

#URLS+=ftp://ibiblio.org/pub/linux/system/status/sysstat-10.0.0.tar.gz
URLS+=http://pagesperso-orange.fr/sebastien.godard/sysstat-10.0.0.tar.gz


## ,-----
## |	Extract
## +-----

NTI_SYSSTAT_TEMP=nti-sysstat-${SYSSTAT_VER}

NTI_SYSSTAT_EXTRACTED=${EXTTEMP}/${NTI_SYSSTAT_TEMP}/configure

.PHONY: nti-sysstat-extracted
nti-sysstat-extracted: ${NTI_SYSSTAT_EXTRACTED}

${NTI_SYSSTAT_EXTRACTED}:
	echo "*** $@ (EXTRACT) ***"
	[ ! -d ${EXTTEMP}/${NTI_SYSSTAT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SYSSTAT_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${SYSSTAT_SRC}
	mv ${EXTTEMP}/sysstat-${SYSSTAT_VER} ${EXTTEMP}/${NTI_SYSSTAT_TEMP}


## ,-----
## |	Configure
## +-----

NTI_SYSSTAT_CONFIGURED=${EXTTEMP}/${NTI_SYSSTAT_TEMP}/config.status

.PHONY: nti-sysstat-configured
nti-sysstat-configured: nti-sysstat-extracted ${NTI_SYSSTAT_CONFIGURED}

${NTI_SYSSTAT_CONFIGURED}:
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_SYSSTAT_TEMP} || exit 1 ;\
	  CC=${NUI_CC_PREFIX}cc \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_SYSSTAT_BUILT=${EXTTEMP}/${NTI_SYSSTAT_TEMP}/sysstat

.PHONY: nti-sysstat-built
nti-sysstat-built: nti-sysstat-configured ${NTI_SYSSTAT_BUILT}

${NTI_SYSSTAT_BUILT}:
	echo "*** $@ (BUILD) ***"
	( cd ${EXTTEMP}/${NTI_SYSSTAT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_SYSSTAT_INSTALLED=${NTI_TC_ROOT}/usr/bin/cifsiostat

.PHONY: nti-sysstat-installed
nti-sysstat-installed: nti-sysstat-built ${NTI_SYSSTAT_INSTALLED}

# IGNORE_MAN_GROUP=y stops '-g' use in `install ...`
${NTI_SYSSTAT_INSTALLED}: ${NTI_SYSSTAT_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${EXTTEMP}/${NTI_SYSSTAT_TEMP} || exit 1 ;\
		make IGNORE_MAN_GROUP=y SA_DIR=${NTI_TC_ROOT}/var/log/sa RC_DIR=${NTI_TC_ROOT}/etc/rc.d SYSCONFIG_DIR=${NTI_TC_ROOT}/etc/sysconfig install || exit 1 \
	)

.PHONY: nti-sysstat
nti-sysstat: nti-sysstat-installed

NTARGETS+= nti-sysstat

endif	# HAVE_SYSSTAT_CONFIG
