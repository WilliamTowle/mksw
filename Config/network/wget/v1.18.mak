# wget v1.18			[ since v1.8.2, c.2003-06-07 ]
# last mod WmT, 2016-06-15	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_WGET_CONFIG},y)
HAVE_WGET_CONFIG:=y

#DESCRLIST+= "'nti-wget' -- wget"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${WGET_VERSION},)
#WGET_VERSION=1.10.2
#WGET_VERSION=1.13.4
#WGET_VERSION=1.15
#WGET_VERSION=1.16.2
#WGET_VERSION=1.17.1
WGET_VERSION=1.18
endif

WGET_SRC=${SOURCES}/w/wget-${WGET_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/wget/wget-${WGET_VERSION}.tar.gz


NTI_WGET_TEMP=nti-wget-${WGET_VERSION}

NTI_WGET_EXTRACTED=${EXTTEMP}/${NTI_WGET_TEMP}/configure
NTI_WGET_CONFIGURED=${EXTTEMP}/${NTI_WGET_TEMP}/config.status
NTI_WGET_BUILT=${EXTTEMP}/${NTI_WGET_TEMP}/src/wget
NTI_WGET_INSTALLED=${NTI_TC_ROOT}/usr/bin/wget


## ,-----
## |	Extract
## +-----

${NTI_WGET_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/wget-${WGET_VERSION} ] || rm -rf ${EXTTEMP}/wget-${WGET_VERSION}
	zcat ${WGET_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_WGET_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WGET_TEMP}
	mv ${EXTTEMP}/wget-${WGET_VERSION} ${EXTTEMP}/${NTI_WGET_TEMP}


## ,-----
## |	Configure
## +-----

## [v1.15] --without-ssl (or: --with-ssl={gnutls,openssl})

${NTI_WGET_CONFIGURED}: ${NTI_WGET_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_WGET_TEMP} || exit 1 ;\
		  CC=${NTI_GCC} \
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--without-ssl \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_WGET_BUILT}: ${NTI_WGET_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_WGET_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_WGET_INSTALLED}: ${NTI_WGET_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_WGET_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-wget
nti-wget: ${NTI_WGET_INSTALLED}

ALL_NTI_TARGETS+= nti-wget

endif	# HAVE_WGET_CONFIG
