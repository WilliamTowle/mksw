# libftdi v1.2			[ since v1.2, c.2015-08-21 ]
# last mod WmT, 2015-08-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBFTDI_CONFIG},y)
HAVE_LIBFTDI_CONFIG:=y

#DESCRLIST+= "'nti-libftdi' -- libftdi"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBFTDI_VERSION},)
LIBFTDI_VERSION=1.2
endif

LIBFTDI_SRC=${SOURCES}/l/libftdi1-${LIBFTDI_VERSION}.tar.bz2
URLS+= http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.2.tar.bz2

NTI_LIBFTDI_TEMP=nti-libftdi-${LIBFTDI_VERSION}

NTI_LIBFTDI_EXTRACTED=${EXTTEMP}/${NTI_LIBFTDI_TEMP}/configure
NTI_LIBFTDI_CONFIGURED=${EXTTEMP}/${NTI_LIBFTDI_TEMP}/config.log
NTI_LIBFTDI_BUILT=${EXTTEMP}/${NTI_LIBFTDI_TEMP}/libftdi
NTI_LIBFTDI_INSTALLED=${NTI_TC_ROOT}/usr/sbin/libftdi


## ,-----
## |	Extract
## +-----

${NTI_LIBFTDI_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/libftdi-${LIBFTDI_VERSION} ] || rm -rf ${EXTTEMP}/libftdi-${LIBFTDI_VERSION}
	[ ! -d ${EXTTEMP}/libftdi1-${LIBFTDI_VERSION} ] || rm -rf ${EXTTEMP}/libftdi1-${LIBFTDI_VERSION}
	bzcat ${LIBFTDI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBFTDI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBFTDI_TEMP}
	#mv ${EXTTEMP}/libftdi-${LIBFTDI_VERSION} ${EXTTEMP}/${NTI_LIBFTDI_TEMP}
	mv ${EXTTEMP}/libftdi1-${LIBFTDI_VERSION} ${EXTTEMP}/${NTI_LIBFTDI_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBFTDI_CONFIGURED}: ${NTI_LIBFTDI_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBFTDI_TEMP} || exit 1 ;\
		cmake -DCMAKE_INSTALL_PREFIX=${NTI_TC_ROOT}'/usr' ./ \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBFTDI_BUILT}: ${NTI_LIBFTDI_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBFTDI_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBFTDI_INSTALLED}: ${NTI_LIBFTDI_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBFTDI_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libftdi
nti-libftdi: ${NTI_LIBFTDI_INSTALLED}

ALL_NTI_TARGETS+= nti-libftdi

endif	# HAVE_LIBFTDI_CONFIG
