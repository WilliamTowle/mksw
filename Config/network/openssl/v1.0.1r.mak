# openssl v1.0.1r		[ since v0.9.7b, c.2003-05-28 ]
# last mod WmT, 2016-01-29	[ (c) and GPLv2 1999-2015* ]

## 2014-01-20: bad POD breaks 'install_docs' rule (v1.0.1f)
## 2014-04-08: SHOULD build with -DOPENSSL_NO_HEARTBEATS for <= v1.0.1g
## 2015-07-10: 1.0.1n+ obsoleted by 1.0.1p

ifneq (${HAVE_OPENSSL_CONFIG},y)
HAVE_OPENSSL_CONFIG:=y

#DESCRLIST+= "'nti-openssl' -- openssl"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${OPENSSL_VERSION},)
#OPENSSL_VERSION= 1.0.1j
#OPENSSL_VERSION= 1.0.1m
#OPENSSL_VERSION= 1.0.1p
#OPENSSL_VERSION= 1.0.1q
OPENSSL_VERSION= 1.0.1r
endif

OPENSSL_SRC=${SOURCES}/o/openssl-${OPENSSL_VERSION}.tar.gz
URLS+= http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

include ${CFG_ROOT}/perl/perl/v5.18.4.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

NTI_OPENSSL_TEMP=nti-openssl-${OPENSSL_VERSION}

NTI_OPENSSL_EXTRACTED=${EXTTEMP}/${NTI_OPENSSL_TEMP}/README
NTI_OPENSSL_CONFIGURED=${EXTTEMP}/${NTI_OPENSSL_TEMP}/Makefile.NEW
NTI_OPENSSL_BUILT=${EXTTEMP}/${NTI_OPENSSL_TEMP}/libssl.pc
NTI_OPENSSL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/openssl.pc


## ,-----
## |	Extract
## +-----

${NTI_OPENSSL_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/openssl-${OPENSSL_VERSION} ] || rm -rf ${EXTTEMP}/openssl-${OPENSSL_VERSION}
	zcat ${OPENSSL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPENSSL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENSSL_TEMP}
	mv ${EXTTEMP}/openssl-${OPENSSL_VERSION} ${EXTTEMP}/${NTI_OPENSSL_TEMP}


## ,-----
## |	Configure
## +-----

## [2014-04-12] i686 case: not linux-elf, or bad options
## [2014-05-29] LFS suggests 'shared zlib-dynamic' is sufficient
## [2014-05-29] x86_64 case: needs 'Configure' due to dubious defaults
## `./Configure linux-generic32 386 shared zlib-dynamic no-rc5 no-idea`?

${NTI_OPENSSL_CONFIGURED}: ${NTI_OPENSSL_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
			case ${HOSTCPU} in \
			i686) \
			./Configure linux-generic32 386 shared no-idea no-mdc2 no-rc5 no-ssl2 enable-tlsext zlib-dynamic \
				--with-zlib-include=${NTI_TC_ROOT}/usr/include \
				--with-zlib-lib=${NTI_TC_ROOT}/usr/lib \
				|| exit 1 \
			 ;; \
			x86_64) \
			./Configure linux-${HOSTCPU} shared no-idea no-mdc2 no-rc5 no-ssl2 enable-tlsext zlib-dynamic || exit 1 \
			;; \
			*) \
				echo "Unexpected HOSTCPU ${HOSTCPU}" 1>&2 ;\
				exit 1 \
			;; \
			esac ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^INSTALLTOP[= ]/ s%/usr.*%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^OPENSSLDIR[= ]/ s%/usr.*%'${NTI_TC_ROOT}'/usr/local/ssl%' \
			| sed '/^	/	s%$$(LIBDIR)/pkgconfig%'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.NEW ;\
		case ${OPENSSL_VERSION} in \
		1.0.1[fg]) \
			sed '/^install:/	s/install_docs//' Makefile.NEW > Makefile \
		;; \
		*) \
			cp Makefile.NEW Makefile \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

## [2016-02-29] Preliminary 'make depend' mandatory in v1.0.1q+

${NTI_OPENSSL_BUILT}: ${NTI_OPENSSL_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		case ${OPENSSL_VERSION} in \
		1.0.1[qr]) \
			make depend || exit 1 \
		;; \
		esac ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_OPENSSL_INSTALLED}: ${NTI_OPENSSL_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENSSL_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-openssl
nti-openssl: nti-perl nti-zlib ${NTI_OPENSSL_INSTALLED}

ALL_NTI_TARGETS+= nti-openssl

endif	# HAVE_OPENSSL_CONFIG
