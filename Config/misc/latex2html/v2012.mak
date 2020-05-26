# latex2html v2012		[ since v4.07, c.2004-01-22 ]
# last mod WmT, 2013-01-17	[ (c) and GPLv2 1999-2013* ]

ifneq (${HAVE_LATEX2HTML_CONFIG},y)
HAVE_LATEX2HTML_CONFIG:=y

#DESCRLIST+= "'nti-latex2html' -- latex2html"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak
#
#ifneq (${HAVE_NATIVE_GCC_VER},)
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v${HAVE_NATIVE_GCC_VER}.mak
#endif

ifeq (${LATEX2HTML_VERSION},)
#LATEX2HTML_VERSION=2002-2-1-20050114
LATEX2HTML_VERSION=2012
endif

#LATEX2HTML_SRC= ${SOURCES}/l/latex2html_2002-2-1-20050114.orig.tar.gz
LATEX2HTML_SRC= ${SOURCES}/l/latex2html-2012.tgz
#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/multiverse/l/latex2html/latex2html_2002-2-1-20050114.orig.tar.gz
URLS+= http://mirrors.ctan.org/support/latex2html/latex2html-2012.tgz

NTI_LATEX2HTML_TEMP=nti-latex2html-${LATEX2HTML_VERSION}

NTI_LATEX2HTML_EXTRACTED=${EXTTEMP}/${NTI_LATEX2HTML_TEMP}/configure
NTI_LATEX2HTML_CONFIGURED=${EXTTEMP}/${NTI_LATEX2HTML_TEMP}/config.status
NTI_LATEX2HTML_BUILT=${EXTTEMP}/${NTI_LATEX2HTML_TEMP}/latex2html
NTI_LATEX2HTML_INSTALLED=${NTI_TC_ROOT}/usr/bin/latex2html


# ,-----
# |	Extract
# +-----

${NTI_LATEX2HTML_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/latex2html-${LATEX2HTML_VERSION} ] || rm -rf ${EXTTEMP}/latex2html-${LATEX2HTML_VERSION}
	zcat ${LATEX2HTML_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LATEX2HTML_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LATEX2HTML_TEMP}
	mv ${EXTTEMP}/latex2html-${LATEX2HTML_VERSION} ${EXTTEMP}/${NTI_LATEX2HTML_TEMP}


# ,-----
# |	Configure
# +-----

${NTI_LATEX2HTML_CONFIGURED}: ${NTI_LATEX2HTML_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LATEX2HTML_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


# ,-----
# |	Build
# +-----

${NTI_LATEX2HTML_BUILT}: ${NTI_LATEX2HTML_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LATEX2HTML_TEMP} || exit 1 ;\
		make \
	)


# ,-----
# |	Install
# +-----

## [101007] NB. 'latex2html' might be the 'freelatex2html' symlink!!

${NTI_LATEX2HTML_INSTALLED}: ${NTI_LATEX2HTML_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LATEX2HTML_TEMP} || exit 1 ;\
		[ -L ${NTI_TC_ROOT}/usr/bin/latex2html ] && rm -f ${NTI_TC_ROOT}/usr/bin/latex2html ;\
		make install \
	)

.PHONY: nti-latex2html
nti-latex2html: ${NTI_LATEX2HTML_INSTALLED}

ALL_NTI_TARGETS+= nti-latex2html

endif	# HAVE_LATEX2HTML_CONFIG
