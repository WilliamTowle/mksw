# xosview v1.17			[ since v1.8.3	2009-09-04 ]
# last mod WmT, 2016-03-19	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XOSVIEW_CONFIG},y)
HAVE_XOSVIEW_CONFIG:=y

#DESCRLIST+= "'nti-xosview' -- xosview"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XOSVIEW_VERSION},)
#XOSVIEW_VERSION=1.8.3
#XOSVIEW_VERSION=1.9.1
#XOSVIEW_VERSION=1.12
XOSVIEW_VERSION=1.17
endif

#XOSVIEW_SRC=${SOURCES}/x/xosview-${XOSVIEW_VERSION}.tar.bz2
XOSVIEW_SRC=${SOURCES}/x/xosview-${XOSVIEW_VERSION}.tar.gz
#XOSVIEW_SRC=${SOURCES}/x/xosview_${XOSVIEW_VERSION}.orig.tar.gz

URLS+= http://www.pogo.org.uk/~mark/xosview/releases/xosview-${XOSVIEW_VERSION}.tar.gz
#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/x/xosview/xosview_${XOSVIEW_VERSION}.orig.tar.gz

ifeq (${XOSVIEW_NEEDS_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXpm/v3.5.8.mak
endif

NTI_XOSVIEW_TEMP=nti-xosview-${XOSVIEW_VERSION}

## '.configure' due to './configure' removal between versions
NTI_XOSVIEW_EXTRACTED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/README
NTI_XOSVIEW_CONFIGURED=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/.configure
NTI_XOSVIEW_BUILT=${EXTTEMP}/${NTI_XOSVIEW_TEMP}/xosview
NTI_XOSVIEW_INSTALLED=${NTI_TC_ROOT}/usr/bin/xosview


## ,-----
## |	Extract
## +-----

${NTI_XOSVIEW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xosview-${XOSVIEW_VERSION} ] || rm -rf ${EXTTEMP}/xosview-${XOSVIEW_VERSION}
	zcat ${XOSVIEW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XOSVIEW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XOSVIEW_TEMP}
	mv ${EXTTEMP}/xosview-${XOSVIEW_VERSION} ${EXTTEMP}/${NTI_XOSVIEW_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XOSVIEW_CONFIGURED}: ${NTI_XOSVIEW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		case ${XOSVIEW_VERSION} in \
		1.9.1) \
		  CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 \
		;; \
		1.17) \
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/.*%'${NTI_TC_ROOT}'/usr%' \
				| sed '/^CPPFLAGS/	s%-I\.%-I. -I'${NTI_TC_ROOT}'/usr/include%' \
				| sed '/^LDLIBS/	s%+=%+= -L'${NTI_TC_ROOT}'/usr/lib%' \
			> Makefile \
		;; \
		*) \
			echo "$0: CONFIGURE: Unexpected XOSVIEW_VERSION ${XOSVIEW_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		touch ${NTI_XOSVIEW_CONFIGURED} \
	)


## ,-----
## |	Build
## +-----

# [2016-03-29] PLATFORM= suits v1.17 README content

${NTI_XOSVIEW_BUILT}: ${NTI_XOSVIEW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		make PLATFORM=linux \
	)


## ,-----
## |	Install
## +-----

${NTI_XOSVIEW_INSTALLED}: ${NTI_XOSVIEW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XOSVIEW_TEMP} || exit 1 ;\
		case ${XOSVIEW_VERSION} in \
		1.9.1) \
			mkdir -p ${NTI_TC_ROOT}/usr/lib/X11/app-defaults \
		;; \
		esac ;\
		make install \
	)

##

.PHONY: nti-xosview
ifeq (${XOSVIEW_NEEDS_X11},true)
nti-xosview: nti-libX11 nti-libXpm \
	${NTI_XOSVIEW_INSTALLED}
else
nti-xosview: \
	${NTI_XOSVIEW_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-xosview

endif	# HAVE_XOSVIEW_CONFIG
