#!/usr/bin/gmake

default: linux

HERE=$(shell pwd)

SRCTMP=${HERE}
TEMP=$(shell dirname ${HERE})
TOOLROOT=$(shell basename ${TEMP})
TOPLEV=$(shell dirname ${TEMP})

TARGET_MACH=i386

#UCLIBCSRC=u/uClibc-0.9.15.tar.bz2
#UCLIBCPATCH=
#UCLIBCPATH=uClibc-0.9.15
LINUXVER=2.0.39
LINUXSRC=l/linux-${LINUXVER}.tar.bz2
LINUXPATCH=
LINUXPATH=linux

PKGTEMP=pkgtemp

.PHONY: linux linux-sub

linux:
#	[ -n "${PKGNAME}" ] && [ -n "${LINUXVER}" ]
#	[ -d "${SRCXPATH}" ]
	[ -d ${TOOLROOT} ] || mkdir ${TOOLROOT}
	( cd ${TOOLROOT} && ( \
		[ -d usr ] || mkdir usr ;\
		[ -d usr/src ] || mkdir usr/src ;\
		[ -d usr/src/linux-${LINUXVER} ] || mkdir usr/src/linux-${LINUXVER} ;\
		( cd usr/src && ln -sf linux-${LINUXVER} ./linux ) \
	) || exit 1 )
#	mkdir -p ${INSTTMP}/linux${LINUXVER}-headers
	cat ${TOPLEV}/cfg/package/linux/2.0.39/srcdelta.tgz | gzip -d | ( cd ${SRCTMP}/${LINUXPATH} && tar xvf - )
	( cd ${SRCTMP}/${LINUXPATH} && ${MAKE} TOPLEV=${TOPLEV} -f ${SRCTMP}/linux.Makefile linux-sub )
	( cd ${SRCTMP}/${LINUXPATH} && tar cf - .config * ) | ( cd ${TOOLROOT}/usr/src/linux-${LINUXVER} && tar xvf - )

linux-sub:
# [lfs] make mrproper
# [lfs; "configure needs bash"] yes "" | make config
#	[ -r Makefile.OLD ] || cp Makefile Makefile.OLD
## Rewrite makefile so as not to use uClibc compiler wrapper by mistake
#	cat Makefile.OLD \
#		| sed 's%^HOSTCC.*=.*gcc%HOSTCC=/usr/bin/gcc%' \
#		> Makefile
	#make clean dep modules bzImage
	make clean
	make dep
#	( cd ${TOOLROOT} && tar cf - usr/src/linux usr/src/linux-${LINUXVER} ) | ( cd ${INSTTMP}/linux${LINUXVER}-headers && tar xvf - )
