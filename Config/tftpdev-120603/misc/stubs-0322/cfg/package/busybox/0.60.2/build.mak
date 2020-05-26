#!/bin/gmake

include ${CONF}
#include ${UNIT}

.PHONY: build prelim

prelim:
	( cd ${INSTTMP} && ( \
		mkdir usr usr/bin \
	) || exit 1 ) || exit 1

build: prelim
	make PREFIX=${INSTTMP} install
