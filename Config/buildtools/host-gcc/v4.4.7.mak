# host-gcc 4.4.7		[ since v2.7.2.3, c.2002-10-14 ]
# last mod WmT, 2017-02-15	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_HOST_GCC_CONFIG},y)
HAVE_HOST_GCC_CONFIG:=y

DESCRLIST+= "'nui-host-gcc' -- host-gcc"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${HOST_GCC_VERSION},)
#|HOST_GCC_VERSION:=4.1.2
#|HOST_GCC_VERSION:=4.2.4
#HOST_GCC_VERSION:=4.3.6
HOST_GCC_VERSION:=4.4.7
#HOST_GCC_VERSION:=4.9.4
endif

HOST_GCC_SRC=${SOURCES}/g/gcc-core-${HOST_GCC_VERSION}.tar.bz2
#HOST_GCC_SRC=${SOURCES}/g/gcc-${HOST_GCC_VERSION}.tar.bz2
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${HOST_GCC_VERSION}/gcc-core-${HOST_GCC_VERSION}.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gcc/gcc-${HOST_GCC_VERSION}/gcc-${HOST_GCC_VERSION}.tar.bz2
#HOST_GCC_PATCHES=

#|ifeq (${HOST_GCC_VERSION},4.1.2)
#|HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-patches-1.3.tar.bz2
#|URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-patches-1.3.tar.bz2
#|#HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
#|#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.1.2-uclibc-patches-1.0.tar.bz2
#|endif
#|
#|ifeq (${HOST_GCC_VERSION},4.2.4)
#|HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-patches-1.1.tar.bz2
#|URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-patches-1.1.tar.bz2
#|#HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
#|#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.2.4-uclibc-patches-1.0.tar.bz2
#|endif

#|ifeq (${HOST_GCC_VERSION},4.3.6)
HOST_GCC_GMP_VERSION:= 4.3.2
#HOST_GCC_GMP_ARCHIVE:= ${SRCDIR}/g/gmp-${HOST_GCC_GMP_VERSION}.tar.bz2
HOST_GCC_GMP_ARCHIVE:= ${SOURCES}/g/gmp-${HOST_GCC_GMP_VERSION}.tar.bz2
HOST_GCC_GMP_SUBDIR:= gcc-${HOST_GCC_VERSION}/gmp
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/gmp/gmp-${HOST_GCC_GMP_VERSION}.tar.bz2

HOST_GCC_MPFR_VERSION:= 2.4.2
#MPFR_VERSION:= 3.1.0
#HOST_GCC_MPFR_ARCHIVE:= ${SRCDIR}/m/mpfr-${HOST_GCC_MPFR_VERSION}.tar.bz2
HOST_GCC_MPFR_ARCHIVE:= ${SOURCES}/m/mpfr-${HOST_GCC_MPFR_VERSION}.tar.bz2
HOST_GCC_MPFR_SUBDIR:= gcc-${HOST_GCC_VERSION}/mpfr
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpfr/mpfr-${HOST_GCC_MPFR_VERSION}.tar.bz2

# [2017-02-15] mpc not required until gcc 4.6.x+
#HOST_GCC_MPC_VERSION:= 1.0.1
##HOST_GCC_MPC_ARCHIVE:= ${SRCDIR}/m/mpc-${HOST_GCC_MPC_VERSION}.tar.gz
#HOST_GCC_MPC_ARCHIVE:= ${SOURCES}/m/mpc-${HOST_GCC_MPC_VERSION}.tar.gz
#HOST_GCC_MPC_SUBDIR:= gcc-${HOST_GCC_VERSION}/mpc
#URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/mpc/mpc-${HOST_GCC_MPC_VERSION}.tar.gz


#|HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-patches-1.0.tar.bz2
#|URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-patches-1.0.tar.bz2
#|#HOST_GCC_PATCHES+= ${SRCDIR}/g/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
#|#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gcc-4.3.6-uclibc-patches-1.0.tar.bz2
#|endif


HOST_GCC_TEMP=nui-host-gcc-${HOST_GCC_VERSION}
HOST_GCC_EXTRACTED=${EXTTEMP}/${HOST_GCC_TEMP}/configure
HOST_GCC_CONFIGURED=${EXTTEMP}/${HOST_GCC_TEMP}/config.status
HOST_GCC_BUILT=${EXTTEMP}/${HOST_GCC_TEMP}/host-${HOSTSPEC}/gcc
HOST_GCC_INSTALLED=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-gcc


# ,-----
# |	Extract
# +-----

${HOST_GCC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/gcc-${HOST_GCC_VERSION} ] || rm -rf ${EXTTEMP}/gcc-${HOST_GCC_VERSION}
	bzcat ${HOST_GCC_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${HOST_GCC_GMP_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${HOST_GCC_GMP_SUBDIR} ] ; then \
		bzcat ${HOST_GCC_GMP_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/gmp-${HOST_GCC_GMP_VERSION} ${EXTTEMP}/${HOST_GCC_GMP_SUBDIR} ;\
	fi
endif
ifneq (${HOST_GCC_MPFR_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${HOST_GCC_MPFR_SUBDIR} ] ; then \
		bzcat ${HOST_GCC_MPFR_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/mpfr-${HOST_GCC_MPFR_VERSION} ${EXTTEMP}/${HOST_GCC_MPFR_SUBDIR} ;\
	fi
endif
ifneq (${HOST_GCC_MPC_ARCHIVE},)
	if [ ! -d ${EXTTEMP}/${HOST_GCC_MPC_SUBDIR} ] ; then \
		zcat ${HOST_GCC_MPC_ARCHIVE} | tar xvf - -C ${EXTTEMP} ;\
		mv ${EXTTEMP}/mpc-${HOST_GCC_MPC_VERSION} ${EXTTEMP}/${HOST_GCC_MPC_SUBDIR} ;\
	fi
endif
	[ ! -d ${EXTTEMP}/${HOST_GCC_TEMP} ] || rm -rf ${EXTTEMP}/${HOST_GCC_TEMP}
	mv ${EXTTEMP}/gcc-${HOST_GCC_VERSION} ${EXTTEMP}/${HOST_GCC_TEMP}


# ,-----
# |	Configure
# +-----

${HOST_GCC_CONFIGURED}: ${HOST_GCC_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${HOST_GCC_TEMP} || exit 1 ;\
	  	CC=${NTI_GCC} \
	  	AR=$(shell echo ${NTI_GCC} | sed 's/g*cc$$/ar/') \
	    	  CFLAGS='-O2 -fgnu89-inline' \
		  MAKEINFO=/bin/false \
			./configure -v \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --host=${HOSTSPEC} \
			  --build=${HOSTSPEC} \
			  --target=${HOSTSPEC} \
			  --with-local-prefix=${NTI_TC_ROOT}/usr \
			  --disable-nls --disable-werror \
			  --disable-multilib \
			  --disable-libmudflap \
			  --disable-libssp \
			  --enable-languages=c \
			  --enable-shared \
			  || exit 1 \
	)


# ,-----
# |	Build
# +-----

${HOST_GCC_BUILT}: ${HOST_GCC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${HOST_GCC_TEMP} || exit 1 ;\
		make all \
	)


# ,-----
# |	Install
# +-----

${HOST_GCC_INSTALLED}: ${HOST_GCC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${HOST_GCC_TEMP} || exit 1 ;\
		make install \
	)


.PHONY: nui-host-gcc
nui-host-gcc: ${HOST_GCC_INSTALLED}

ALL_NUI_TARGETS+= nui-host-gcc

endif	# HAVE_HOST_GCC_CONFIG
