# mksw-de configuration - build-common.mk
# last mod WmT, 2024-03-29	[ (c) and GPLv2 1999-2024 ]


ifneq (${HAVE_BUILD_COMMON_MK},y)
HAVE_BUILD_COMMON_MK:= y


## Configuration

DIR_DOWNLOADS?=${MF_DIR_TOP}/downloads
DIR_EXTTEMP?=${MF_DIR_TOP}/exttemp


## Rules

${DIR_DOWNLOADS}:
	mkdir -p "${DIR_DOWNLOADS}"

${DIR_EXTTEMP}:
	mkdir -p "${DIR_EXTTEMP}"

config-sanity:: | ${DIR_DOWNLOADS} ${DIR_EXTTEMP}

#

USAGE_TEXT+= "'show-all-uriurl' - display files to download"
USAGE_TEXT+= "'download-all' - download all files"
USAGE_TEXT+= "'verify-downloads' - verify downloads"
USAGE_TEXT+= "'all' - build all targets"

# anchor rule, no default content
show-all-uriurl::


.PHONY: download-file
download-file: | ${DIR_DOWNLOADS}
	[ -r "${DESTFILE}" ] || ( mkdir -p `dirname ${DESTFILE}` && wget "${SRCURL}" -O ${DESTFILE} )

.PHONY: download-all
download-all:
	${MAKE} -q --no-print-directory show-all-uriurl | while read URI URL ; do make download-file SRCURL=$${URL} DESTFILE=$${URI} ; done

.PHONY: verify-downloads
verify-downloads:
	${MAKE} -q --no-print-directory show-all-uriurl | while read URI URL ; do [ -r $${URI} ] || echo "NOT DOWNLOADED: $${URI}" 1>&2 ; done

.PHONY: all
all::


.PHONY: extract
extract:
	for ARCHIVE in ${ARCHIVES} ; do \
		[ -r $${ARCHIVE} ] || { echo "ARCHIVE $${ARCHIVE}: Not found" 1>&2 ; exit 1 ; } ;\
		mkdir -p ${DESTDIR} ;\
		case $${ARCHIVE} in \
		*.bz2) \
			echo "[bunzip method]" ;\
			bzip2 -dc $${ARCHIVE} | ( cd ${DESTDIR} && tar xvf - ${EXTRACT_OPTS} ) \
		;; \
		*.gz|*.tgz) \
			echo "[gunzip method]" ;\
			gzip -dc $${ARCHIVE} | ( cd ${DESTDIR} && tar xvf - ${EXTRACT_OPTS} ) \
		;; \
		*.xz) \
			echo "[gunzip method]" ;\
			xz -dc $${ARCHIVE} | ( cd ${DESTDIR} && tar xvf - ${EXTRACT_OPTS} ) \
		;; \
		*.zip) \
			echo "[pkunzip method]" ;\
			unzip $${ARCHIVE} -d ${DESTDIR} \
		;; \
		*) \
			echo "'extract': Unrecognised ARCHIVE format" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
	done


USAGE_TEXT+= "'clean' - make clean"

clean::
	rm -rf "${DIR_EXTTEMP}"


USAGE_TEXT+= "'distclean' - make fully clean"

distclean:: clean
	rm -rf "${DIR_DOWNLOADS}"


endif	## HAVE_BUILD_COMMON_MK
