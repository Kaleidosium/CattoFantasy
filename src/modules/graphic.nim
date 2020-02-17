# This file contains handlers, procedures, etc for Sprite Management in the game.
import natu

import assets

type
    Graphic* {.bycopy.} = object
        size*: ObjSize
        bpp*: uint8
        tid*: int
        pal*: int
        oid*: int
        flip*: bool 
