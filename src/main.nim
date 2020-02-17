# Main is the main file, of course.
import natu

# import modules/sprite

# const cbb = 0
# const sbb = 2
# const prioGui = 0

proc main() =

    irqInit()
    irqEnable(II_VBLANK)

    # sprite.PlayerSpriteHandler()

when isMainModule:
    main()
