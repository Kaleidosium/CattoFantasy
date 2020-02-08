# This file contains handlers, procedures, etc for Sprite Management in the game.
import natu

import assets

# Animation data
# --------------
# An animation is a list of frames in the spritesheet.
# Nim doesn't have good support for addressable constant data, so if we want
#  to put our animation data in ROM, we must use C as a work around.

type
    AnimDataPtr = ptr AnimData
    AnimData {.bycopy, exportc.} = object
        frames: ptr UncheckedArray[int]
        len: int
        speed: int

# Use emit to produce C code.
{.emit: """
static const AnimData animIdleData = {
  .frames = (int[]){1},
  .len = 1,
  .speed = 7,
};
static const AnimData animWalkData = {
  .frames = (int[]){3,4,5},
  .len = 3,
  .speed = 4,
};
static const AnimData *animIdle = &animIdleData;
static const AnimData *animWalk = &animWalkData;
""".}

# Bring the variables from C back into Nim
var animIdle {.importc, nodecl.}: AnimDataPtr
var animWalk {.importc, nodecl.}: AnimDataPtr


# Animation state
# ---------------

type Anim {.bycopy.} = object
    ## Holds the current state of an animation.
    data: AnimDataPtr
    pos: int
    timer: int

proc initAnim(data: AnimDataPtr): Anim {.noinit.} =
    result.data = data
    result.timer = data.speed + 1
    result.pos = 0

template frame(a: Anim): int =
    ## Get the current frame number within the sprite sheet.
    a.data.frames[a.pos]

proc update(a: var Anim) =
    ## Progress anim timer, advance to the next frame if necessary.
    if a.timer > 0:
        dec a.timer
    else:
        inc a.pos
        if a.pos >= a.data.len:
            a.pos = 0
        a.timer = a.data.speed


# Current animation state of the player:
var anim = initAnim(animWalk)
var cooldown = 180

proc updatePlayerAnim() =
    # Toggle between walking and idling every 3 seconds
    dec cooldown
    if cooldown <= 0:
        if anim.data == animIdle:
            anim = initAnim(animWalk)
        else:
            anim = initAnim(animIdle)
        cooldown = 180
    # Progress the animation
    anim.update()


# Memory locations used by our sprite:
# (in a real project these should come from allocators of some kind)
const tid = 0 # base tile in object VRAM
const oid = 0 # OAM entry number
const pal = 0 # palette slot


# amount of memory taken up by 1 frame of animation
const framePixels = 32*32
const frameBytes = framePixels div 2
const frameWords = frameBytes div sizeof(uint32)


proc PlayerSpriteHandler*() =

    irqInit()
    irqEnable(II_VBLANK)
  
    # enable sprites with 1d mapping
    dispcnt.init:
        obj = true
        obj1d = true

    # copy palette into Object PAL RAM
    memcpy16(addr palObjBank[pal], addr assets.cattoPal, assets.cattoPal.len)

    # copy an initial frame into Object VRAM
    memcpy32(addr tileMemObj[0][tid], addr assets.cattoTiles[0], frameWords)

    # hide all sprites
    for obj in mitems(oamMem):
        obj.hide()

    # set up sprite
    # set up sprite
    oamMem[oid].init:
        pos = vec2i(100, 60)
        size = s32x32
        tid = tid
        pal = pal

    while true:
        updatePlayerAnim()
        VBlankIntrWait()
        # Copy current frame of animation into Object VRAM (replacing the old frame)
        memcpy32(addr tileMemObj[0][tid], addr assets.cattoTiles[anim.frame *
                frameWords], frameWords)
