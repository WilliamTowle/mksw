# tftp-hpa v5.1			[ since v0.37, c.2004-06-14 ]
# last mod WmT, 2013-02-21	[ (c) and GPLv2 1999-2013* ]

#ifneq (${HAVE_TFTPHPA_CONFIG},y)
#HAVE_TFTPHPA_CONFIG:=y
#
##DESCRLIST+= "'nti-tftphpa' -- H Peter Anvin's TFTP daemon"
#
##TFTPHPA_VER=5.0
#TFTPHPA_VER=5.1
#TFTPHPA_SRC=${SRCDIR}/t/tftp-hpa-${TFTPHPA_VER}.tar.bz2
#
#URLS+=http://www.kernel.org/pub/software/network/tftp/tftp-hpa-${TFTPHPA_VER}.tar.bz2
#
#
### ,-----
### |	Extract
### +-----
#
#NTI_TFTPHPA_TEMP=nti-tftphpa-${TFTPHPA_VER}
#
#NTI_TFTPHPA_EXTRACTED=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/configure.in
#
#.PHONY: nti-tftphpa-extracted
#nti-tftphpa-extracted: ${NTI_TFTPHPA_EXTRACTED}
#
#${NTI_TFTPHPA_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${NTI_TFTPHPA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TFTPHPA_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${TFTPHPA_SRC}
#	mv ${EXTTEMP}/tftp-hpa-${TFTPHPA_VER} ${EXTTEMP}/${NTI_TFTPHPA_TEMP}
#
#
### ,-----
### |	Configure
### +-----
#
#NTI_TFTPHPA_CONFIGURED=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/config.status
#
#.PHONY: nti-tftphpa-configured
#nti-tftphpa-configured: nti-tftphpa-extracted ${NTI_TFTPHPA_CONFIGURED}
#
#${NTI_TFTPHPA_CONFIGURED}: ${NTI_TFTPHPA_EXTRACTED}
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
#		CC=${NTI_GCC} \
#		  ./configure \
#		  	--prefix=${NTI_TC_ROOT} \
#		  	--datarootdir=${NTI_TC_ROOT} \
#			--without-ipv6 \
#			|| exit 1 \
#	)
#
#
### ,-----
### |	Build
### +-----
#
#NTI_TFTPHPA_BUILT=${EXTTEMP}/${NTI_TFTPHPA_TEMP}/tftp/tftp
#
#.PHONY: nti-tftphpa-built
#nti-tftphpa-built: nti-tftphpa-configured ${NTI_TFTPHPA_BUILT}
#
#${NTI_TFTPHPA_BUILT}: ${NTI_TFTPHPA_CONFIGURED}
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
#		make \
#	)
#
#
### ,-----
### |	Install
### +-----
#
#NTI_TFTPHPA_INSTALLED=${NTI_TC_ROOT}/sbin/in.tftpd
#
#.PHONY: nti-tftphpa-installed
#nti-tftphpa-installed: nti-tftphpa-built ${NTI_TFTPHPA_INSTALLED}
#
#${NTI_TFTPHPA_INSTALLED}: ${NTI_TC_ROOT}
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_TFTPHPA_TEMP} || exit 1 ;\
#		make install datarootdir=${NTI_TC_ROOT} \
#	)
#
#.PHONY: nti-tftphpa
#nti-tftphpa: nti-tftphpa-installed
#
#NTARGETS+= nti-tftphpa
#
#endif	# HAVE_TFTPHPA_CONFIG

# tftp-hpa v2.4.4			[ EARLIEST v2.4.4, 2013-02-21 ]
# last mod WmT, 2013-02-21	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_TFTP_HPA_CONFIG},y)
HAVE_TFTP_HPA_CONFIG:=y

#DESCRLIST+= "'nti-tftp-hpa' -- tftp-hpa"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TFTP_HPA_VERSION},)
#TFTPHPA_VERSION=5.0
#TFTPHPA_VERSION=5.1
TFTP_HPA_VERSION=5.2
endif

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak

TFTP_HPA_SRC=${SOURCES}/t/tftp-hpa-${TFTP_HPA_VERSION}.tar.bz2
URLS+=http://www.kernel.org/pub/software/network/tftp/tftp-hpa-${TFTPHPA_VERSION}.tar.bz2

NTI_TFTP_HPA_TEMP=nti-tftp-hpa-${TFTP_HPA_VERSION}

NTI_TFTP_HPA_EXTRACTED=${EXTTEMP}/${NTI_TFTP_HPA_TEMP}/configure.in
NTI_TFTP_HPA_CONFIGURED=${EXTTEMP}/${NTI_TFTP_HPA_TEMP}/config.status
NTI_TFTP_HPA_BUILT=${EXTTEMP}/${NTI_TFTP_HPA_TEMP}/tftp/tftp
NTI_TFTP_HPA_INSTALLED=${NTI_TC_ROOT}/sbin/in.tftpd


## ,-----
## |	Extract
## +-----

${NTI_TFTP_HPA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tftp-hpa-${TFTP_HPA_VERSION} ] || rm -rf ${EXTTEMP}/tftp-hpa-${TFTP_HPA_VERSION}
	bzcat ${TFTP_HPA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TFTP_HPA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TFTP_HPA_TEMP}
	mv ${EXTTEMP}/tftp-hpa-${TFTP_HPA_VERSION} ${EXTTEMP}/${NTI_TFTP_HPA_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TFTP_HPA_CONFIGURED}: ${NTI_TFTP_HPA_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TFTP_HPA_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
		  	--prefix=${NTI_TC_ROOT} \
		  	--datarootdir=${NTI_TC_ROOT} \
			--without-ipv6 \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_TFTP_HPA_BUILT}: ${NTI_TFTP_HPA_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TFTP_HPA_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_TFTP_HPA_INSTALLED}: ${NTI_TFTP_HPA_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TFTP_HPA_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-tftp-hpa
nti-tftp-hpa: ${NTI_TFTP_HPA_INSTALLED}
#nti-tftp-hpa: nti-libtool ${NTI_TFTP_HPA_INSTALLED}

ALL_NTI_TARGETS+= nti-tftp-hpa

endif	# HAVE_TFTP_HPA_CONFIG
