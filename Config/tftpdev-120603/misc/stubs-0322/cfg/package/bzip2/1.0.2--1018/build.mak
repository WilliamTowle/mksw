#!/bin/gmake
## based on LFS v3.2

include ${CONF}
#include ${UNIT}

.PHONY: build build-static check-be prelim

default: build

#check-be:
#	which patch

prelim:
	[ -r Makefile-libbz2_so.OLD ] || cp Makefile-libbz2_so Makefile-libbz2_so.OLD
	cat Makefile-libbz2_so.OLD \
		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
		> Makefile-libbz2_so
	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD
	cat Makefile.OLD \
		| sed 's%^BIGFILES=.*%BIGFILES=-D_FILE_OFFSET_BITS=32%' \
		> Makefile
	( cd ${INSTTMP} && ( \
		mkdir bin lib usr	;\
		mkdir usr/include usr/lib ;\
		mkdir usr/share usr/share/man usr/share/man/man1 \
	) || exit 1 )

build: prelim
	make -f Makefile-libbz2_so
	#rm ${INSTTMP}/usr/bin/bz*
	make PREFIX=${INSTTMP}/usr install
	cp bzip2-shared ${INSTTMP}/bin/bzip2
	ln -sf libbz2.so.1.0 libbz2.so
	cp -a libbz2.so* ${INSTTMP}/lib
	( cd ${INSTTMP}/usr/lib && ln -sf ../../lib/libzz2.so )
	( cd ${INSTTMP}/usr/bin &&\
		rm bunzip2 bzcat bzip2 &&\
		rm bzmore &&\
		mv bzip2recover bzless ${INSTTMP}/bin &&\
		rm bzcmp &&\
		ln -sf bzdiff bzcmp &&\
		rm bzegrep bzfgrep &&\
		ln -sf bzgrep bzegrep &&\
		ln -sf bzgrep bzfgrep \
	)
	( cd ${INSTTMP}/bin &&\
		ln -sf bzip2 bunzip2 &&\
		ln -sf bzip2 bzcat &&\
		ln -sf bzless bzmore \
	)

build-static: prelim
	make CC="gcc -static"
	make PREFIX=${INSTTMP}/usr install
	( cd ${INSTTMP}/usr/bin &&\
		rm bzcat bunzip2 bzmore &&\
		mv bzip2 bzip2recover bzless ${INSTTMP}/bin &&\
		rm bzcmp &&\
		ln -sf bzdiff bzcmp &&\
		rm bzegrep bzfgrep &&\
		ln -sf bzgrep bzegrep &&\
		ln -sf bzgrep bzfgrep \
	)
	( cd ${INSTTMP}/bin &&\
		ln -sf bzip2 bunzip2 &&\
		ln -sf bzip2 bzcat &&\
		ln -sf bzless bzmore \
	)
