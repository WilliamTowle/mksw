## zip v30			[ since v30, c.2018-03-15 ]
## last mod WmT, 2018-03-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_ZIP_CONFIG},y)
HAVE_ZIP_CONFIG:=y

#DESCRLIST+= "'nti-zip' -- zip"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${ZIP_VERSION},)
ZIP_VERSION=30
endif

ZIP_SRC=${SOURCES}/z/zip${ZIP_VERSION}.tgz
URLS+= ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz


NTI_ZIP_TEMP=nti-zip-${ZIP_VERSION}

NTI_ZIP_EXTRACTED=${EXTTEMP}/${NTI_ZIP_TEMP}/LICENSE
NTI_ZIP_CONFIGURED=${EXTTEMP}/${NTI_ZIP_TEMP}/unix/Makefile.OLD
NTI_ZIP_BUILT=${EXTTEMP}/${NTI_ZIP_TEMP}/zip
NTI_ZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/zip


## ,-----
## |	Extract
## +-----

${NTI_ZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/zip-30 ] || rm -rf ${EXTTEMP}/zip-30
	zcat ${ZIP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZIP_TEMP}
	mv ${EXTTEMP}/zip${ZIP_VERSION} ${EXTTEMP}/${NTI_ZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ZIP_CONFIGURED}: ${NTI_ZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_ZIP_TEMP} || exit 1 ;\
		[ -r unix/Makefile.OLD ] || mv unix/Makefile unix/Makefile.OLD || exit 1 ;\
		cat unix/Makefile.OLD \
			| sed '/^prefix/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			> unix/Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_ZIP_BUILT}: ${NTI_ZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_ZIP_TEMP} || exit 1 ;\
		make -f unix/Makefile generic \
	)


## ,-----
## |	Install
## +-----

${NTI_ZIP_INSTALLED}: ${NTI_ZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_ZIP_TEMP} || exit 1 ;\
		make -f unix/Makefile install \
	)

#build-cross:
##	make -f unix/Makefile list
#	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
#		make -f unix/Makefile CC=${CROSS_PREFIX}-gcc generic
#	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin
#	for FILE in zip fzip zipsfx ; do \
#		cp $$FILE ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/ ;\
#	done
#	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1
#	cp man/*.1 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1/

##

.PHONY: nti-zip
nti-zip: ${NTI_ZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-zip

endif	# HAVE_ZIP_CONFIG
