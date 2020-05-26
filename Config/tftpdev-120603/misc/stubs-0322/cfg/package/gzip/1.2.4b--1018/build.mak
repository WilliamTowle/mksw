#!/bin/gmake
## based on LFS v3.2

include ${CONF}
#include ${UNIT}

.PHONY: build build-static check-be prelim

#check-be:
#	which patch

prelim:
	( cd ${INSTTMP} && ( \
		mkdir bin usr ;\
		mkdir usr/info \
	) || exit 1 )

build: prelim
	./configure --prefix=${INSTTMP}/usr
	if [ ! -r gzexe.in.backup ] ; then \
		cp gzexe.in gzexe.in.backup ;\
		sed 's%"BINDIR"%/bin%' gzexe.in.backup > gzexe.in ;\
	fi
	make
	make install
	( cd ${INSTTMP}/usr/bin && \
		rm zcmp && ln -s zdiff zcmp && \
		mv gzip ../../bin/ && \
		rm gunzip zcat && \
		cd ../../bin && \
		ln -sf gzip gunzip && \
		ln -sf gzip zcat && \
		ln -sf gunzip uncompress \
	)

build-static: prelim
	./configure --prefix=${INSTTMP}/usr
	make LDFLAGS=-static
	make install
	cp ${INSTTMP}/usr/bin/gunzip ${INSTTMP}/usr/bin/gzip ${INSTTMP}/bin
	rm ${INSTTMP}/usr/bin/gunzip ${INSTTMP}/usr/bin/gzip
