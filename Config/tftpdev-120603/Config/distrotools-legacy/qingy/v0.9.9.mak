# qingy v0.9.9			[ since v0.9.9, c.2010-06-11 ]
# last mod WmT, 2010-06-11	[ (c) and GPLv2 1999-2010 ]

ifneq (${HAVE_QINGY_CONFIG},y)
HAVE_QINGY_CONFIG:=y

DESCRLIST+= "'cui-qingy' -- qingy (Qingy Is Not GettY)"

## TODO: needs headers, libraries at runtime

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/tui/ncurses/v5.6.mak

CUI_QINGY_VER:=0.9.9
CUI_QINGY_SRC=${SRCDIR}/q/qingy-0.9.9.tar.bz2
CUI_QINGY_PATCHES=

URLS+=http://downloads.sourceforge.net/project/qingy/qingy/qingy%200.9.9/qingy-0.9.9.tar.bz2?use_mirror=freefr

#CUI_QINGY_PATCHES+=
#URLS+=


# ,-----
# |	Extract
# +-----

CUI_QINGY_TEMP=cui-qingy-${CUI_QINGY_VER}
CUI_QINGY_INSTTEMP=${EXTTEMP}/insttemp

CUI_QINGY_EXTRACTED=${EXTTEMP}/${CUI_QINGY_TEMP}/configure

.PHONY: cui-qingy-extracted

cui-qingy-extracted: ${CUI_QINGY_EXTRACTED}

${CUI_QINGY_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/${CUI_QINGY_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_QINGY_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${CUI_QINGY_SRC}
ifneq (${CUI_QINGY_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PATCHSRC in ${CUI_QINGY_PATCHES} ; do \
			make -C ../ extract ARCHIVE=$${PATCHSRC} || exit 1 ;\
		done ;\
		for PF in patch/*patch ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d gcc-${CUI_QINGY_VER} -Np1 < $${PF} ;\
			rm -f $${PF} ;\
		done \
	)
endif
	mv ${EXTTEMP}/qingy-${CUI_QINGY_VER} ${EXTTEMP}/${CUI_QINGY_TEMP}


# ,-----
# |	Configure
# +-----

CUI_QINGY_CONFIGURED=${EXTTEMP}/${CUI_QINGY_TEMP}/config.status

.PHONY: cui-qingy-configured

cui-qingy-configured: cui-qingy-extracted ${CUI_QINGY_CONFIGURED}

${CUI_QINGY_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_QINGY_TEMP} || exit 1 ;\
		case 'x'${CUI_QINGY_VER} in \
		0.9.9) \
			[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
			cat configure.OLD \
				| sed '/HEADERS=/ s%curses.h term.h%ncurses/curses.h ncurses/term.h%' \
				> configure ;\
			chmod a+x configure ;\
			\
			[ -r src/libraries/misc.c.OLD ] || mv src/libraries/misc.c src/libraries/misc.c.OLD || exit 1 ;\
			cat src/libraries/misc.c.OLD \
				| sed '/#include/ s%curses.h%ncurses/curses.h%' \
				| sed '/#include/ s%term.h%ncurses/term.h%' \
				> src/libraries/misc.c \
		;; \
		esac ;\
		\
		CC=${CTI_GCC} \
		  CFLAGS="-I${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/include" \
		  LDFLAGS="-L${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib -lncurses" \
			./configure --prefix=/usr \
			  --build=${NTI_SPEC} \
			  --host=${CTI_SPEC} \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

CUI_QINGY_BUILT=${EXTTEMP}/${CUI_QINGY_TEMP}/libqingy.a

.PHONY: cui-qingy-built
cui-qingy-built: cui-qingy-configured ${CUI_QINGY_BUILT}

${CUI_QINGY_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_QINGY_TEMP} || exit 1 ;\
		make || exit 1 \
	) || exit 1



# ,-----
# |	Install
# +-----

CUI_QINGY_INSTALLED=${CUI_QINGY_INSTTEMP}/usr/bin/qingy

.PHONY: cui-qingy-installed

cui-qingy-installed: cui-qingy-built ${CUI_QINGY_INSTALLED}

${CUI_QINGY_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	for DIR in /usr/bin /usr/include /usr/man/man1 /usr/man/man8 ; do \
		mkdir -p ${CUI_QINGY_INSTTEMP}/$${DIR} || exit 1 ;\
	done
	( cd ${EXTTEMP}/${CUI_QINGY_TEMP} || exit 1 ;\
		make DESTDIR=${CUI_QINGY_INSTTEMP} install || exit 1 \
	) || exit 1


.PHONY: cui-qingy
cui-qingy: cti-cross-gcc cti-ncurses cui-uClibc-rt cui-ncurses cui-qingy-installed

TARGETS+= cui-qingy

endif	# HAVE_QINGY_CONFIG
