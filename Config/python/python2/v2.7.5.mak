# python v2.7.5			[ since v2.7.5, c.2013-05-27 ]
# last mod WmT, 2013-05-28	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_PYTHON_CONFIG},y)
HAVE_PYTHON_CONFIG:=y

#DESCRLIST+= "'nti-python' -- python"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${PYTHON_VERSION},)
PYTHON_VERSION=2.7.5
endif
PYTHON_SRC=${SOURCES}/p/Python-2.7.5.tar.bz2

URLS+= http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tar.bz2

NTI_PYTHON_TEMP=nti-python-${PYTHON_VERSION}

NTI_PYTHON_EXTRACTED=${EXTTEMP}/${NTI_PYTHON_TEMP}/README
NTI_PYTHON_CONFIGURED=${EXTTEMP}/${NTI_PYTHON_TEMP}/config.log
NTI_PYTHON_BUILT=${EXTTEMP}/${NTI_PYTHON_TEMP}/python
NTI_PYTHON_INSTALLED=${NTI_TC_ROOT}/usr/bin/python

## ,-----
## |	Extract
## +-----

${NTI_PYTHON_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/python-${PYTHON_VERSION} ] || rm -rf ${EXTTEMP}/python-${PYTHON_VERSION}
	bzcat ${PYTHON_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PYTHON_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PYTHON_TEMP}
	mv ${EXTTEMP}/Python-${PYTHON_VERSION} ${EXTTEMP}/${NTI_PYTHON_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PYTHON_CONFIGURED}: ${NTI_PYTHON_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-ipv6 \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PYTHON_BUILT}: ${NTI_PYTHON_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PYTHON_INSTALLED}: ${NTI_PYTHON_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PYTHON_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-python
nti-python: ${NTI_PYTHON_INSTALLED}

ALL_NTI_TARGETS+= nti-python

endif	# HAVE_PYTHON_CONFIG
