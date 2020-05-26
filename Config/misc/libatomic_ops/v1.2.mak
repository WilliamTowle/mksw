# libatomic_ops v1.14		[ since v1.2, c.2014-08-23 ]
# last mod WmT, 2014-08-23	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_LIBATOMIC_OPS},y)
HAVE_LIBATOMIC_OPS:=y

#DESCRLIST+= "'nti-libatomic_ops' -- libatomic_ops"

ifeq (${LIBATOMIC_OPS_VERSION},)
LIBATOMIC_OPS_VERSION=1.2
endif

LIBATOMIC_OPS_SRC=${SOURCES}/l/libatomic_ops-${LIBATOMIC_OPS_VERSION}.tar.gz
URLS+= http://www.hpl.hp.com/research/linux/atomic_ops/download/libatomic_ops-1.2.tar.gz

NTI_LIBATOMIC_OPS_TEMP=nti-libatomic_ops-${LIBATOMIC_OPS_VERSION}

NTI_LIBATOMIC_OPS_EXTRACTED=${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP}/README
NTI_LIBATOMIC_OPS_CONFIGURED=${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP}/config.status
NTI_LIBATOMIC_OPS_BUILT=${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP}/src/atomic_ops
NTI_LIBATOMIC_OPS_INSTALLED=${NTI_TC_ROOT}/usr/lib/libatomic_ops.a



## ,-----
## |	Extract
## +-----

${NTI_LIBATOMIC_OPS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/libatomic_ops-${LIBATOMIC_OPS_VERSION} ] || rm -rf ${EXTTEMP}/libatomic_ops-${LIBATOMIC_OPS_VERSION}
	zcat ${LIBATOMIC_OPS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP}
	mv ${EXTTEMP}/libatomic_ops-${LIBATOMIC_OPS_VERSION} ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBATOMIC_OPS_CONFIGURED}: ${NTI_LIBATOMIC_OPS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-largefile --disable-nls \
			|| exit 1 \
	)
#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Build
## +-----

${NTI_LIBATOMIC_OPS_BUILT}: ${NTI_LIBATOMIC_OPS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP} || exit 1 ;\
		make all \
	)
#	LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_LIBATOMIC_OPS_INSTALLED}: ${NTI_LIBATOMIC_OPS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LIBATOMIC_OPS_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-libatomic_ops
nti-libatomic_ops: ${NTI_LIBATOMIC_OPS_INSTALLED}

ALL_NTI_TARGETS+= nti-libatomic_ops

endif	# HAVE_LIBATOMIC_OPS_CONFIG
