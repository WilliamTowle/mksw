# gcc v2.7.2.3			[ since v2.7.2.3, c.2002-10-31 ]
# last mod WmT, 2009-10-10	[ (c) and GPLv2 1999-2009 ]

ifneq (${HAVE_GCC2723_CONFIG},y)
HAVE_GCC2723_CONFIG:=y

##include ${CFG_ROOT}/htc-binutils/v2.16.1.mak
##include ${CFG_ROOT}/htc-uClibc/v0.9.20.mak

DESCRLIST+= "'gcc2723' -- gcc v2.7.2.3"

GCC2723_VER:=2.7.2.3
GCC2723_SRC:=${SRCDIR}/g/gcc-${GCC2723_VER}.tar.gz

URLS+=http://www.mirror.ac.uk/sites/ftp.gnu.org/gnu/gcc/gcc-${GCC2723_VER}.tar.gz

## ,-----
## |	package extract
## +-----

GCC2723_TEMP=gcc2723-${GCC2723_VER}

GCC2723_EXTRACTED=${EXTTEMP}/${GCC2723_TEMP}/Makefile.in

.PHONY: gcc2723-extracted
gcc2723-extracted: ${GCC2723_EXTRACTED}

## 1. 'mkdir -p' helps build the install tree sanely
## 2. redirecting 'cd' output stops 'tar' barfing if CDPATH set
${GCC2723_EXTRACTED}:
	make -C ${TOPLEV} extract ARCHIVE=${GCC2723_SRC}
	mv ${EXTTEMP}/gcc-${GCC2723_VER} ${EXTTEMP}/${GCC2723_TEMP}
	( cd ${EXTTEMP}/${GCC2723_TEMP} || exit 1 ;\
		mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/-if/ s/mkdir/mkdir -p/' \
			| sed '/cd include/ s%cd include%cd include >/dev/null%' \
			> Makefile.in \
	)

## ,-----
## |	package configure
## +-----

GCC2723_CONFIGURED=${EXTTEMP}/${GCC2723_TEMP}/Makefile

.PHONY: gcc2723-configured
gcc2723-configured: gcc2723-extracted ${GCC2723_CONFIGURED}

## 1. 'host' == 'target' (not cross-compiling) -> libgcc1.a builds
#			--host=${TARGET_CPU}-unknown-linux
#			--target=${TARGET_CPU}-unknown-linux
${GCC2723_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${GCC2723_TEMP} || exit 1 ;\
		./configure \
			--prefix=${HTC_ROOT}/usr \
			--host=${TARGET_MIN_TRIPLET} \
			--target=${TARGET_MIN_TRIPLET} \
			--program-prefix=${TARGET_LEG_TRIPLET}- \
			--enable-languages=c,c++ \
			--disable-nls --disable-largefile \
			|| exit 1 \
	)

## ,-----
## |	package build
## +-----

GCC2723_BUILT=${EXTTEMP}/${GCC2723_TEMP}/c++filt

.PHONY: gcc2723-built
gcc2723-built: gcc2723-configured ${GCC2723_BUILT}

${GCC2723_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${GCC2723_TEMP} || exit 1 ;\
		make bootstrap || exit 1 ;\
		make || exit 1 \
	)

## ,-----
## |	package install
## +-----

GCC2723_INSTALLED=${HTC_ROOT}/usr/bin/i386-egr_leg-linux-gcc

.PHONY: gcc2723-installed
gcc2723-installed: gcc2723-built ${GCC2723_INSTALLED}

${GCC2723_INSTALLED}: ${HTC_ROOT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${GCC2723_TEMP} || exit 1 ;\
		make install || exit 1 \
	)

.PHONY: gcc2723
gcc2723: gcc2723-installed

TARGETS+= gcc2723

endif	# HAVE_GCC2723_CONFIG
