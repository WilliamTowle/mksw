# cmake v3.10.2			[ since v3.10.2, c.2018-03-07 ]
# last mod WmT, 2018-03-07	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_CMAKE_CONFIG},y)
HAVE_CMAKE_CONFIG:=y

#DESCRLIST+= "'nti-cmake' -- cmake"

ifeq (${CMAKE_VERSION},)
CMAKE_VERSION=3.10.2
endif

CMAKE_SRC=${SOURCES}/c/cmake-${CMAKE_VERSION}.tar.gz
URLS+= https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz


NTI_CMAKE_TEMP=nti-cmake-${CMAKE_VERSION}
NTI_CMAKE_EXTRACTED=${EXTTEMP}/${NTI_CMAKE_TEMP}/configure
NTI_CMAKE_CONFIGURED=${EXTTEMP}/${NTI_CMAKE_TEMP}/cmake_uninstall.cmake
NTI_CMAKE_BUILT=${EXTTEMP}/${NTI_CMAKE_TEMP}/bin/cmake
#NTI_CMAKE_INSTALLED=${NTI_TC_ROOT}/usr/bin/cmake
NTI_CMAKE_INSTALLED=${EXTTEMP}/${NTI_CMAKE_TEMP}/.installed


# ,-----
# |	Extract
# +-----

${NTI_CMAKE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cmake-${CMAKE_VERSION} ] || rm -rf ${EXTTEMP}/cmake-${CMAKE_VERSION}
	#bzcat ${CMAKE_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${CMAKE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CMAKE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CMAKE_TEMP}
	mv ${EXTTEMP}/cmake-${CMAKE_VERSION} ${EXTTEMP}/${NTI_CMAKE_TEMP}


# ,-----
# |	Configure
# +-----


${NTI_CMAKE_CONFIGURED}: ${NTI_CMAKE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CMAKE_TEMP} || exit 1 ;\
		CC=/usr/bin/gcc \
		  CFLAGS='-O2' \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


# ,-----
# |	Build
# +-----

${NTI_CMAKE_BUILT}: ${NTI_CMAKE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CMAKE_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

## 'make install' keeps the date on the 'cmake' binary

${NTI_CMAKE_INSTALLED}: ${NTI_CMAKE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CMAKE_TEMP} || exit 1 ;\
		make install || exit 1 ;\
		touch ${NTI_CMAKE_INSTALLED} \
	)

.PHONY: nti-cmake
nti-cmake: ${NTI_CMAKE_INSTALLED}

ALL_NTI_TARGETS+= nti-cmake

endif	# HAVE_CMAKE_CONFIG
