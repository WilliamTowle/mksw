# microwindows v0.9x		[ EARLIEST: v0.90, c.2005-04-05 ]
# last mod WmT, 2017-03-22	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_MICROWINDOWS_CONFIG},y)
HAVE_MICROWINDOWS_CONFIG:=y

#DESCRLIST+= "'cui-microwindows' -- microwindows"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MICROWINDOWS_VERSION},)
#MICROWINDOWS_VERSION=0.90
#MICROWINDOWS_VERSION=full-0.91
MICROWINDOWS_VERSION=full-0.92
## snapshot dated Feb 2011 ... is bobbins
##MICROWINDOWS_VER=full-snapshot
endif

MICROWINDOWS_SRC=${SOURCES}/m/microwindows-${MICROWINDOWS_VERSION}.tar.gz
URLS+= ftp://microwindows.censoft.com/pub/microwindows/microwindows-${MICROWINDOWS_VERSION}.tar.gz

include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_MICROWINDOWS_TEMP=nti-microwindows-${MICROWINDOWS_VERSION}

NTI_MICROWINDOWS_EXTRACTED=${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}/README
NTI_MICROWINDOWS_CONFIGURED=${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}/src/Makefile.rules.OLD
NTI_MICROWINDOWS_BUILT=${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}/src/bin/launcher
NTI_MICROWINDOWS_INSTALLED=${NTI_TC_ROOT}/opt/microwindows/bin/launcher

## ,-----
## |	Extract
## +-----

## with X11=Y, nanox/clientfb.o fails to build - no asm/page.h

${NTI_MICROWINDOWS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/microwindows-${MICROWINDOWS_VERSION} ] || rm -rf ${EXTTEMP}/microwindows-${MICROWINDOWS_VERSION}
	zcat ${MICROWINDOWS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}
ifeq ($(shell echo ${MICROWINDOWS_VERSION} | sed 's/full-0.[0-9]*//'),)
	mv ${EXTTEMP}/$(shell echo ${MICROWINDOWS_VERSION} | sed 's/full/microwindows/') ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}
else
	mv ${EXTTEMP}/microwindows-${MICROWINDOWS_VERSION} ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}
endif


## ,-----
## |	Configure
## +-----

## Arch.rules *is not* the place to set CFLAGS/LDFLAGS
## Mentions of /usr/lib, /usr/local/lib, /usr/include in 'config'
## 'THREADSAFE=N' avoids pthreads-specific code in lock macro expansion

