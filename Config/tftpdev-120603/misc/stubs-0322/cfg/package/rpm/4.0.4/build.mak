#!/bin/gmake
# 'indy' rpm compile, 18/10/2002

include ${CONF}
include ${UNIT}

.PHONY: default

default:
	[ "${MAKERULE}" ]
	[ "${MAKEFILE}" ]
	[ -d "${SRCXPATH}" ]
	cd ${SRCXPATH} && ${MAKE} -f ${MAKEFILE} ${MAKERULE}

.PHONY: build-native prelim

prelim:
	[ -r autogen.sh.OLD ] || cp autogen.sh autogen.sh.OLD
# autogen.sh mods: 1: libtoolize is version we make
# autogen.sh mods: 2: ensure descend-into-subdir commands work
	cat autogen.sh.OLD \
		| sed 's%LTV="libtoolize (GNU libtool) 1.4"%LTV="libtoolize (GNU libtool) 1.4.2"%' \
		| sed 's%ACV="Autoconf version 2.13"%ACV="autoconf (GNU Autoconf) 2.53"%' \
		| sed 's%"`autoconf --version`"%"`autoconf --version | head -1`"%' \
		| sed 's%AMV="automake (GNU automake) 1.4-p5"%AMV="automake (GNU automake) 1.6"%' \
		| sed 's%; \.% \&\& .%' \
		> autogen.sh

build-native:
	${MAKE} -f ${MAKEFILE} prelim
#	./autogen.sh --noconfigure
#	aclocal
	./configure --prefix=/usr \
		--sysconfdir=/etc --localstatedir=/var \
		--enable-shared=beecrypt,db3 --with-included-gettext=no
	make
	make DESTDIR=${TOOLROOT} install
