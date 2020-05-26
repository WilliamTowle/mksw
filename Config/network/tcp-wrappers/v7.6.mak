# tcp-wrappers v7.6		[ EARLIEST v7.6, c.2013-02-22 ]
# last mod WmT, 2013-02-23	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_TCP_WRAPPERS_CONFIG},y)
HAVE_TCP_WRAPPERS_CONFIG:=y

#DESCRLIST+= "'nti-tcp-wrappers' -- tcp-wrappers"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TCP_WRAPPERS_VERSION},)
TCP_WRAPPERS_VERSION=7.6
endif

TCP_WRAPPERS_SRC=${SOURCES}/t/tcp_wrappers_${TCP_WRAPPERS_VERSION}.tar.gz
URLS+=http://ftp.nluug.nl/security/tcpwrappers/tcp_wrappers_7.6.tar.gz

NTI_TCP_WRAPPERS_TEMP=nti-tcp-wrappers-${TCP_WRAPPERS_VERSION}

NTI_TCP_WRAPPERS_EXTRACTED=${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}/DISCLAIMER
NTI_TCP_WRAPPERS_CONFIGURED=${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}/Makefile.OLD
NTI_TCP_WRAPPERS_BUILT=${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}/libwrap.a
NTI_TCP_WRAPPERS_INSTALLED=${NTI_TC_ROOT}/usr/lib/libwrap.a


## ,-----
## |	Extract
## +-----

${NTI_TCP_WRAPPERS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/tcp-wrappers-${TCP_WRAPPERS_VERSION} ] || rm -rf ${EXTTEMP}/tcp-wrappers-${TCP_WRAPPERS_VERSION}
	zcat ${TCP_WRAPPERS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}
	mv ${EXTTEMP}/tcp_wrappers_${TCP_WRAPPERS_VERSION} ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}
#	mv ${EXTTEMP}/tcp-wrappers-${TCP_WRAPPERS_VERSION} ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TCP_WRAPPERS_CONFIGURED}: ${NTI_TCP_WRAPPERS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/sbin$$/		s/^#//' \
			| sed '/linux/,+4	{ s/-DBROKEN_SO_LINGER/-DSYS_ERRLIST_DEFINED/ ; s/all/CC=gcc all/ } '\
			> Makefile ;\
		[ -r scaffold.c.OLD ] || mv scaffold.c scaffold.c.OLD || exit 1 ;\
		cat scaffold.c.OLD \
			| sed '/extern char/	{ s%^%/* % ; s%$$% */% }' \
			> scaffold.c \
	)

## ,-----
## |	Build
## +-----

${NTI_TCP_WRAPPERS_BUILT}: ${NTI_TCP_WRAPPERS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP} || exit 1 ;\
		make linux \
	)


## ,-----
## |	Install
## +-----

${NTI_TCP_WRAPPERS_INSTALLED}: ${NTI_TCP_WRAPPERS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TCP_WRAPPERS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/usr/include ;\
		mkdir -p ${NTI_TC_ROOT}/usr/lib ;\
		cp tcpd.h ${NTI_TC_ROOT}/usr/include/ ;\
		cp libwrap.a ${NTI_TC_ROOT}/usr/lib \
	)

##

.PHONY: nti-tcp-wrappers
nti-tcp-wrappers: ${NTI_TCP_WRAPPERS_INSTALLED}

ALL_NTI_TARGETS+= nti-tcp-wrappers

endif	# HAVE_TCP_WRAPPERS_CONFIG
