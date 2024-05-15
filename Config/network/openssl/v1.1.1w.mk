# openssl v1.1.1w		[ since v0.9.7b, c.2003-05-28 ]
# last mod WmT, 2024-05-15	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_OPENSSL_CONFIG},y)
HAVE_OPENSSL_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${OPENSSL_VERSION},)
#OPENSSL_VERSION=1.0.2h
#OPENSSL_VERSION=1.1.0e
#OPENSSL_VERSION=1.1.0h
OPENSSL_VERSION=1.1.1w
endif

OPENSSL_SRC=${DIR_DOWNLOADS}/o/openssl-${OPENSSL_VERSION}.tar.gz
# Sources: See also ftp://ftp.openssl.org/source/old/
OPENSSL_URL+= http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
##|#include ${CFG_ROOT}/perl/perl/v5.18.2.mak
##|include ${CFG_ROOT}/perl/perl/v5.18.4.mak
#|include ${CFG_ROOT}/misc/zlib/v1.2.8.mak
include ${MF_CONFIGDIR}/misc/zlib/v1.3.1.mk


NTI_OPENSSL_TEMP=${DIR_EXTTEMP}/nti-openssl-${OPENSSL_VERSION}

NTI_OPENSSL_EXTRACTED=${NTI_OPENSSL_TEMP}/README
NTI_OPENSSL_CONFIGURED=${NTI_OPENSSL_TEMP}/Makefile.NEW
NTI_OPENSSL_BUILT=${NTI_OPENSSL_TEMP}/libssl.pc
#NTI_OPENSSL_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/openssl.pc
NTI_OPENSSL_INSTALLED=${PKG_CONFIG_CONFIG_HOST_PATH}/openssl.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-openssl-uriurl:
	@echo "${OPENSSL_SRC} ${OPENSSL_URL}"

show-all-uriurl:: show-nti-openssl-uriurl


${NTI_OPENSSL_EXTRACTED}: | nti-sanity ${OPENSSL_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_OPENSSL_TEMP} ARCHIVES=${OPENSSL_SRC} EXTRACT_OPTS='--strip-components=1'


## [2014-04-12] i686 case: not linux-elf, or bad options
## [2014-05-29] LFS suggests 'shared zlib-dynamic' is sufficient
## [2014-05-29] x86_64 case: needs 'Configure' due to dubious defaults
## `./Configure linux-generic32 386 shared zlib-dynamic no-rc5 no-idea`?

${NTI_OPENSSL_CONFIGURED}: ${NTI_OPENSSL_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		case "${NUI_HOST_CPU}" in \
		i686|armv7l) \
			./Configure linux-generic32 386 shared no-idea no-mdc2 no-rc5 zlib-dynamic \
				--with-zlib-include=${DIR_NTI_TOOLCHAIN}/usr/include \
				--with-zlib-lib=${DIR_NTI_TOOLCHAIN}/usr/lib \
				|| exit 1 \
		 ;; \
		x86_64) \
			./Configure linux-${NUI_HOST_CPU} shared no-idea no-mdc2 no-rc5 zlib-dynamic || exit 1 \
		;; \
		*) \
			printf '%s\n' "Unexpected NUI_HOST_CPU '${NUI_HOST_CPU}'" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INSTALLTOP[= ]/ s%/usr.*%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^OPENSSLDIR[= ]/ s%/usr.*%'${DIR_NTI_TOOLCHAIN}'/usr/local/ssl%' \
			| sed '/^CFLAGS[= ]/	s%=%= -I'${DIR_NTI_TOOLCHAIN}'/usr/include %' \
			| sed '/^	/	s%$$(libdir)/pkgconfig%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> Makefile.NEW ;\
		case ${OPENSSL_VERSION} in \
		1.0.1[fg]) \
			sed '/^install:/	s/install_docs//' Makefile.NEW > Makefile \
		;; \
		1.1.0[eh]) \
			cat Makefile.NEW \
				| sed '/^ENGINESDIR/	s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr%' \
				| sed '/^install:/	s/install_docs//' \
				> Makefile \
		;; \
		*) \
			cp Makefile.NEW Makefile \
		;; \
		esac \
	)



${NTI_OPENSSL_BUILT}: ${NTI_OPENSSL_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_OPENSSL_TEMP} && make )


${NTI_OPENSSL_INSTALLED}: ${NTI_OPENSSL_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_OPENSSL_TEMP} && make install )

#

USAGE_TEXT+= "'nti-openssl' - build openssl for NTI toolchain"

.PHONY: nti-openssl
nti-openssl: nti-pkg-config nti-zlib ${NTI_OPENSSL_INSTALLED}


all-nti-targets:: nti-openssl


endif	# HAVE_OPENSSL_CONFIG
