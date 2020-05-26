# tcc v0.9.25			[ since v0.9.19, c.2003-06-05 ]
# last mod WmT, 2010-06-08	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_TCC_CONFIG},y)
HAVE_TCC_CONFIG:=y

DESCRLIST+= "'cui-tcc' -- tcc (Tiny C Compiler)"

## TODO: needs headers, libraries at runtime

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

CUI_TCC_VER:=0.9.25
CUI_TCC_SRC=${SRCDIR}/t/tcc-0.9.25.tar.bz2
CUI_TCC_PATCHES=

URLS+=http://download.savannah.nongnu.org/releases/tinycc/tcc-0.9.25.tar.bz2

#CUI_TCC_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_TCC_TEMP=cui-tcc-${CUI_TCC_VER}
CUI_TCC_INSTTEMP=${EXTTEMP}/insttemp

CUI_TCC_EXTRACTED=${EXTTEMP}/${CUI_TCC_TEMP}/Makefile

.PHONY: cui-tcc-extracted

cui-tcc-extracted: ${CUI_TCC_EXTRACTED}

${CUI_TCC_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_TCC_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_TCC_TEMP}
	make -C ${TOPLEV} extract ARCHIVE=${CUI_TCC_SRC}
ifneq (${CUI_TCC_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_TCC_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_TCC_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/tcc-${CUI_TCC_VER} ${EXTTEMP}/${CUI_TCC_TEMP}


# ,-----
# |	Configure
# +-----

CUI_TCC_CONFIGURED=${EXTTEMP}/${CUI_TCC_TEMP}/config.mak.OLD

.PHONY: cui-tcc-configured

cui-tcc-configured: cui-tcc-extracted ${CUI_TCC_CONFIGURED}

${CUI_TCC_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
		bigendian=no \
			./configure --prefix=/usr --cc=${CTI_GCC} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed 's/LIBS=.*/LIBS=-ldl -lm/' \
			| sed 's/ -ldl/ $$(LIBS)/' \
			> Makefile || exit 1 ;\
		[ -r config.mak.OLD ] || mv config.mak config.mak.OLD || exit 1 ;\
		cat config.mak.OLD \
			| sed '/^[a-z]*=/ s%/usr%$${DESTDIR}/usr%' \
			> config.mak || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_TCC_BUILT=${EXTTEMP}/${CUI_TCC_TEMP}/libtcc.a

.PHONY: cui-tcc-built
cui-tcc-built: cui-tcc-configured ${CUI_TCC_BUILT}

${CUI_TCC_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1



# ,-----
# |	Install
# +-----

CUI_TCC_INSTALLED=${CUI_TCC_INSTTEMP}/usr/bin/tcc

.PHONY: cui-tcc-installed

cui-tcc-installed: cui-tcc-built ${CUI_TCC_INSTALLED}

${CUI_TCC_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	for DIR in /usr/bin /usr/include /usr/man/man1 /usr/man/man8 ; do \
		mkdir -p ${CUI_TCC_INSTTEMP}/$${DIR} || exit 1 ;\
	done
	( cd ${EXTTEMP}/${CUI_TCC_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_TCC_INSTTEMP} install || exit 1 \
	) || exit 1


.PHONY: cui-tcc
cui-tcc: cti-cross-gcc cui-uClibc-rt cui-tcc-installed

TARGETS+= cui-tcc

endif	# HAVE_TCC_CONFIG
