# lha v1.14i-ac20050924		[ EARLIEST v?.?? ]
# last mod WmT, 2014-03-27	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LHA_CONFIG},y)
HAVE_LHA_CONFIG:=y

#DESCRLIST+= "'nti-lha' -- lha"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LHA_VERSION},)
#LHA_VERSION=114i
#LHA_VERSION=1.14i-ac20050924
LHA_VERSION=1.14i-ac20050924p1
endif

LHA_SRC=${SOURCES}/l/lha-${LHA_VERSION}.tar.gz
#URLS+= 'http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Flha%2F16650%2Flha-1.14i-ac20050924.tar.gz'
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/lha-1.14i-ac20050924p1.tar.gz

NTI_LHA_TEMP=nti-lha-${LHA_VERSION}

#NTI_LHA_EXTRACTED=${EXTTEMP}/${NTI_LHA_TEMP}/src/lha.h
NTI_LHA_EXTRACTED=${EXTTEMP}/${NTI_LHA_TEMP}/configure
#NTI_LHA_CONFIGURED=${EXTTEMP}/${NTI_LHA_TEMP}/Makefile.OLD
NTI_LHA_CONFIGURED=${EXTTEMP}/${NTI_LHA_TEMP}/config.status
NTI_LHA_BUILT=${EXTTEMP}/${NTI_LHA_TEMP}/src/lha
NTI_LHA_INSTALLED=${NTI_TC_ROOT}/usr/bin/lha


## ,-----
## |	Extract
## +-----

${NTI_LHA_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/lha-${LHA_VERSION} ] || rm -rf ${EXTTEMP}/lha-${LHA_VERSION}
	zcat ${LHA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LHA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LHA_TEMP}
	mv ${EXTTEMP}/lha-${LHA_VERSION} ${EXTTEMP}/${NTI_LHA_TEMP}


## ,-----
## |	Configure
## +-----

# TODO: adapt CC= in Makefile to suit selected compiler

${NTI_LHA_CONFIGURED}: ${NTI_LHA_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		case ${LHA_VERSION} in \
		1.14[a-z])	\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
			cat Makefile.OLD \
				| sed '/^[A-Z]*DIR/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
				> Makefile \
		;; \
		1.14[a-z]-ac*)	\
			CC=${NTI_GCC} \
			  CFLAGS='-O2' \
				./configure --prefix=${NTI_TC_ROOT}/usr \
				  || exit 1 \
		;; \
		*) \
			echo "Unexpected LHA_VERSION ${LHA_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_LHA_BUILT}: ${NTI_LHA_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LHA_INSTALLED}: ${NTI_LHA_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LHA_TEMP} || exit 1 ;\
		case ${LHA_VERSION} in \
		1.14[a-z])	\
			mkdir -p ${NTI_TC_ROOT}/usr/man/mann \
		;; \
		esac ;\
		make install \
	)

##

.PHONY: nti-lha
nti-lha: ${NTI_LHA_INSTALLED}

ALL_NTI_TARGETS+= nti-lha

endif	# HAVE_LHA_CONFIG
