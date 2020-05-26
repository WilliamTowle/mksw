# vim v6.4			[ EARLIEST v?.?? ]
# last mod WmT, 2012-12-22	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_VIM_CONFIG},y)
HAVE_VIM_CONFIG:=y

#DESCRLIST+= "'nti-vim' -- vim"
#
#	include ${CFG_ROOT}/ENV/ifbuild.env
#	include ${CFG_ROOT}/ENV/native.mak
#	#include ${CFG_ROOT}/ENV/target.mak
#include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${VIM_VERSION},)
VIM_VERSION=6.4
endif

VIM_SRC=${SOURCES}/v/vim-${VIM_VERSION}.tar.bz2
URLS+= ftp://ftp.vim.org/pub/vim/unix/vim-${VIM_VERSION}.tar.bz2

NTI_VIM_TEMP=nti-vim-${VIM_VERSION}

NTI_VIM_EXTRACTED=${EXTTEMP}/${NTI_VIM_TEMP}/README.txt
NTI_VIM_CONFIGURED=${EXTTEMP}/${NTI_VIM_TEMP}/src/auto/config.status
NTI_VIM_BUILT=${EXTTEMP}/${NTI_VIM_TEMP}/src/vim
NTI_VIM_INSTALLED=${NTI_TC_ROOT}/usr/bin/vim


## ,-----
## |	Extract
## +-----

${NTI_VIM_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/vim-${VIM_VERSION} ] || rm -rf ${EXTTEMP}/vim-${VIM_VERSION}
	bzcat ${VIM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_VIM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_VIM_TEMP}
	mv ${EXTTEMP}/vim64 ${EXTTEMP}/${NTI_VIM_TEMP}
#	mv ${EXTTEMP}/vim-${VIM_VERSION} ${EXTTEMP}/${NTI_VIM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_VIM_CONFIGURED}: ${NTI_VIM_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIM_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_VIM_BUILT}: ${NTI_VIM_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_VIM_INSTALLED}: ${NTI_VIM_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_VIM_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-vim
nti-vim: ${NTI_VIM_INSTALLED}

ALL_NTI_TARGETS+= nti-vim

endif	# HAVE_VIM_CONFIG
