## unzip v60			[ since v5.50, c.2003 ]
## last mod WmT, 2016-09-08	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_UNZIP_CONFIG},y)
HAVE_UNZIP_CONFIG:=y

#DESCRLIST+= "'nti-unzip' -- unzip"

include ${CFG_ROOT}/ENV/buildtype.mak


ifeq (${UNZIP_VERSION},)
#UNZIP_VERSION=550
#UNZIP_VERSION=552
UNZIP_VERSION=60
endif

#UNZIP_SRC=${SOURCES}/u/unzip${UNZIP_VERSION}.tar.gz
UNZIP_SRC=${SOURCES}/u/unzip${UNZIP_VERSION}.tgz
#URLS+= ftp://ftp.info-zip.org/pub/infozip/src/unzip${UNZIP_VERSION}.tar.gz
URLS+= ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz

UNZIP_PATCHES:=
ifeq (${UNZIP_VERSION},552)
UNZIP_PATCHES=${SOURCES}/u/unzip-5.52-fix_libz-1.patch
URLS+= http://www.linuxfromscratch.org/patches/downloads/unzip/unzip-5.52-fix_libz-1.patch
endif

NTI_UNZIP_TEMP=nti-unzip-${UNZIP_VERSION}

NTI_UNZIP_EXTRACTED=${EXTTEMP}/${NTI_UNZIP_TEMP}/LICENSE
NTI_UNZIP_CONFIGURED=${EXTTEMP}/${NTI_UNZIP_TEMP}/unix/Makefile.OLD
NTI_UNZIP_BUILT=${EXTTEMP}/${NTI_UNZIP_TEMP}/unzip
NTI_UNZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/unzip


## ,-----
## |	Extract
## +-----

${NTI_UNZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/unzip-5.50 ] || rm -rf ${EXTTEMP}/unzip-5.50
	[ ! -d ${EXTTEMP}/unzip-5.50 ] || rm -rf ${EXTTEMP}/unzip-5.52
	#[ ! -d ${EXTTEMP}/unzip-${UNZIP_VERSION} ] || rm -rf ${EXTTEMP}/unzip-${UNZIP_VERSION}
	#[ ! -d ${EXTTEMP}/unzip${UNZIP_VERSION} ] || rm -rf ${EXTTEMP}/unzip${UNZIP_VERSION}
	zcat ${UNZIP_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${UNZIP_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${UNZIP_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} || exit 1 ;\
			patch --batch -d unzip-5.52 -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_UNZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UNZIP_TEMP}
	#mv ${EXTTEMP}/unzip-5.50 ${EXTTEMP}/${NTI_UNZIP_TEMP}
	#mv ${EXTTEMP}/unzip-5.52 ${EXTTEMP}/${NTI_UNZIP_TEMP}
	#mv ${EXTTEMP}/unzip-${UNZIP_VERSION} ${EXTTEMP}/${NTI_UNZIP_TEMP}
	mv ${EXTTEMP}/unzip${UNZIP_VERSION} ${EXTTEMP}/${NTI_UNZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UNZIP_CONFIGURED}: ${NTI_UNZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UNZIP_TEMP} || exit 1 ;\
		[ -r unix/Makefile.OLD ] || mv unix/Makefile unix/Makefile.OLD || exit 1 ;\
		cat unix/Makefile.OLD \
			| sed '/^prefix/	s%/usr/local%'${NTI_TC_ROOT}'/usr%' \
			| sed '/^CC/		s%g*cc%'${NTI_GCC}'%' \
			> unix/Makefile \
	)


## ,-----
## |	Build
## +-----

${NTI_UNZIP_BUILT}: ${NTI_UNZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UNZIP_TEMP} || exit 1 ;\
		make -f unix/Makefile generic \
	)


## ,-----
## |	Install
## +-----

${NTI_UNZIP_INSTALLED}: ${NTI_UNZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UNZIP_TEMP} || exit 1 ;\
		make -f unix/Makefile install \
	)

#build-cross:
##	make -f unix/Makefile list
#	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} \
#		make -f unix/Makefile CC=${CROSS_PREFIX}-gcc generic
#	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin
#	for FILE in unzip funzip unzipsfx ; do \
#		cp $$FILE ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/ ;\
#	done
#	mkdir -p ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1
#	cp man/*.1 ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/man/man1/

##

.PHONY: nti-unzip
nti-unzip: ${NTI_UNZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-unzip

endif	# HAVE_UNZIP_CONFIG
