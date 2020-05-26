#!/bin/gmake
## based on LFS v3.2

include ${CONF}
include ${UNIT}

#.PHONY: check-be default
.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

#.PHONY: build build-cross build-static check-be prelim
#
##check-be:
##	which patch

.PHONY: build-cross build-native prelim

prelim:
	[ -r Makefile-libbz2_so.OLD ] || cp Makefile-libbz2_so Makefile-libbz2_so.OLD
#	cat Makefile-libbz2_so.OLD \
#		| sed 's%=gcc%=$${CROSS}gcc%' \
#		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
#		> Makefile-libbz2_so
	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD
#	cat Makefile.OLD \
#		| sed 's%=gcc%=$${CROSS}gcc%' \
#		| sed 's%=ar%=$${CROSS}ar%' \
#		| sed 's%=ranlib%=$${CROSS}ranlib%' \
#		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
#		> Makefile
	[ -d ${INSTROOT} ] || mkdir ${INSTROOT}
	( cd ${INSTROOT} && ( \
		[ -d bin ] || mkdir bin ;\
		[ -d lib ] || mkdir lib ;\
		[ ! -r ${INSTROOT}/usr/bin/bzegrep ] || rm ${INSTROOT}/usr/bin/bz* ;\
	) || exit 1 )
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER} && ( \
#		mkdir bin lib usr	;\
#		mkdir usr/include usr/lib ;\
#		mkdir usr/share usr/share/man usr/share/man/man1 \
#	) || exit 1 )

build-cross:
	${MAKE} -f ${MAKEFILE} INSTROOT=${INSTTMP}/${PKGNAME}-${PKGVER} prelim
	cat Makefile-libbz2_so.OLD \
		| sed 's%=gcc%=$${CROSS}gcc%' \
		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
		> Makefile-libbz2_so
	cat Makefile.OLD \
		| sed 's%=gcc%=$${CROSS}gcc%' \
		| sed 's%=ar%=$${CROSS}ar%' \
		| sed 's%=ranlib%=$${CROSS}ranlib%' \
		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
		> Makefile
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make CROSS=${CROSS_PREFIX}- -f Makefile-libbz2_so
	#rm ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin/bz*
	PATH=${TOOLROOT}/usr/${CROSS_PREFIX}/bin:${PATH} make CROSS=${CROSS_PREFIX}- PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install
	cp bzip2-shared ${INSTTMP}/${PKGNAME}-${PKGVER}/bin/bzip2
	ln -sf libbz2.so.1.0 libbz2.so
	cp -a libbz2.so* ${INSTTMP}/${PKGNAME}-${PKGVER}/lib
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/lib && ln -sf ../../lib/libzz2.so )
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin &&\
		rm bunzip2 bzcat bzip2 &&\
		rm bzmore &&\
		mv bzip2recover bzless ../../bin &&\
		rm bzcmp &&\
		ln -sf bzdiff bzcmp &&\
		rm bzegrep bzfgrep &&\
		ln -sf bzgrep bzegrep &&\
		ln -sf bzgrep bzfgrep \
	)
	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/bin &&\
		ln -sf bzip2 bunzip2 &&\
		ln -sf bzip2 bzcat &&\
		ln -sf bzless bzmore \
	)

build-native:
	${MAKE} -f ${MAKEFILE} INSTROOT=${TOOLROOT} prelim
	cp Makefile-libbz2_so.OLD Makefile-libbz2_so
	cp Makefile.OLD Makefile
	make -f Makefile-libbz2_so
	make PREFIX=${TOOLROOT}/usr install
	cp bzip2-shared ${TOOLROOT}/bin/bzip2
	ln -sf libbz2.so.1.0 libbz2.so
#
	[ ! -r ${TOOLROOT}/lib/libbz2.so ] || rm ${TOOLROOT}/lib/libbz2.so*
#
	cp -a libbz2.so* ${TOOLROOT}/lib/
	( cd ${TOOLROOT}/usr/lib && ln -sf ../../lib/libzz2.so )
	( cd ${TOOLROOT}/usr/bin &&\
		rm bunzip2 bzcat bzip2 &&\
		rm bzmore &&\
		mv bzip2recover bzless ../../bin &&\
		rm bzcmp &&\
		ln -sf bzdiff bzcmp &&\
		rm bzegrep bzfgrep &&\
		ln -sf bzgrep bzegrep &&\
		ln -sf bzgrep bzfgrep \
	)
	( cd ${TOOLROOT}/bin &&\
		ln -sf bzip2 bunzip2 &&\
		ln -sf bzip2 bzcat &&\
		ln -sf bzless bzmore \
	)

#build-static: prelim
#	make CC="gcc -static"
#	make PREFIX=${INSTTMP}/${PKGNAME}-${PKGVER}/usr install
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/usr/bin &&\
#		rm bzcat bunzip2 bzmore &&\
#		mv bzip2 bzip2recover bzless ../../bin &&\
#		rm bzcmp &&\
#		ln -sf bzdiff bzcmp &&\
#		rm bzegrep bzfgrep &&\
#		ln -sf bzgrep bzegrep &&\
#		ln -sf bzgrep bzfgrep \
#	)
#	( cd ${INSTTMP}/${PKGNAME}-${PKGVER}/bin &&\
#		ln -sf bzip2 bunzip2 &&\
#		ln -sf bzip2 bzcat &&\
#		ln -sf bzless bzmore \
#	)
