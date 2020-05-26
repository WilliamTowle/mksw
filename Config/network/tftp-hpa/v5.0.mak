# tftp-hpa v5.0			[ since v0.37, c.2004-06-14 ]
# last mod WmT, 2010-09-04	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_TFTPHPA_CONFIG},y)
HAVE_TFTPHPA_CONFIG:=y

DESCRIBE+= "'nti-tftphpa' -- H Peter Anvin's TFTP daemon"

TFTPHPA_VER=5.0
TFTPHPA_SRC=${SRCDIR}/t/tftp-hpa-${TFTPHPA_VER}.tar.bz2

URLS+=http://www.kernel.org/pub/software/network/tftp/tftp-hpa-${TFTPHPA_VER}.tar.bz2


## ,-----
## |	Extract
## +-----

NTI_TFTPHPA_TEMP=nti-tftphpa-${TFTPHPA_VER}

NTI_TFTPHPA_EXTRACTED=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/configure.in

.PHONY: nti-tftphpa-extracted
nti-tftphpa-extracted: ${NTI_TFTPHPA_EXTRACTED}

${NTI_TFTPHPA_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_TFTPHPA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TFTPHPA_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${TFTPHPA_SRC}
	mv ${EXTTEMP}/tftp-hpa-${TFTPHPA_VER} ${EXTTEMP}/${NTI_TFTPHPA_TEMP}


## ,-----
## |	Configure
## +-----

NTI_TFTPHPA_CONFIGURED=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/config.status

.PHONY: nti-tftphpa-configured
nti-tftphpa-configured: nti-tftphpa-extracted ${NTI_TFTPHPA_CONFIGURED}

${NTI_TFTPHPA_CONFIGURED}: ${NTI_TFTPHPA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
	  ./configure \
	  	--prefix=${NTI_TC_ROOT} \
	  	--datarootdir=${NTI_TC_ROOT} \
		--without-ipv6 \
		|| exit 1 \
	)


## ,-----
## |	Build
## +-----

NTI_TFTPHPA_BUILT=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/tftp/tftp

.PHONY: nti-tftphpa-built
nti-tftphpa-built: nti-tftphpa-configured ${NTI_TFTPHPA_BUILT}

${NTI_TFTPHPA_BUILT}: ${NTI_TFTPHPA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_TFTPHPA_INSTALLED=${NTI_TC_ROOT}/sbin/in.tftpd

.PHONY: nti-tftphpa-installed
nti-tftphpa-installed: nti-tftphpa-built ${NTI_TFTPHPA_INSTALLED}

${NTI_TFTPHPA_INSTALLED}: ${NTI_TC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
		make install datarootdir=${NTI_TC_ROOT} \
	)

.PHONY: nti-tftphpa
nti-tftphpa: nti-tftphpa-installed

NTARGETS+=nti-tftphpa

endif	# HAVE_TFTPHPA_CONFIG
