# qemu v1.5.2			[ since v0.8.2, c.200?-??-?? ]
# last mod WmT, 2013-07-31	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_QEMU_CONFIG},y)
HAVE_QEMU_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-qemu' -- qemu"

ifeq (${QEMU_VERSION},)
##QEMU_VERSION=0.10.4
##QEMU_VERSION=0.10.6
##QEMU_VERSION=0.12.0-rc1
##QEMU_VERSION=0.12.2
##QEMU_VERSION=0.12.4
##QEMU_VERSION=0.12.5
##QEMU_VERSION=0.13.0-rc1
##QEMU_VERSION=0.13.0
##QEMU_VERSION=0.14.1
#QEMU_VERSION=0.15.0
QEMU_VERSION=1.5.2
endif

#QEMU_SRC=${SOURCES}/q/qemu-${QEMU_VERSION}.tar.gz
QEMU_SRC=${SOURCES}/q/qemu-${QEMU_VERSION}.tar.bz2

# http://www.qemu.org/
#URLS+=http://download.savannah.gnu.org/releases/qemu/qemu-${QEMU_VERSION}.tar.gz
URLS+= http://wiki.qemu-project.org/download/qemu-1.5.2.tar.bz2

NTI_QEMU_TEMP=nti-qemu-${QEMU_VERSION}

NTI_QEMU_EXTRACTED=${EXTTEMP}/${NTI_QEMU_TEMP}/Makefile
NTI_QEMU_CONFIGURED=${EXTTEMP}/${NTI_QEMU_TEMP}/config-host.mak
NTI_QEMU_BUILT=${EXTTEMP}/${NTI_QEMU_TEMP}/libqemu_common.a
NTI_QEMU_INSTALLED=${NTI_TC_ROOT}/usr/bin/qemu


## ,-----
## |	Extract
## +-----


${NTI_QEMU_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/qemu-${QEMU_VERSION} ] || rm -rf ${EXTTEMP}/qemu-${QEMU_VERSION}
	bzcat ${QEMU_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_QEMU_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_QEMU_TEMP}
	mv ${EXTTEMP}/qemu-${QEMU_VERSION} ${EXTTEMP}/${NTI_QEMU_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_QEMU_CONFIGURED}: ${NTI_QEMU_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_QEMU_TEMP} || exit 1 ;\
		case ${QEMU_VERSION} in \
		0.12.*|0.13.*|0.14.*|0.15.*) \
		  sdl=yes sdl_config=${NTI_TC_ROOT}'/usr/bin/sdl-config' \
			./configure \
				--cc=${NUI_CC_PREFIX}cc \
				--extra-cflags="-O2 -I${NTI_TC_ROOT}/usr/include" \
				--prefix=${NTI_TC_ROOT}/usr \
				--target-list="i386-softmmu i386-linux-user x86_64-softmmu x86_64-linux-user mips-softmmu mips-linux-user arm-softmmu arm-linux-user" \
				--disable-curl \
				|| exit 1 \
		;; \
		1.5.2) \
		  sdl=yes sdl_config=${NTI_TC_ROOT}'/usr/bin/sdl-config' \
			./configure \
				--cc=${NUI_CC_PREFIX}cc \
				--extra-cflags="-O2 -I${NTI_TC_ROOT}/usr/include" \
				--prefix=${NTI_TC_ROOT}/usr \
				--target-list="i386-softmmu i386-linux-user x86_64-softmmu x86_64-linux-user mips-softmmu mips-linux-user arm-softmmu arm-linux-user" \
				--disable-curl \
				|| exit 1 \
		;; \
		*) \
			echo "Not tested for version ${QEMU_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

# v0.10.4: bogus Makefile preconfiguration :(
# v0.10.6: not linking with local X -- due to SDL_LIBS override
${NTI_QEMU_BUILT}: ${NTI_QEMU_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_QEMU_TEMP} || exit 1 ;\
		case ${QEMU_VERSION} in \
		0.10.4) \
			make SDL_LIBS="-L${NTI_TC_ROOT}/usr/lib -Wl,-rpath,${NTI_TC_ROOT}/usr/lib -lSDL -lpthread" \
		;; \
		0.10.6|0.12.*|0.13.*|0.14.*|0.15.*) \
			make \
		;; \
		*) \
			make SDL_LIBS="-L${NTI_TC_ROOT}/usr/lib -lSDL" \
		;; \
		esac \
	)


## ,-----
## |	Install
## +-----

${NTI_QEMU_INSTALLED}: ${NTI_QEMU_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_QEMU_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-qemu
#nti-qemu: nti-SDL nti-libX11 nti-qemu-installed
nti-qemu: ${NTI_QEMU_INSTALLED}

ALL_NTI_TARGETS+= nti-qemu

endif	# HAVE_QEMU_CONFIG
