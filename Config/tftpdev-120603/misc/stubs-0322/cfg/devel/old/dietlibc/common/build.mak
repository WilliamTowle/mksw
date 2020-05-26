#!/bin/gmake

include ${CONF}
#include ${UNIT}

.PHONY: build prelim

## UNIX98PTY_ONLY should be false for old kernels (tried: 2.0.39)
build:
	make
	make DESTDIR=${INSTTMP}/ install
	mkdir -p ${CTRLROOT}/${TARGET_ARCH}/bin
	mkdir -p ${CTRLROOT}/${TARGET_ARCH}/man
	cp bin-${TARGET_ARCH}/diet ${CTRLROOT}/${TARGET_ARCH}/bin
	cp diet.1 ${CTRLROOT}/${TARGET_ARCH}/man
