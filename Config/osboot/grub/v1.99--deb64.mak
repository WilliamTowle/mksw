# grub -grub2- v1.99		[ since v0.93, c.2003-06-04 ]
# last mod WmT, 2017-02-24	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_GRUB2_CONFIG},y)
HAVE_GRUB2_CONFIG:=y

#DESCRLIST+= "'nti-grub' -- GNU GrUB"
ifeq (${GRUB2_VERSION},)
#GRUB2_VERSION=0.97
GRUB2_VERSION=1.99
endif

#ifeq (${BUILD_BINUTILS},true)
#include ${CFG_ROOT}/buildtools/binutils/v2.22.mak
#endif
#include ${CFG_ROOT}/buildtools/bison/v2.5.1.mak
include ${CFG_ROOT}/buildtools/bison/v3.0.2.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

GRUB2_SRC=${SOURCES}/g/grub-${GRUB2_VERSION}.tar.gz
#URLS+=http://www.mirrorservice.org/sites/alpha.gnu.org/gnu/grub/grub-0.97.tar.gz
URLS+= ftp://ftp.gnu.org/gnu/grub/grub-1.99.tar.gz

NTI_GRUB2_TEMP=nti-grub-${GRUB2_VERSION}
NTI_GRUB2_EXTRACTED=${EXTTEMP}/${NTI_GRUB2_TEMP}/configure
NTI_GRUB2_CONFIGURED=${EXTTEMP}/${NTI_GRUB2_TEMP}/config.status
NTI_GRUB2_BUILT=${EXTTEMP}/${NTI_GRUB2_TEMP}/grub-reboot
NTI_GRUB2_INSTALLED=${NTI_TC_ROOT}/usr/sbin/grub-install


## ,-----
## |	Extract
## +-----

${NTI_GRUB2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/${NTI_GRUB2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GRUB2_TEMP}
	zcat ${GRUB2_SRC} | tar xvf - -C ${EXTTEMP}
	mv ${EXTTEMP}/grub-${GRUB2_VERSION} ${EXTTEMP}/${NTI_GRUB2_TEMP}


## ,-----
## |	Configure
## +-----


## v0.97: if host binutils >= ~2.17/18, needs CFLAGS='-Wl,--build-id=none'
## v1.99: Slax 6 [gcc 4.2.4]: "cannot create executables" if optimising
## v1.99: "attempt to move .org backwards" without optimisation
## [2017-02-24] LDFLAGS '-no-pie' subverts Debian '-pie' default

${NTI_GRUB2_CONFIGURED}: ${NTI_GRUB2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GRUB2_TEMP} || exit 1 ;\
		case ${GRUB2_VERSION} in \
		1.99|2.00) \
			[ -r grub-core/gnulib/stdio.in.h.OLD ] || mv grub-core/gnulib/stdio.in.h grub-core/gnulib/stdio.in.h.OLD || exit 1 ;\
			cat grub-core/gnulib/stdio.in.h.OLD \
				| sed '/undef gets/,/^$$/ { /WARN_ON_USE/ s%^%// % }' \
				> grub-core/gnulib/stdio.in.h \
		;; \
		esac ;\
		CFLAGS='-O2 -fno-strict-aliasing' \
		  LDFLAGS='-no-pie' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-grub-mkfont=no \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_GRUB2_BUILT}: ${NTI_GRUB2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GRUB2_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_GRUB2_INSTALLED}: ${NTI_GRUB2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GRUB2_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-grub2

#ifeq (${BUILD_BINUTILS},true)
#nti-grub2: nti-binutils nti-bison nti-flex ${NTI_GRUB2_INSTALLED}
#else
nti-grub2: nti-bison nti-flex ${NTI_GRUB2_INSTALLED}
#endif

ALL_NTI_TARGETS+= nti-grub2

endif	# HAVE_GRUB2_CONFIG
