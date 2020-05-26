# dnsmasq v2.78			[ since v2.2, c.2004-02-06 ]
# last mod WmT, 2017-10-24	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DNSMASQ_CONFIG},y)
HAVE_DNSMASQ_CONFIG:=y

#DESCRLIST+= "'nti-dnsmasq' -- dnsmasq"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DNSMASQ_VERSION},)
#previously: v2.5[689]
#previously: v2.6[58]
#DNSMASQ_VERSION=2.72
#DNSMASQ_VERSION=2.75
#DNSMASQ_VERSION=2.76
#DNSMASQ_VERSION=2.77
DNSMASQ_VERSION=2.78
endif

DNSMASQ_SRC=${SOURCES}/d/dnsmasq-${DNSMASQ_VERSION}.tar.gz
URLS+=http://www.thekelleys.org.uk/dnsmasq/dnsmasq-${DNSMASQ_VERSION}.tar.gz

NTI_DNSMASQ_TEMP=nti-dnsmasq-${DNSMASQ_VERSION}

NTI_DNSMASQ_EXTRACTED=${EXTTEMP}/${NTI_DNSMASQ_TEMP}/VERSION
NTI_DNSMASQ_CONFIGURED=${EXTTEMP}/${NTI_DNSMASQ_TEMP}/Makefile.OLD
NTI_DNSMASQ_BUILT=${EXTTEMP}/${NTI_DNSMASQ_TEMP}/src/dnsmasq
NTI_DNSMASQ_INSTALLED=${NTI_TC_ROOT}/usr/sbin/dnsmasq


## ,-----
## |	Extract
## +-----

${NTI_DNSMASQ_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/dnsmasq-${DNSMASQ_VERSION} ] || rm -rf ${EXTTEMP}/dnsmasq-${DNSMASQ_VERSION}
	zcat ${DNSMASQ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DNSMASQ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DNSMASQ_TEMP}
	mv ${EXTTEMP}/dnsmasq-${DNSMASQ_VERSION} ${EXTTEMP}/${NTI_DNSMASQ_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DNSMASQ_CONFIGURED}: ${NTI_DNSMASQ_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DNSMASQ_TEMP} || exit 1 ;\
		case ${DNSMASQ_VERSION} in \
		2.51) \
			[ -r bld/Makefile.OLD ] || mv bld/Makefile bld/Makefile.OLD || exit 1 ;\
			echo 'CC='${NTI_GCC} > bld/Makefile || exit 1 ;\
			cat bld/Makefile.OLD >> bld/Makefile ;\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
				>> Makefile \
		;; \
		2.52|2.55) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
				| sed '/^CFLAGS/	s%^%CC=	'${NTI_GCC}'\n%' \
				>> Makefile \
		;; \
		2.5[6789]|2.6[258]|2.7[25678]) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
				| sed '/^CFLAGS/	s%^%CC=	'${NTI_GCC}'\n%' \
				>> Makefile \
		;; \
		*) \
			echo "Unexpected DNSMASQ_VER ${DNSMASQ_VER}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_DNSMASQ_BUILT}: ${NTI_DNSMASQ_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DNSMASQ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DNSMASQ_INSTALLED}: ${NTI_DNSMASQ_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DNSMASQ_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-dnsmasq
nti-dnsmasq: ${NTI_DNSMASQ_INSTALLED}

ALL_NTI_TARGETS+= nti-dnsmasq

endif	# HAVE_DNSMASQ_CONFIG