${NTI_MICROWINDOWS_CONFIGURED}: ${NTI_MICROWINDOWS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP} || exit 1 ;\
		case ${MICROWINDOWS_VERSION} in \
		0.90|full-0.91) \
			mv src/Makefile.rules src/Makefile.rules.OLD || exit 1 ;\
			cat src/Makefile.rules.OLD \
				| sed '/^INSTALL/ s/..INSTALL_OWNER[12].//' \
				> src/Makefile.rules || exit 1 ;\
			mv src/demos/Makefile src/demos/Makefile.OLD || exit 1 ;\
			cat src/demos/Makefile.OLD \
				| sed '/dirs =/ { s/^#// ; s/nxscribble// }'\
				> src/demos/Makefile || exit 1 ;\
			mv src/mwin/winevent.c src/mwin/winevent.c.OLD || exit 1 ;\
			cat src/mwin/winevent.c.OLD \
				| sed '/#if !(/ { s%if%if 0 /*% ; s%$$% */% }' \
				> src/mwin/winevent.c || exit 1 ;\
			mv src/demos/nanowm/wlist.c src/demos/nanowm/wlist.c.OLD || exit 1 ;\
			cat src/demos/nanowm/wlist.c.OLD \
				| sed '/^static win / s/static//' \
				> src/demos/nanowm/wlist.c || exit 1 \
		;; \
		full-0.92) \
			[ -r src/drivers/mou_ser.c.OLD ] || mv src/drivers/mou_ser.c src/drivers/mou_ser.c.OLD || exit 1 ;\
			cat src/drivers/mou_ser.c.OLD \
				| sed '/define MOUSE_PORT/	s%/dev/mouse%/dev/psaux%' \
				> src/drivers/mou_ser.c \
		;; \
		*-snapshot) \
			find ./ -name Makefile | while read F ; do \
				mv $${F} $${F}.OLD || exit 1 ;\
				sed '/fonts/ s/^/\n\n#/' $${F}.OLD > $${F} || exit 1 ;\
			done ;\
			[ -r src/drivers/mou_ser.c.OLD ] || mv src/drivers/mou_ser.c src/drivers/mou_ser.c.OLD || exit 1 ;\
			cat src/drivers/mou_ser.c.OLD \
				| sed '/define MOUSE_PORT/	s%/dev/mouse%/dev/psaux%' \
				> src/drivers/mou_ser.c \
		;; \
		*) \
			echo "Configure: Unexpected MICROWINDOWS_VER ${MICROWINDOWS_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		[ -r src/Arch.rules.OLD ] || mv src/Arch.rules src/Arch.rules.OLD || exit 1 ;\
		cat src/Arch.rules.OLD \
			| sed '/COMPILER/ s%gcc%'${NTI_GCC}'%' \
			| sed '/CFLAGS/ s%$$% -I'${NTI_TC_ROOT}'/usr/include/ -fPIC%' \
			| sed '/LDFLAGS/ s%$$% -L'${NTI_TC_ROOT}'/usr/lib/%' \
			> src/Arch.rules || exit 1 ;\
		[ -r src/config ] || mv src/config src/config.OLD || exit 1 ;\
		cat src/Configs/config.fb \
			| sed '/^VERBOSE/	s/N$$/Y/' \
			| sed '/^SHAREDLIBS[ 	]*=/	s/Y$$/N/' \
			| sed '/^THREADSAFE[ 	]*=/	s/Y$$/N/' \
			| sed '/^GPMMOUSE[ 	]*=/	s/Y$$/N/' \
			| sed '/^NOMOUSE[ 	]*=/	s/Y$$/N/' \
			| sed '/^SERMOUSE[ 	]*=/	s/N$$/Y/' \
			| sed '/^VTSWITCH[ 	]*=/	s/Y$$/N/' \
			| sed 's%/usr/local/lib%'${NTI_TC_ROOT}'/usr/lib%' \
			| sed 's%/usr/lib%'${NTI_TC_ROOT}'/usr/lib%' \
			| sed 's%/usr/include%'${NTI_TC_ROOT}'/usr/include%' \
			> src/config || exit 1 ;\
		[ -r src/Makefile.rules.OLD ] || mv src/Makefile.rules src/Makefile.rules.OLD || exit 1 ;\
		cat src/Makefile.rules.OLD \
			| sed '/# Includes/,/^$$/	{ /^INCLUDEDIRS/	s%$$% -I'${NTI_TC_ROOT}'/usr/include% }' \
			> src/Makefile.rules \
	)
#		cat src/Configs/config.svga \
#			| sed '/^VERBOSE/	s/N/Y/' \
#			| sed '/^ARCH/	s/NATIVE/CUSTOM/' \
#			| sed '/^GPMMOUSE[ 	]*=/	s/Y/N/' \
#			| sed '/^NOMOUSE[ 	]*=/	s/N$$/Y/' \
#			> src/config || exit 1 \

#			| sed '/^NANOX[ 	]*=/	s/Y$$/N/' \


## ,-----
## |	Build
## +-----

${NTI_MICROWINDOWS_BUILT}: ${NTI_MICROWINDOWS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP} || exit 1 ;\
		make -C src \
			CONFIG=${EXTTEMP}/${NTI_MICROWINDOWS_TEMP}/src/config \
			INSTALL_PREFIX=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Install
## +-----

## TODO: doesn't 'make install'

${NTI_MICROWINDOWS_INSTALLED}: ${NTI_MICROWINDOWS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MICROWINDOWS_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/opt/microwindows || exit 1 ;\
		for SD in bin include lib ; do \
			[ ! -r ${NTI_TC_ROOT}/opt/microwindows/$${SD} ] || rm -rf ${NTI_TC_ROOT}/opt/microwindows/$${SD} ;\
			cp -ar src/$${SD} ${NTI_TC_ROOT}/opt/microwindows/$${SD} || exit 1 ;\
		done \
	)

.PHONY: nti-microwindows
nti-microwindows: nti-zlib ${NTI_MICROWINDOWS_INSTALLED}

ALL_NTI_TARGETS+= nti-microwindows

endif	# HAVE_MICROWINDOWS_CONFIG
