# Config/ENV/fstools.mak

# -----
# toolchain: buildtype.mak sets CFG_ROOT
include Config/ENV/buildtype.mak


# -----
# supported packages

include ${CFG_root}/fstools/adflib/v0.7.12.mak
include ${CFG_ROOT}/fstools/dosfstools/v4.0.mak
include ${CFG_ROOT}/fstools/dvdrtools/v0.2.1.mak
include ${CFG_ROOT}/fstools/e2fsprogs/v1.43.1.mak
include ${CFG_ROOT}/fstools/genext2fs/v1.4.1.mak
include ${CFG_ROOT}/fstools/mtd-utils/v1.4.4.mak
include ${CFG_ROOT}/fstools/squashfs/v4.3.mak
