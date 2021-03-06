# p7zip v9.20.1			[ earliest v9.20.1, c.2014-05-14 ]
# last mod WmT, 2014-05-14	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_P7ZIP_CONFIG},y)
HAVE_P7ZIP_CONFIG:=y

#DESCRLIST+= "'nti-p7zip' -- p7zip"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${P7ZIP_VERSION},)
P7ZIP_VERSION=9.20.1
endif

P7ZIP_SRC=${SOURCES}/p/p7zip_${P7ZIP_VERSION}_src_all.tar.bz2
URLS+= http://downloads.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2?use_mirror=garr

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak


NTI_P7ZIP_TEMP=nti-p7zip-${P7ZIP_VERSION}

NTI_P7ZIP_EXTRACTED=${EXTTEMP}/${NTI_P7ZIP_TEMP}/LICENSE
NTI_P7ZIP_CONFIGURED=${EXTTEMP}/${NTI_P7ZIP_TEMP}/Makefile.OLD
NTI_P7ZIP_BUILT=${EXTTEMP}/${NTI_P7ZIP_TEMP}/p7zip
NTI_P7ZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/p7zip


## ,-----
## |	Extract
## +-----

${NTI_P7ZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/p7zip_${P7ZIP_VERSION} ] || rm -rf ${EXTTEMP}/p7zip_${P7ZIP_VERSION}
	#[ ! -d ${EXTTEMP}/p7zip-${P7ZIP_VERSION} ] || rm -rf ${EXTTEMP}/p7zip-${P7ZIP_VERSION}
	bzcat ${P7ZIP_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${P7ZIP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_P7ZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_P7ZIP_TEMP}
	mv ${EXTTEMP}/p7zip_${P7ZIP_VERSION} ${EXTTEMP}/${NTI_P7ZIP_TEMP}
	#mv ${EXTTEMP}/p7zip-${P7ZIP_VERSION} ${EXTTEMP}/${NTI_P7ZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_P7ZIP_CONFIGURED}: ${NTI_P7ZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_P7ZIP_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			| sed '/^PREFIX/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			> Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_P7ZIP_BUILT}: ${NTI_P7ZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_P7ZIP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_P7ZIP_INSTALLED}: ${NTI_P7ZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_P7ZIP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-p7zip
nti-p7zip: ${NTI_P7ZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-p7zip

endif	# HAVE_P7ZIP_CONFIG
