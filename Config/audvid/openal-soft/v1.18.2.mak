# openal-soft v1.18.2		[ since v1.18.2 c. 2018-03-07 ]
# last mod WmT, 2018-03-14	[ (c) and GPLv2 1999-2018 ]

ifneq (${HAVE_OPENAL_SOFT_CONFIG},y)
HAVE_OPENAL_SOFT_CONFIG:=y

#DESCRLIST+= "'nti-openal-soft' -- openal-soft"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.13.mak

ifeq (${OPENAL_SOFT_VERSION},)
OPENAL_SOFT_VERSION=1.18.2
endif

OPENAL_SOFT_SRC=${SOURCES}/o/openal-soft-${OPENAL_SOFT_VERSION}.tar.bz2
#OPENAL_SOFT_SRC=${SOURCES}/o/openal-soft_${OPENAL_SOFT_VERSION}.orig.tar.gz
URLS+= http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.2.tar.bz2
#URLS+= http://http.debian.net/debian/pool/main/o/openal-soft/openal-soft_${OPENAL_SOFT_VERSION}.orig.tar.gz


include ${CFG_ROOT}/buildtools/cmake/v3.10.2.mak


NTI_OPENAL_SOFT_TEMP=nti-openal-soft-${OPENAL_SOFT_VERSION}

NTI_OPENAL_SOFT_EXTRACTED=${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}/ChangeLog
NTI_OPENAL_SOFT_CONFIGURED=${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}/CMakeLists.txt
NTI_OPENAL_SOFT_BUILT=${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}/build/libopenal.so.${OPENAL_SOFT_VERSION}
NTI_OPENAL_SOFT_INSTALLED=${NTI_TC_ROOT}/usr/lib/libopenal.so.${OPENAL_SOFT_VERSION}


## ,-----
## |	Extract
## +-----

${NTI_OPENAL_SOFT_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/openal-soft-${OPENAL_SOFT_VERSION} ] || rm -rf ${EXTTEMP}/openal-soft-${OPENAL_SOFT_VERSION}
	#[ ! -d ${EXTTEMP}/openal-soft-openal-soft-${OPENAL_SOFT_VERSION} ] || rm -rf ${EXTTEMP}/openal-soft-openal-soft-${OPENAL_SOFT_VERSION}
	bzcat ${OPENAL_SOFT_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${OPENAL_SOFT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}
	mv ${EXTTEMP}/openal-soft-${OPENAL_SOFT_VERSION} ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}
	#mv ${EXTTEMP}/openal-soft-openal-soft-${OPENAL_SOFT_VERSION} ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP}


## ,-----
## |	Configure
## +-----

## setting PKG_CONFIG_DIR here not effective for "moving" the file??
## TODO: ...configuration needs -DALSOFT_{UTILS|EXAMPLES|TESTS}=OFF?

${NTI_OPENAL_SOFT_CONFIGURED}: ${NTI_OPENAL_SOFT_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP} || exit 1 ;\
		( cd build && cmake \
			-D"CMAKE_INSTALL_PREFIX=${NTI_TC_ROOT}/usr" \
			-D"PKG_CONFIG_DIR=${PKG_CONFIG_CONFIG_HOST_PATH}" \
			../ || exit 1 \
		) ;\
		[ -r build/cmake_install.cmake.OLD ] || mv build/cmake_install.cmake build/cmake_install.cmake.OLD || exit 1 ;\
		cat build/cmake_install.cmake.OLD \
			| sed '/PREFIX..lib\/pkgconfig/	s%$$.*pkgconfig%'${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> build/cmake_install.cmake \
	)


## ,-----
## |	Build
## +-----

${NTI_OPENAL_SOFT_BUILT}: ${NTI_OPENAL_SOFT_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP} || exit 1 ;\
		cd build && make \
	)


## ,-----
## |	Install
## +-----

## CMake 'install' maintains the .so file date, so we touch the file

${NTI_OPENAL_SOFT_INSTALLED}: ${NTI_OPENAL_SOFT_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_OPENAL_SOFT_TEMP} || exit 1 ;\
		( cd build && make install ) ;\
		touch ${NTI_OPENAL_SOFT_INSTALLED} \
	)

##

.PHONY: nti-openal-soft
nti-openal-soft: \
	nti-pkg-config \
	${NTI_OPENAL_SOFT_INSTALLED}

ALL_NTI_TARGETS+= \
	nti-cmake \
	nti-openal-soft

endif	# HAVE_OPENAL_SOFT_CONFIG
