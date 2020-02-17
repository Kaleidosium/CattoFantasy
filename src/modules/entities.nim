# This file contains handlers for Player Characters.
import natu

import graphic

type 
    Entity {.bycopy.} = object
        position: Vec2f
        sprite: Graphic
        hitbox: int
        velocity: Vec2f
        currentAnimFrame: int
        direction: int
        obj: ObjAttr

    Player* {.bycopy.} = object
        entity: Entity
        hp, chips, cookieParts: int

    RatEnemy* {.bycopy.} = object
        entity: Entity
        isAlive: bool



