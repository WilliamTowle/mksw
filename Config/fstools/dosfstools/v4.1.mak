## dosfstools v4.1		[ since v3.0.8, c. 2010-01-25 ]
## last mod WmT, 2017-07-19	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DOSFSTOOLS_CONFIG},y)
HAVE_DOSFSTOOLS_CONFIG:=y

DESCRLIST+= "'nti-dosfstools' -- dosfstools"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DOSFSTOOLS_VERSION},)
#DOSFSTOOLS_VERSION=3.0.15
#DOSFSTOOLS_VERSION=3.0.16
#DOSFSTOOLS_VERSION=3.0.26
#DOSFSTOOLS_VERSION=4.0
DOSFSTOOLS_VERSION=4.1
endif

DOSFSTOOLS_SRC=${SOURCES}/d/dosfstools-${DOSFSTOOLS_VERSION}.tar.gz
#URLS+= http://www.daniel-baumann.ch/files/software/dosfstools/dosfstools-${DOSFSTOOLS_VERSION}.tar.gz
URLS+= https://github.com/dosfstools/dosfstools/releases/download/v${DOSFSTOOLS_VERSION}/dosfstools-${DOSFSTOOLS_VERSION}.tar.gz

NTI_DOSFSTOOLS_TEMP=nti-dosfstools-${DOSFSTOOLS_VERSION}

NTI_DOSFSTOOLS_EXTRACTED=${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/COPYING
NTI_DOSFSTOOLS_CONFIGURED=${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/.configured
#NTI_DOSFSTOOLS_BUILT=${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/mkfs.fat
NTI_DOSFSTOOLS_BUILT=${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/.built
NTI_DOSFSTOOLS_INSTALLED=${NTI_TC_ROOT}/usr/sbin/mkfs.fat


## ,-----
## |	Extract
## +-----

${NTI_DOSFSTOOLS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/dosfstools-${DOSFSTOOLS_VERSION} ] || rm -rf ${EXTTEMP}/dosfstools-${DOSFSTOOLS_VERSION}
	zcat ${DOSFSTOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}
	mv ${EXTTEMP}/dosfstools-${DOSFSTOOLS_VERSION} ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DOSFSTOOLS_CONFIGURED}: ${NTI_DOSFSTOOLS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP} || exit 1 ;\
		case ${DOSFSTOOLS_VERSION} in \
		3.0.9) \
			[ -r src/dosfslabel.c.OLD ] || mv src/dosfslabel.c src/dosfslabel.c.OLD || exit 1 ;\
			cat src/dosfslabel.c.OLD \
				| sed 's/rw = 0;//' \
				> src/dosfslabel.c || exit 1 ;\
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^PREFIX[ 	]*=/ s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
				| sed '/^#OPTFLAGS[ 	]*/ s/^/CC=gcc\n/' \
				> Makefile || exit 1 \
		;; \
		4.[01]) \
			CFLAGS='-O2' \
			  CC=${NTI_GCC} \
				./configure \
					--prefix=${NTI_TC_ROOT}/usr \
					|| exit 1 \
		;; \
		*) \
			echo "Unexpected DOSFSTOOLS_VERSION ${DOSFSTOOLS_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		touch ${NTI_DOSFSTOOLS_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

${NTI_DOSFSTOOLS_BUILT}: ${NTI_DOSFSTOOLS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP} || exit 1 ;\
		make || exit 1 ;\
		case ${DOSFSTOOLS_VERSION} in \
		3.0.9) \
			[ -r ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/mkfs.fat] && touch ${NTI_DOSFSTOOLS_BUILT} \
		;; \
		4.[01]) \
			[ -r ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP}/src/mkfs.fat ] && touch ${NTI_DOSFSTOOLS_BUILT} \
		;; \
		*) \
			echo "Unexpected DOSFSTOOLS_VERSION ${DOSFSTOOLS_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Install
## +-----

${NTI_DOSFSTOOLS_INSTALLED}: ${NTI_DOSFSTOOLS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_DOSFSTOOLS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-dosfstools
nti-dosfstools: ${NTI_DOSFSTOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-dosfstools

endif	# HAVE_DOSFSTOOLS_CONFIG
