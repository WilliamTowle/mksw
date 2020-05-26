# Config/ENV/game.mak

# -----
# toolchain: buildtype.mak sets CFG_ROOT
include Config/ENV/buildtype.mak


# -----
# supported packages

include ${CFG_ROOT}/game/addt/v0.002.mak
include ${CFG_ROOT}/game/rezerwar/v0.4.2.mak
