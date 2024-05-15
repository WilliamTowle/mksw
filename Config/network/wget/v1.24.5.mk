# wget v1.24.5			[ since v1.8.2, c.2003-06-07 ]
# last mod WmT, 2024-04-25	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_WGET_CONFIG},y)
HAVE_WGET_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${WGET_VERSION},)
#WGET_VERSION=1.10.2
#WGET_VERSION=1.13.4
#WGET_VERSION=1.15
#WGET_VERSION=1.16.2
#WGET_VERSION=1.17.1
#WGET_VERSION=1.18
#WGET_VERSION=1.19
#WGET_VERSION=1.19.5
WGET_VERSION=1.24.5
endif

WGET_HTTPS_SUPPORT?=y

WGET_SRC=${DIR_DOWNLOADS}/w/wget-${WGET_VERSION}.tar.gz
WGET_URL=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/wget/wget-${WGET_VERSION}.tar.gz


# Dependencies
## TODO: optional dependency on openssl/gnutls
## ...gnutls v3.1.5 via mirrorservice.org
ifeq (${WGET_HTTPS_SUPPORT},y)
# nti-pkg-config iff we have library dependencies?
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/network/openssl/v1.1.1w.mk
endif

NTI_WGET_TEMP=${DIR_EXTTEMP}/nti-wget-${WGET_VERSION}

NTI_WGET_EXTRACTED=${NTI_WGET_TEMP}/configure
NTI_WGET_CONFIGURED=${NTI_WGET_TEMP}/config.status
NTI_WGET_BUILT=${NTI_WGET_TEMP}/src/wget
NTI_WGET_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/wget


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-wget-uriurl:
	@echo "${WGET_SRC} ${WGET_URL}"

show-all-uriurl:: show-nti-wget-uriurl


${NTI_WGET_EXTRACTED}: | nti-sanity ${WGET_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_WGET_TEMP} ARCHIVES=${WGET_SRC} EXTRACT_OPTS='--strip-components=1'


## [v1.15] added --without-ssl (optional: --with-ssl={gnutls,openssl})

${NTI_WGET_CONFIGURED}: ${NTI_WGET_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_WGET_TEMP} || exit 1 ;\
		case ${WGET_VERSION} in \
		1.10.2) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/SUBDIRS/ s/ po / /' \
				| sed '/install:/,/^$$/ s/install.mo//' \
				> Makefile \
		;; \
		esac ;\
		case ${WGET_VERSION} in \
		1.1[0-4]*) \
			CC=${NTI_GCC} \
			    CFLAGS='-O2' \
				./configure \
					--prefix=${DIR_NTI_TOOLCHAIN}/usr \
					|| exit 1 \
		;; \
		1.1[5-9]*|1.24.5) \
			CC=${NTI_GCC} \
			    CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
				./configure \
					--prefix=${DIR_NTI_TOOLCHAIN}/usr \
					$(shell [ "${WGET_HTTPS_SUPPORT}" = 'y' ] && echo '--with-ssl=openssl' )$(shell [ "${WGET_HTTPS_SUPPORT}" = 'n' ] && echo '--without-ssl' ) \
					|| exit 1 \
		;; \
		*) \
			printf '%s\n' "Unexpected WGET_VERSION '${WGET_VERSION}'" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)

${NTI_WGET_BUILT}: ${NTI_WGET_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_WGET_TEMP} || exit 1 ;\
		make \
	)

${NTI_WGET_INSTALLED}: ${NTI_WGET_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_WGET_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-wget' - build wget for NTI toolchain"

.PHONY: nti-wget
ifeq (${WGET_HTTPS_SUPPORT},y)
nti-wget: nti-pkg-config ${NTI_WGET_INSTALLED}
else
nti-wget: ${NTI_WGET_INSTALLED}
endif


all-nti-targets:: nti-wget

endif	# HAVE_WGET_CONFIG
